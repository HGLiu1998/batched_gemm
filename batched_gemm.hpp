#include <hip/hip_runtime.h>


using bhalf_t = __bf16;
using half_t = _Float16;
using uint = unsigned int;
using bf16x4 = __attribute__((__vector_size__(4 * sizeof(__bf16)))) __bf16;
const int WarpSize = 64; //normally warpsize is 64 in amd GPU.

namespace wt {
template<const int BM, const int BN, const int BK, const int strideA, const int strideB>
__device__ void 
loadFromGMem(int N, int K, const bhalf_t *A, const bhalf_t *B, bhalf_t *As, bhalf_t *Bs, int innerRowA, int innerColA, int innerRowB, int innerColB) 
{

    for (uint offset = 0; offset + strideA <= BM; offset += strideA) {
        const bf16x4 temp = reinterpret_cast<const bf16x4 *>(&A[(innerRowA + offset) * K + innerRowA * 4])[0];
        As[(innerColA * 4 + 0) * BM + innerRowA + offset] = temp[0];
        As[(innerColA * 4 + 1) * BM + innerRowA + offset] = temp[1];
        As[(innerColA * 4 + 2) * BM + innerRowA + offset] = temp[2];
        As[(innerColA * 4 + 3) * BM + innerRowA + offset] = temp[3];
    }

    for (uint offset = 0; offset + strideB <= BK; offset += strideB) {
        reinterpret_cast<bf16x4 *>(&Bs[(innerRowB + offset) * BN + innerColB * 4])[0] = reinterpret_cast<const bf16x4 *>(&B[(innerRowB + offset) * N + innerColB * 4])[0];
    }
}

template<const int BM, const int BN, const int BK, const int WM, const int WN, const int WMITER, const int WNITER, const int WSUBM, const int WSUBN, const int TM, const int TN>
__device__ void
processFromSMem(float *a, float *b, float *threadResults, const bhalf_t *As, const bhalf_t *Bs, const uint warpRow, const uint warpCol, const uint threadRowInWarp, const uint threadColInWarp)
{
    for (uint dotIdx = 0; dotIdx < BK; ++dotIdx) {
        for (uint wSubRowIdx = 0 ; wSubRowIdx < WMITER; wSubRowIdx++) {
            for (uint i = 0; i < TM; ++i) {
                a[wSubRowIdx * TM + i] = As[(dotIdx * BM) + warpRow * WM + wSubRowIdx * WSUBM + threadRowInWarp * TM + i];
            }
        }
         for (uint wSubColIdx = 0 ; wSubColIdx < WNITER; wSubColIdx++) {
            for (uint i = 0; i < TN; ++i) {
                b[wSubColIdx * TN + i] = Bs[(dotIdx * BN) + warpCol * WN + wSubColIdx * WSUBN + threadColInWarp * TN + i];
            }
        }

        //warptile matmul
        for (uint wSubRowIdx = 0; wSubRowIdx < WMITER; ++wSubRowIdx) {
            for (uint wSubColIdx = 0; wSubColIdx < WNITER; ++wSubColIdx) {
                for (uint resIdxM = 0; resIdxM < TM; ++resIdxM) {
                    for (uint resIdxN = 0; resIdxN < TN; ++resIdxN) {
                        threadResults[(wSubRowIdx * TM + resIdxM) * (WNITER * TN) + (wSubColIdx * TN) + resIdxN] = a[wSubRowIdx * TM + resIdxM] * b[wSubColIdx * TN + resIdxN];
                    }
                }
            }
        }
    }
}
}

template<const int BM, const int BN, const int BK, const int WM, const int WN, const int WMITER, const int WNITER, const int TM, const int TN, const int NUM_THREADS>
__global__ void
batched_matrix_multiplication_warpTiling(uint M, uint N, uint K, uint Batch, const bhalf_t *A, const bhalf_t *B, bhalf_t *C)
{
    const int cRow = blockIdx.y;
    const int cCol = blockIdx.x;
    const int cBatch = blockIdx.z;

    // warp     
    const uint warpIdx = threadIdx.x / WarpSize;
    const uint warpCol = warpIdx % (BN / WN);
    const uint warpRow = warpIdx / (BN / WN);

    // size of warp tile
    constexpr uint WSUBM = WM / WMITER;
    constexpr uint WSUBN = WN / WNITER;

    const uint threadIdxInWarp = threadIdx.x % WarpSize;
    const uint threadRowInWarp = threadIdxInWarp % (WSUBN / TN);
    const uint threadColInWarp = threadIdxInWarp / (WSUBN / TN);

    __shared__ bhalf_t As[BM * BK];
    __shared__ bhalf_t Bs[BK * BN];

    A += cBatch * M * K + cRow * BM * K;
    B += cBatch * K * N + cCol * BN;
    C += cBatch * M * N + (cRow * BM + warpRow * WM) + (cCol * BN + warpCol * WN);

    const uint innerRowA = threadIdx.x / (BK / 4);
    const uint innerColA = threadIdx.x % (BK / 4);
    constexpr uint strideA = (NUM_THREADS * 4) / BK;
    const uint innerRowB = threadIdx.x / (BN / 4);
    const uint innerColB = threadIdx.x % (BN / 4);
    constexpr uint strideB = (NUM_THREADS * 4) / BN;

    float threadResults[WMITER * TM * WNITER * TN] = {0.0f};
    float a[WMITER * TM] = {0.0};
    float b[WNITER * TN] = {0.0};
    
    for (uint bkIdx = 0; bkIdx < K; bkIdx += BK) {
        wt::loadFromGMem<BM, BN, BK, strideA, strideB>(N, K, A, B, As, Bs, innerRowA, innerColA, innerRowB, innerColB);
        __syncthreads();
        wt::processFromSmem<BM, BN, BK, WM, WN, WMITER, WNITER, WSUBM, WSUBN, TM, TN>(a, b, threadResults, As, Bs, warpRow, warpCol, threadRowInWarp, threadColInWarp);
        A += BK;
        B += BK * N;
        __syncthreads();
    }

    for (uint wSubRowIdx = 0; wSubRowIdx < WMITER; ++wSubRowIdx) {
        for (uint wSubColIdx = 0; wSubColIdx < WNITER; ++wSubColIdx) {
            // move C pointer to current warp subtile
            bhalf_t *C_interim = C + (wSubRowIdx * WSUBM) * N + wSubColIdx * WSUBN;
            for (uint resIdxM = 0; resIdxM < TM; resIdxM += 1) {
                for (uint resIdxN = 0; resIdxN < TN; resIdxN += 4) {
                // load C vector into registers
                bf16x4 tmp = reinterpret_cast<bf16x4 *>(
                    &C_interim[(threadRowInWarp * TM + resIdxM) * N +
                                threadColInWarp * TN + resIdxN])[0];
                // perform GEMM update in reg
                const int i = (wSubRowIdx * TM + resIdxM) * (WNITER * TN) +
                                wSubColIdx * TN + resIdxN;
                tmp[0] = threadResults[i + 0];
                tmp[1] = threadResults[i + 1]; 
                tmp[2] = threadResults[i + 2];
                tmp[3] = threadResults[i + 3];
                // write back
                reinterpret_cast<bf16x4 *>(
                    &C_interim[(threadRowInWarp * TM + resIdxM) * N +
                                threadColInWarp * TN + resIdxN])[0] = tmp;
                }
            }
        }
    }
}

// normally, blockDim will limited to 256 or 512 (occ = 2). For MI300, warp threads will be 64,  WarpPerBlock will be 4 or 8.
template <const int BM, const int BN, const int BK, const int TM, const int TN>
__global__ void
batched_matrix_multiplication_2DTiling(uint M, uint N, uint K, uint Batch, const bhalf_t *A, const bhalf_t *B, bhalf_t *C)
{

    using bfloat16x4 = __attribute__ ((__vector_size__(4 * sizeof(bhalf_t)))) bhalf_t;
    using floatx4 = __attribute__ ((__vector_size__(4 * sizeof(float)))) float;

    const uint cRow = blockIdx.y;
    const uint cCol = blockIdx.x;
    const uint cBatch = blockIdx.z;

    const uint BlockTile = BM * BN;
    const uint numThreadBlockTile = (BM * BN) / (TM * TN); 

    const int threadCol = threadIdx.x % (BN / TN);
    const int threadRow = threadIdx.x / (BN / TN);

    __shared__ bhalf_t As[BM * BK];
    __shared__ bhalf_t Bs[BK * BN];

    A += cBatch * M * K + cRow * BM * K;
    B += cBatch * K * N + cCol * BN;
    C += cBatch * M * N + cRow * BM * N + cCol * BN;
    
    const uint innerRowA = threadIdx.x / BK;
    const uint innerColA = threadIdx.x % BK;
    const uint strideA = numThreadBlockTile / BK;

    const uint innerRowB = threadIdx.x / BN;
    const uint innerColB = threadIdx.x % BN;
    const uint strideB = numThreadBlockTile / BN;

    float threadResults[TM * TN] = {0.f};
    float a[TM] = {0.f};
    float b[TN] = {0.f};

    for (uint bkIdx = 0; bkIdx < K; bkIdx += BK) {
        for (uint loadOffset = 0; loadOffset < BM; loadOffset += strideA) {
            As[(innerRowA + loadOffset) * BK + innerColA] = A[(innerRowA + loadOffset) * K + innerColA];
        }
        for (uint loadOffset = 0; loadOffset < BK; loadOffset += strideB) {
            Bs[(innerRowB + loadOffset) * BN + innerColB] = B[(innerRowB + loadOffset) * N + innerColB];
        }

        __syncthreads();

        A += BK;
        B += BK * N;

        for (uint dotIdx = 0; dotIdx < BK; ++dotIdx) {
            for (uint i = 0; i < TM; ++i) {
                a[i] = As[(threadRow * TM + i) * BK + dotIdx];
            }
            for (uint i = 0; i < TN; ++i) {
                b[i] = Bs[dotIdx * BN + threadCol * TN + i];
            }
            for (uint resIdxM = 0; resIdxM < TM; ++resIdxM) {
                for (uint resIdxN = 0; resIdxN < TN; ++resIdxN) {
                    threadResults[resIdxM * TN + resIdxN] += a[resIdxM] * b[resIdxN];
                }
            }
        }

        //__builtin_amdgcn_mfma_f32_16x16x8bf16()
        __syncthreads();
    }

    for (uint resIdxM = 0; resIdxM < TM; ++resIdxM) {
        for (uint resIdxN = 0; resIdxN < TN; ++resIdxN) {
            C[(threadRow * TM + resIdxM) * N + threadCol * TN + resIdxN] = threadResults[resIdxM * TN + resIdxN];
        }
    }

    
}

template <const int BM, const int BN, const int BK, const int TM>
__global__ 
void batched_matrix_multiplication_1DTiling(int M, int N, int K, int Batch, const bhalf_t *A, const bhalf_t *B, bhalf_t *C) 
{
  // If we flip x and y here we get ~30% less performance for large matrices.
  // The current, 30% faster configuration ensures that blocks with sequential
  // blockIDs access columns of B sequentially, while sharing the same row of A.
  // The slower configuration would share columns of A, but access into B would
  // be non-sequential. So the faster configuration has better spatial locality
  // and hence a greater L2 hit rate.
  const uint cRow = blockIdx.y;
  const uint cCol = blockIdx.x;
  const uint cBatch = blockIdx.z;

  // each warp will calculate 32*TM elements, with 32 being the columnar dim.
  const int threadCol = threadIdx.x % BN;
  const int threadRow = threadIdx.x / BN;

  // allocate space for the current blocktile in SMEM
  __shared__ bhalf_t As[BM * BK];
  __shared__ bhalf_t Bs[BK * BN];

  // Move blocktile to beginning of A's row and B's column
  A += cBatch * M * K + cRow * BM * K;
  B += cBatch * K * N + cCol * BN;
  C += cBatch * M * N + cRow * BM * N + cCol * BN;

  // todo: adjust this to each thread to load multiple entries and
  // better exploit the cache sizes

  const uint innerColA = threadIdx.x % BK; // warp-level GMEM coalescing
  const uint innerRowA = threadIdx.x / BK;
  const uint innerColB = threadIdx.x % BN; // warp-level GMEM coalescing
  const uint innerRowB = threadIdx.x / BN;

  // allocate thread-local cache for results in registerfile
  float threadResults[TM] = {0.0};

  // outer loop over block tiles
  for (uint bkIdx = 0; bkIdx < K; bkIdx += BK) {
    // populate the SMEM caches
    As[innerRowA * BK + innerColA] = A[innerRowA * K + innerColA];
    Bs[innerRowB * BN + innerColB] = B[innerRowB * N + innerColB];
    __syncthreads();

    // advance blocktile
    A += BK;
    B += BK * N;

    // calculate per-thread results
    for (uint dotIdx = 0; dotIdx < BK; ++dotIdx) {
      // we make the dotproduct loop the outside loop, which facilitates
      // reuse of the Bs entry, which we can cache in a tmp var.
      float tmpB = Bs[dotIdx * BN + threadCol];
      for (uint resIdx = 0; resIdx < TM; ++resIdx) {
        threadResults[resIdx] +=
            As[(threadRow * TM + resIdx) * BK + dotIdx] * tmpB;
      }
    }
    __syncthreads();
  }

  // write out the results
  for (uint resIdx = 0; resIdx < TM; ++resIdx) {
    C[(threadRow * TM + resIdx) * N + threadCol] = threadResults[resIdx];
  }
}


template <const uint BLOCKSIZE>
__global__
void batched_matrix_multiplication_coalesce(int M, int N, int K, int Batch, const bhalf_t *A, const bhalf_t *B, bhalf_t *C)
{
    int row = blockIdx.x * blockDim.x + (threadIdx.x / BLOCKSIZE);
    int col = blockIdx.y * blockDim.y + (threadIdx.x % BLOCKSIZE);
    int batch = blockIdx.z * blockDim.z + threadIdx.z;

    float temp = 0.0f;
    for (int i = 0; i < K; ++i) {
        temp += A[batch * K * M + row * K + i] * B[batch * N * K + i * N + col];
    }
    C[batch * M * N + row * N + col] = temp;

}

__global__
void batched_matrix_multiplication_naive(int M, int N, int K, int Batch, const bhalf_t *A, const bhalf_t *B, bhalf_t *C)
{
    int row = blockIdx.x * blockDim.x + threadIdx.x;
    int col = blockIdx.y * blockDim.y + threadIdx.y;
    int batch = blockIdx.z * blockDim.z + threadIdx.z;

    float temp = 0.0f;
    for (int i = 0; i < K; ++i) {
        temp += A[batch * K * M + row * K + i] * B[batch * N * K + i * N + col];
    }
    C[batch * M * N + row * N + col] = temp;

}
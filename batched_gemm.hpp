#include <hip/hip_runtime.h>


using bhalf_t = __bf16;
using half_t = _Float16;


template<const int BM, const int BN, const int BK, const int strideA, const int strideB>
__device__ void 
loadFromGMem(int N, int K, const bhalf_t *A, const bhalf_t *B, bhalf_t *As, bhalf_t *Bs, int innerRowA, int innerColA, int innerRowB, int innerColB) 
{
    using bf16x4 = __attribute__((__vector_size__(4 * sizeof(__bf16)))) __bf16;

    for (uint offset = 0; offset + strideA <= BM; offset += strideA) {
        const bhalf_t
    }
}

template<const int BM, const int BN, const int BK, const int WM, const int WN, const int WNITER, const int TN, const int TM>
__global__ void
batched_matrix_multiplication_warpTiling(uint M, uint N, uint K, uint Batch, const bhalf_t *A, const bhalf_t *B, bhalf_t *C)
{
    const int WarpSize = 64; //normally warpsize is 64 in amd GPU.
    const int cRow = blockIdx.y;
    const int cCol = blockIdx.x;
    const int cBatch = blockIdx.z;

    // warp 
    const uint warpIdx = threadIdx.x / WarpSize;
    const uint warpCol = warpIdx % (BN / WN);
    const uint warpRow = warpIdx / (BN / WN);

    // size of warp tile
    constexpr uint WMITER = (WM * WN) / (WarpSize * TM * TN * WNITER);
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
    constexpr uint rowStrideA = (NUM_THREADS * 4) / BK;
    const uint innerRowB = threadIdx.x / (BN / 4);
    const uint innerColB = threadIdx.x % (BN / 4);
    constexpr uint rowStrideB = (NUM_THREADS * 4) / BN;

    float threadResults[WMITER * TM * WNITER * TN] = {0.0f};
    float a[WMITER * TM] = {0.0};
    float b[WNITER * TN] = {0.0};
    
    for (uint bkIdx = 0; bkIdx < K; bkIdx += BK) {
        loadFromGMem()
        __syncthreads();
        processFromSmem();
        A += BK;
        B += BK * N;
        __syncthreads();
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
#include <hip/hip_runtime.h>

// normally, blockDim will limited to 256 or 512 (occ = 2). For MI300, warp threads will be 64,  WarpPerBlock will be 4 or 8.
template <const int BM, const int BN, const int BK, const int TM, const int TN>
__global__ void
__launch_bounds__(256, 1)
// 128, 128, 8, 8, 8
batched_matrix_multiplication(uint M, uint N, uint K, uint Batch, const float *A, const float *B, float *C)
{
    const uint cRow = blockIdx.x;
    const uint cCol = blockIdx.y;
    const uint cBatch = blockIdx.z;

    const uint BlockTile = BM * BN;
    const uint numThreadBlockTile = 256;

    const int threadCol = threadIdx.x % (BN / TN);
    const int threadRow = threadIdx.x / (BN / TN);

    __shared__ float As[BM * BK];
    __shared__ float Bs[BK * BN];

    A += cBatch * M * K + cRow * BM * K;
    B += cBatch * K * N + cCol * BN;
    C += cBatch * M * N + cRow * BM * N + cCol * BN;
    
    const uint innerRowA = threadIdx.x / BK;
    const uint innerColA = threadIdx.x % BK;
    const uint strideA = 256 / BK;

    const uint innerRowB = threadIdx.x / BN;
    const uint innerColB = threadIdx.x % BN;
    const uint strideB = 256 / BN;

    float threadResults[64] = {0.0};
    float regM[8] = {0.0};
    float regN[8] = {0.0};

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
                regM[i] = As[(threadRow * TM + i) * BK + dotIdx];
            }
            for (uint i = 0; i < TN; ++i) {
                regN[i] = Bs[dotIdx * BN + threadCol * TN + i];
            }
            for (uint resIdxM = 0; resIdxM < TM; ++resIdxM) {
                for (uint resIdxN = 0; resIdxN < TN; ++resIdxN) {
                    threadResults[resIdxM * TN + resIdxN] += regM[resIdxM] * regN[resIdxN];
                }
            }
        }
        __syncthreads();
    }

    for (uint resIdxM = 0; resIdxM < TM; ++resIdxM) {
        for (uint resIdxN = 0; resIdxN < TN; ++resIdxN) {
            C[(threadRow * TM + resIdxM) * N + threadCol * TN + resIdxN] = threadResults[resIdxM * TN + resIdxN];
        }
    }

    
}
#include <hip/hip_runtime.h>

using bhalf_t = __bf16;
using half_t = _Float16;
using uint = unsigned int;
using bf16x4 = __attribute__((__vector_size__(4 * sizeof(__bf16)))) __bf16;
using floatx16 = __attribute__((__vector_size__(16 * sizeof(float)))) float;


template <const uint BM, const uint BN, const uint BK>
__global__ void
__launch_bounds__(256, 1)
batched_matrix_multiplication_matrix_core_full(uint M, uint N, uint K, uint Batch, const bhalf_t *A, const bhalf_t *B, bhalf_t *C)
{
    int blockRow = blockIdx.y;
    int blockCol = blockIdx.x;
    int blockBatch = blockIdx.z;

    int warpIdx = threadIdx.x / 64;
    int warpCol = warpIdx % 2;
    int warpRow = warpIdx / 2;

    int threadIdxInWarp = threadIdx.x % 64;
    int threadRow = threadIdxInWarp / 32; //lane0~31
    int threadCol = threadIdxInWarp % 32; 

    A += blockBatch * M * K + blockRow * BM * K;
    B += blockBatch * K * N + blockCol * BN;
    C += blockBatch * M * N + blockRow * BM * N + blockCol * BN;

    bf16x4 a, b;
    floatx16 d = {0};
    

    A += (threadCol + warpRow * 32) * K + threadRow * 4;
    B += threadRow * 4 * N + threadCol + warpCol * 32;

    for (int k = 0; k < K; k += BK) {
        for (int i = 0; i < 4; ++i) {
            a[i] = A[i + k];
            b[i] = B[(i + k) * N];
        }
        d = __builtin_amdgcn_mfma_f32_32x32x8f16(a, b, d, 0, 0, 0);
    }

    C += (4 * threadRow + warpRow * 32) * N + threadCol + warpCol * 32;
    for (int i = 0; i < 16; ++i) {
        int rowNum = i % 4;
        int rowIdx = i / 4;
        int idx = C[(rowNum + rowIdx * 8) * N];
        C[idx] += d[i];
    }
      
}


template <const uint BM, const uint BN, const uint BK>
__global__ void
__launch_bounds__(256, 1)
batched_matrix_multiplication_matrix_core(uint M, uint N, uint K, uint Batch, const bhalf_t *A, const bhalf_t *B, bhalf_t *C)
{
    int blockRow = blockIdx.y;
    int blockCol = blockIdx.x;
    int blockBatch = blockIdx.z;

    int warpIdx = threadIdx.x / 64;
    int warpCol = warpIdx % 2;
    int warpRow = warpIdx / 2;

    int threadIdxInWarp = threadIdx.x % 64;
    int threadRow = threadIdxInWarp / 32;
    int threadCol = threadIdxInWarp % 32;

    A += blockBatch * M * K + blockRow * BM * K;
    B += blockBatch * K * N + blockCol * BN;
    C += blockBatch * M * N + blockRow * BM * N + blockCol * BN;

    __shared__ bhalf_t As[BM * BK], Bs[BK * BN];

    bf16x4 a[2], b[2];
    floatx16 d[4] = {0};

    if (warpIdx == 0) {
        for (int k = 0; k < K; k += BK) {

            //__syncthreads();
            for (int i = 0; i < 4; ++i) {
                if (k==0 && blockIdx.x == 0 && blockIdx.z == 0 && blockIdx.y == 0 && threadIdx.x == 0) {
                    printf("A: (%d), B: (%d)\n", (threadCol) * K + i + 4 * threadRow + k, (threadRow * 4 + i + k) * N + threadCol);
                }
                a[0][i] = A[(threadCol) * K + i + 4 * threadRow + k];
                a[1][i] = A[(threadCol + 32) * K + i + 4 * threadRow + k];
                b[0][i] = B[(threadRow * 4 + i + k) * N + threadCol];
                b[1][i] = B[(threadRow * 4 + i + k) * N + threadCol + 32];
            }
            d[0] = __builtin_amdgcn_mfma_f32_32x32x8f16(a[0], b[0], d[0], 0, 0, 0);
            d[1] = __builtin_amdgcn_mfma_f32_32x32x8f16(a[0], b[1], d[1], 0, 0, 0);
            d[2] = __builtin_amdgcn_mfma_f32_32x32x8f16(a[1], b[0], d[2], 0, 0, 0);
            d[3] = __builtin_amdgcn_mfma_f32_32x32x8f16(a[1], b[1], d[3], 0, 0, 0);
            //__syncthreads();
        }

        for (int i = 0; i < 4; ++i) {
            int warp_y = i / 2;
            int warp_x = i % 2;
            for (int j = 0; j < 16; ++j) {
                int rowNum = j % 4;
                int rowIdx = j / 4;
                int idx = (4 * threadRow + rowNum + rowIdx * 8 + warp_y * 32) * N + threadCol + warp_x * 32;
                C[idx] += d[i][j];
                if (i == 0 && blockIdx.x == 0 && blockIdx.z == 0 && blockIdx.y == 0 && threadIdx.x == 0) {
                    printf("C: (%d)\n", idx);
                }
            }
        }
    }   
}

__global__
__launch_bounds__(1024, 1)
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

__global__
void batched_matrix_multiplication_coalesce(int M, int N, int K, int Batch, const bhalf_t *A, const bhalf_t *B, bhalf_t *C)
{
    int row = blockIdx.x * blockDim.x + (threadIdx.x / 32);
    int col = blockIdx.y * blockDim.y + (threadIdx.x % 32);
    int batch = blockIdx.z * blockDim.z + threadIdx.z;

    printf("value: %f\n", (float)C[batch * M * N + row * N + col] );
    float temp = 0.0f;
    for (int i = 0; i < K; ++i) {
        temp += A[batch * K * M + row * K + i] * B[batch * N * K + i * N + col];
    }
    C[batch * M * N + row * N + col] += temp;

}
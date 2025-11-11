#include <hip/hip_runtime.h>

using bhalf_t = __bf16;
using half_t = _Float16;
using uint = unsigned int;
using bf16x4 = __attribute__((__vector_size__(4 * sizeof(__bf16)))) __bf16;
using floatx16 = __attribute__((__vector_size__(16 * sizeof(float)))) float;
using fp16x4 = __attribute__((__vector_size__(4 * sizeof(_Float16)))) _Float16;

template <uint BM, uint BN, uint BK>
__global__ void
batched_matrix_multiplication_matrix_core_128x128(int M, int N, int K, int Batch, const bhalf_t *A, const bhalf_t *B, bhalf_t *C)
{
    // Warps <32, 8>
    // 
    const int blockRow = blockIdx.y; // M
    const int blockCol = blockIdx.x; // N
    const int blockBatch = blockIdx.z;

    const int warpIdx = threadIdx.x / 64;
    const int warpRow = warpIdx / 2; // M
    const int warpCol = warpIdx % 2; // N

    const int subM = warpRow * 64;
    const int subN = warpCol * 64;

    const uint threadIdxInWarp = threadIdx.x % 64; //0 ~ 63
    const uint threadRow = threadIdxInWarp / 32; // 0 ~ 1
    const uint threadCol = threadIdxInWarp % 32; // 0 ~ 31 


    bf16x4 a[4], b[4]; //each thread load 4 A and 4 B
    floatx16 acc[4] = {0.0f}; //each thread handle 16 C

    A += blockBatch * M * K + blockRow * BM * K;
    B += blockBatch * K * N + blockCol * BN;
    C += blockBatch * M * N + blockRow * BM * N + blockCol * BN;
    // A: 128 x K
    // B: K x 128
    // C: 128 x 128
    // Warp0: [0: 63, 0: 63], Warp1: [0:63, 64: 127], Warp2: [64: 127, 0: 63], Warp3: [64: 127, 64: 127]
    // Every warps will handle 64 x 64, which means we need 2x2 thread pattern to handel it with mfma32x32x8

    for (int k = 0; k < K; k += BK) { // k need to repeat 128 / 8 times
        for (int i = 0; i < 4; ++i) {
            a[0][i] = A[(threadCol + subM) * K+ i + 4 * threadRow + k ];
            a[1][i] = A[(threadCol + subM + 32) * K + i + 4 * threadRow + k];
            b[0][i] = B[(threadRow * 4 + i) * N + threadCol + subN];
            b[1][i] = B[(threadRow * 4 + i) * N + threadCol + subN + 32];
        }
        acc[0] = __builtin_amdgcn_mfma_f32_32x32x8f16(a[0], b[0], acc[0], 0, 0, 0); 
        acc[1] = __builtin_amdgcn_mfma_f32_32x32x8f16(a[0], b[1], acc[0], 0, 0, 0);
        acc[2] = __builtin_amdgcn_mfma_f32_32x32x8f16(a[1], b[0], acc[0], 0, 0, 0);
        acc[3] = __builtin_amdgcn_mfma_f32_32x32x8f16(a[1], b[1], acc[0], 0, 0, 0);
    }
    for (int i = 0; i < 4; ++i) {
        int i1 = i % 2; 
        int i2 = i / 2;
        for (int j = 0; j < 16; ++j) {
            int j1 = j % 4;
            int j2 = j / 4;
            int idx = (threadRow * 4 + j1 + j2 * 4 + i2 * 32) * N  + threadCol + i1 * 32;
            C[idx] += acc[i][j];
        }
    }
    /**
    for (int m = 0; m < BM; m += 32) { // M need to repeat 4 times
        d = {0.0f};
        for (int k = 0; k < K; k += 8) { // K need to repeat 128 / 8 times 
            
            for (int i = 0; i < 4; ++i) { // each thread handle 4 elements
                uint aid = (m + tidx + warpRow) * 128 + (i + tidy * 4 + k * 8); //WarpRow always 0;
                a[i] = A[aid];
                uint bid = (i + tidy * 4 + k * 8) * 512 + warpCol * 32 + tidx;
                b[i] = B[bid];
            }
            d = __builtin_amdgcn_mfma_f32_32x32x8f16(a, b, d, 0, 0, 0);
        }

        for (int i = 0; i < 4; ++i) {
            for (int j = 0; j < 4; ++j) {
                uint cidx = (i + tidy * 4 + j * 8) * 512 + warpCol * 32 + tidx;
                C[cidx] = d[i + 4 * j];
            }
        }
    }
    **/
 
}


template <const uint BM, const uint BN, const uint BK>
__global__ void
__launch_bounds__(256, 1)
batched_matrix_multiplication_matrix_core_64x64x4(uint M, uint N, uint K, uint Batch, const bhalf_t *A, const bhalf_t *B, bhalf_t *C)
{
    int blockRow = blockIdx.y;
    int blockCol = blockIdx.x;
    int blockBatch = blockIdx.z;

    int warpIdx = threadIdx.x / 64;
    int warpCol = warpIdx % 2;
    int warpRow = warpIdx / 2;

    int threadIdxInWarp = threadIdx.x % 64;
    int threadRow = threadIdxInWarp / 32;
    int threadCol = threadIdxInWarp % 32; //lane 0 - 31

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
        //d = __builtin_amdgcn_mfma_f32_32x32x8f16(a, b, d, 0, 0, 0);
        d = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a, b, d, 0, 0, 0);
    }

    C += (4 * threadRow + warpRow * 32) * N + threadCol + warpCol * 32;

    for (int i = 0; i < 16; ++i) {
        int rowNum = i % 4;
        int rowIdx = i / 4;
        int idx = (rowNum + rowIdx * 8) * N;
        C[idx] += (__bf16)d[i];
    }
      
}


template <const uint BM, const uint BN, const uint BK>
__global__ void
__launch_bounds__(256, 1)
batched_matrix_multiplication_matrix_core_64x64(uint M, uint N, uint K, uint Batch, const bhalf_t *A, const bhalf_t *B, bhalf_t *C, bool debug_level = 0)
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

    //__shared__ bhalf_t As[BM * BK], Bs[BK * BN];

    bf16x4 a[2], b[2];
    floatx16 d[4] = {0};

    if (warpIdx == 0) {
        for (int k = 0; k < K; k += BK) {
            for (int i = 0; i < 4; ++i) {
                a[0][i] = A[(threadCol) * K + i + 4 * threadRow + k];
                a[1][i] = A[(threadCol + 32) * K + i + 4 * threadRow + k];
                b[0][i] = B[(threadRow * 4 + i + k) * N + threadCol];
                b[1][i] = B[(threadRow * 4 + i + k) * N + threadCol + 32];
            }
            if (debug_level == 1 && blockIdx.x == 0 && blockIdx.z == 0 && blockIdx.y == 0 && threadIdx.x == 0) {
                for (int i = 0; i < 4; ++i) {
                    printf("A: %f, B: %f\n", (float)a[0][i], (float)b[0][i]);
                }
                for (int i = 0; i < 16; ++i) {
                     printf("D: %f\n", d[0][i]);
                }
                printf("\n");
            }
            //__builtin_amdgcn_mfma_f32_32x32x8bf16_1k
            d[0] = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a[0], b[0], d[0], 0, 0, 0);
            d[1] = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a[0], b[1], d[1], 0, 0, 0);
            d[2] = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a[1], b[0], d[2], 0, 0, 0);
            d[3] = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a[1], b[1], d[3], 0, 0, 0);
        }

        for (int i = 0; i < 4; ++i) {
            int warp_y = i / 2;
            int warp_x = i % 2;
            for (int j = 0; j < 16; ++j) {
                int rowNum = j % 4;
                int rowIdx = j / 4;
                int idx = (4 * threadRow + rowNum + rowIdx * 8 + warp_y * 32) * N + threadCol + warp_x * 32;
                C[idx] += (__bf16)(d[i][j]);
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
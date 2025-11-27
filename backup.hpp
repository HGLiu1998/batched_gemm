#include <hip/hip_runtime.h>


using bhalf_t = __bf16;
using half_t = _Float16;
using uint = unsigned int;
using bf16x4 = __attribute__((__vector_size__(4 * sizeof(__bf16)))) __bf16;
using floatx16 = __attribute__((__vector_size__(16 * sizeof(float)))) float;


// input 128 x 128 matrix
// 256 threads for each block (4 warps)

// <8, 128, 128>
template <uint BK, uint BM, uint BN>
__global__ void
batched_matrix_multiplication_matrix_core(int M, int N, int K, int Batch, const bhalf_t *A, const bhalf_t *B, bhalf_t *C)
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
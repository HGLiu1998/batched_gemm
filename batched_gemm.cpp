#include <cmath>
#include <cstdio>
#include <sys/time.h>
#include <iostream>
#include <hip/hip_runtime.h>
#include "batched_gemm.hpp"

using namespace std;
#define CEIL_DIV(a, b) (a + b - 1) / b
#define HIP_CHECK_ERROR(cmd)                \
    do {                                    \
        hipError_t status = cmd;            \
        if (status != hipSuccess) {         \
            std::ostringstream ostr;                                                    \
            ostr << "HIP Function Failed (" << __FILE__ << "," << __LINE__ <<") "       \
                 << hipGetErrorString(status);                                          \
            throw std::runtime_error(ostr.str());                                       \
        }                                                                               \
    } while(0)                              \

template <typename T>
void randomize_matrix(T* mat, int N) {
    struct timeval time{};
    gettimeofday(&time, nullptr);
    //srand(time.tv_usec);
    srand(8773);
    for (int i = 0; i < N; ++i) {
        T temp = static_cast<float>((rand() % 5)) + 0.01 * (rand() % 5);
        temp = (rand() % 2 == 0) ? temp : temp * (-1.);
        mat[i] = temp;
    }

}

int main(int argc, char* argv[])
{
    // tokens = bs * (MTP + 1)

    hipEvent_t start, end;

    //const unsigned int tokens = 128;
    const unsigned int M = 128, K = 128, N = 512;
    const unsigned int Batch = 128;

    using type = bhalf_t;

    size_t sizeA = M * Batch * K * sizeof(type);
    size_t sizeB = Batch * K * N * sizeof(type);
    size_t sizeC = M * Batch * N * sizeof(float);
    
    type *A = nullptr, *B = nullptr, *C = nullptr, *refC = nullptr;
    type *dA = nullptr, *dB = nullptr, *dC = nullptr; //device


    A = (type*)(malloc(sizeA));
    B = (type*)(malloc(sizeB));
    C = (type*)(malloc(sizeC));

    randomize_matrix<type>(A, M * Batch * K);
    randomize_matrix<type>(B, Batch * K * N);

    //for (int i = 0 ; i < M * Batch * K; ++i) {
    //    cout << A[i] << endl;
    //} 
    
    int total_loop = 100;
    int warm_ups = 5;
    printf("Start\n");

    HIP_CHECK_ERROR(hipMalloc((void **)(&dA), sizeA));
    HIP_CHECK_ERROR(hipMalloc((void **)(&dB), sizeB));
    HIP_CHECK_ERROR(hipMalloc((void **)(&dC), sizeC));

    HIP_CHECK_ERROR(hipMemcpy(dA, A, sizeA, hipMemcpyHostToDevice));
    HIP_CHECK_ERROR(hipMemcpy(dB, B, sizeB, hipMemcpyHostToDevice));


    const uint BM = 128;
    const uint BN = 256;
    const uint BK = 16;
    const uint TN = 8;
    const uint TM = 8;


    const uint K10_NUM_THREADS = 256;
    const uint K10_BN = 128;
    const uint K10_BM = 128;
    const uint K10_BK = 16;
    const uint K10_WN = 64;
    const uint K10_WM = 64;
    const uint K10_WNITER = 2;
    const uint K10_TN = 8;
    const uint K10_TM = 8;
    constexpr uint NUM_WARPS = K10_NUM_THREADS / 64;

  // warptile in threadblocktile
  static_assert((K10_BN % K10_WN == 0) and (K10_BM % K10_WM == 0));
  static_assert((K10_BN / K10_WN) * (K10_BM / K10_WM) == NUM_WARPS);

  // threads in warpsubtile
  static_assert((K10_WM * K10_WN) % (WarpSize * K10_TM * K10_TN * K10_WNITER) ==
                0);
  const uint K10_WMITER =
      (K10_WM * K10_WN) / (32 * K10_TM * K10_TN * K10_WNITER); 
  // warpsubtile in warptile
  static_assert((K10_WM % K10_WMITER == 0) and (K10_WN % K10_WNITER == 0));

  static_assert((K10_NUM_THREADS * 4) % K10_BK == 0,
                "NUM_THREADS*4 must be multiple of K9_BK to avoid quantization "
                "issues during GMEM->SMEM tiling (loading only parts of the "
                "final row of Bs during each iteraion)");
  static_assert((K10_NUM_THREADS * 4) % K10_BN == 0,
                "NUM_THREADS*4 must be multiple of K9_BN to avoid quantization "
                "issues during GMEM->SMEM tiling (loading only parts of the "
                "final row of As during each iteration)");
  static_assert(K10_BN % (16 * K10_TN) == 0,
                "BN must be a multiple of 16*TN to avoid quantization effects");
  static_assert(K10_BM % (16 * K10_TM) == 0,
                "BM must be a multiple of 16*TM to avoid quantization effects");
  static_assert((K10_BM * K10_BK) % (4 * K10_NUM_THREADS) == 0,
                "BM*BK must be a multiple of 4*256 to vectorize loads");
  static_assert((K10_BN * K10_BK) % (4 * K10_NUM_THREADS) == 0,
                "BN*BK must be a multiple of 4*256 to vectorize loads");

  dim3 gridDim(CEIL_DIV(N, K10_BN), CEIL_DIV(M, K10_BM));
    //dim3 blockDim((BM * BN) / (TM * TN), 1, 1);
    //dim3 gridDim(CEIL_DIV(N, BN), CEIL_DIV(M, BM), CEIL_DIV(Batch, 1));

    //dim3 blockDim(32, 32, 1);
    //dim3 gridDim(CEIL_DIV(N, 32), CEIL_DIV(M, 32), CEIL_DIV(N, 32), CEIL_DIV(Batch, 1));
    
    for (int i = 0; i < warm_ups; ++i) {
        //batched_matrix_multiplication<256, 256, 32, 32, 16><<<gridDim, blockDim>>>(M, N, K, Batch, dA, dB, dC);
        //batched_matrix_multiplication_2DTiling<BM, BN, BK, TM, TN><<<gridDim, blockDim>>>(M, N, K, Batch, dA, dB, dC);
        //batched_matrix_multiplication_naive<<<gridDim, blockDim>>>(M, N, K, Batch, dA, dB, dC);
        batched_matrix_multiplication_warpTiling<K10_BM, K10_BN, K10_BK, K10_WM, K10_WN, K10_WMITER, K10_WNITER, K10_TM, K10_TN, K10_NUM_THREADS><<<gridDim, blockDim>>>(M, N, K, Batch, dA, dB, dC);
    }
    
    hipEventCreate(&start);
    hipEventCreate(&end);

    hipDeviceSynchronize();
    hipEventRecord(start, NULL);
    
    for (int i = 0; i < total_loop; ++i) {
        //batched_matrix_multiplication<256, 256, 32, 32, 16><<<gridDim, blockDim>>>(M, N, K, Batch, dA, dB, dC);
        //batched_matrix_multiplication_2DTiling<BM, BN, BK, TM, TN><<<gridDim, blockDim>>>(M, N, K, Batch, dA, dB, dC);
        //batched_matrix_multiplication_naive<<<gridDim, blockDim>>>(M, N, K, Batch, dA, dB, dC);
        batched_matrix_multiplication_warpTiling<K10_BM, K10_BN, K10_BK, K10_WM, K10_WN,  K10_WMITER, K10_WNITER, K10_TM, K10_TN, K10_NUM_THREADS><<<gridDim, blockDim>>>(M, N, K, Batch, dA, dB, dC);

    }

    float elapsed_ms;
    hipEventRecord(end, NULL);
    hipEventSynchronize(end);
    hipDeviceSynchronize();
    hipEventElapsedTime(&elapsed_ms, start, end);
    
    hipEventDestroy(start);
    hipEventDestroy(end);

    HIP_CHECK_ERROR(hipMemcpy(C, dC, sizeC, hipMemcpyDeviceToHost));

    size_t flop = (std::size_t)2 * (M * N) * K * Batch;
    float time = elapsed_ms / total_loop;
    printf("ELAPSED TIME: %.3f\n", time);
    float tflops = (float)(flop) / time / (1E9);
    printf("M: %d, N: %d, K: %d, Batch: %d, TFlops: %.3f\n", M, N, K, Batch, tflops);
    
    free(A);
    free(B);
    free(C);
    hipFree(dA);
    hipFree(dB);
    hipFree(dC);
    return 0;
}

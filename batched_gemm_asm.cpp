#include <cmath>
#include <cstdint>
#include <cstdio>
#include <sys/time.h>
#include <iostream>
#include <hip/hip_runtime.h>
//#include "batched_gemm_mfma.hpp"
#include "batched_gemm_mfma_improved.hpp"

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


void randomize_matrix(bhalf_t* mat, int N) {
    struct timeval time{};
    gettimeofday(&time, nullptr);
    //srand(time.tv_usec);
    srand(8773);
    for (int i = 0; i < N; ++i) {
        bhalf_t temp = (bhalf_t)((rand() % 5) + 0.01 * (rand() % 5));
        temp = (rand() % 2 == 0) ? temp : temp * (bhalf_t)(-1.);
        mat[i] = static_cast<bhalf_t>(temp);
    }

}

#define HSACO "test.co"
#define HSA_KERNEL "_Z39batched_gemm_128x128x16_transe_improvedILj128ELj128ELj16EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_"

int main(int argc, char* argv[])
{
    // tokens = bs * (MTP + 1)
    hipModule_t module;
    hipFunction_t kernel_func;

    hipEvent_t start, end;

    HIP_CHECK_ERROR(hipModuleLoad(&module, HSACO));
    HIP_CHECK_ERROR(hipModuleGetFunction(&kernel_func, module, HSA_KERNEL));

    //const unsigned int tokens = 128;
    const unsigned int M = 128, K = 128, N = 512;
    const unsigned int Batch = 128;

    using type = bhalf_t;

    size_t sizeA = M * Batch * K * sizeof(type);
    size_t sizeB = Batch * K * N * sizeof(type);
    size_t sizeC = M * Batch * N * sizeof(type);
    
    type *A = nullptr, *B = nullptr, *C = nullptr, *refC = nullptr;
    type *dA = nullptr, *dB = nullptr, *dC = nullptr, *dRefC = nullptr;//device


    A = (type*)(malloc(sizeA));
    B = (type*)(malloc(sizeB));
    C = (type*)(malloc(sizeC));
    refC = (type*)(malloc(sizeC));

    randomize_matrix(A, M * Batch * K);
    randomize_matrix(B, Batch * K * N);

    //for (int i = 0 ; i < M * Batch * K; ++i) {
    //    cout << A[i] << endl;
    //} 
    
    int total_loop = 100;
    int warm_ups = 50;
    printf("Start\n");

    
    HIP_CHECK_ERROR(hipMalloc((void **)(&dA), sizeA));
    HIP_CHECK_ERROR(hipMalloc((void **)(&dB), sizeB));
    HIP_CHECK_ERROR(hipMalloc((void **)(&dC), sizeC));
    //HIP_CHECK_ERROR(hipMalloc((void **)(&dRefC), sizeC));

    //HIP_CHECK_ERROR(hipMemset(dRefC, 0, sizeC));
    HIP_CHECK_ERROR(hipMemset(dC, 0, sizeC));

    HIP_CHECK_ERROR(hipMemcpy(dA, A, sizeA, hipMemcpyHostToDevice));
    HIP_CHECK_ERROR(hipMemcpy(dB, B, sizeB, hipMemcpyHostToDevice));

    const uint BM = 128;
    const uint BN = 128;
    
    dim3 gridDim(CEIL_DIV(N, BN), CEIL_DIV(M, BM), CEIL_DIV(Batch, 1)); // handle 64 x 64 x 1;
    dim3 blockDim(256, 1, 1);

    bool transpose = true;

    dim3 strideA(M * K, K, 1);
    dim3 strideB;
    if (transpose) {    
        strideB = dim3(N * K, 1, K);
    } else {
        strideB = dim3(N * K, N, 1);
    } 
    //dim3 strideB(N * K, K, 1);
    dim3 strideC(M * N, N, 1);

    //dim3 blockDim(32, 32, 1);
    //dim3 gridDim(CEIL_DIV(M, 32), CEIL_DIV(N, 32), CEIL_DIV(Batch, 1));
    float elapsed_ms = 0.0;

    struct __attribute__((packed)) {
        unsigned int m;
        unsigned int n;
        unsigned int k;
        unsigned int batch;
        void* ptr_a;
        void* ptr_b;
        void* ptr_c;
        dim3 strideA;
        dim3 strideB;
        dim3 strideC; 
    } args;

    size_t arg_size = sizeof(args);
    args.ptr_c = (void*)dC;
    args.ptr_a = (void*)dA;
    args.ptr_b = (void*)dB;
    args.m = M;
    args.n = N;
    args.k = K;
    args.batch = Batch;
    args.strideA = strideA;
    args.strideB = strideB;
    args.strideC = strideC;
    
    void* config[] = {HIP_LAUNCH_PARAM_BUFFER_POINTER, &args, HIP_LAUNCH_PARAM_BUFFER_SIZE,
                    &arg_size, HIP_LAUNCH_PARAM_END};

    //if (transpose) {
    for (int i = 0; i < warm_ups; ++i) {
        //batched_gemm_128x128x16_transe_improved<<<gridDim, blockDim>>>(M, N, K, Batch, dA, dB, dC, strideA, strideB, strideC);
        HIP_CHECK_ERROR(hipModuleLaunchKernel(kernel_func, gridDim.x, gridDim.y, gridDim.z, blockDim.x, blockDim.y, blockDim.z, 0, 0, NULL, (void**)&config ));
    }
        
    hipEventCreate(&start);
    hipEventCreate(&end);

    hipDeviceSynchronize();
    hipEventRecord(start, NULL);
        
    for (int i = 0; i < total_loop; ++i) {
        HIP_CHECK_ERROR(hipModuleLaunchKernel(kernel_func, gridDim.x, gridDim.y, gridDim.z, blockDim.x, blockDim.y, blockDim.z, 0, 0, NULL, (void**)&config ));
        //batched_gemm_128x128x16_transe_improved<<<gridDim, blockDim>>>(M, N, K, Batch, dA, dB, dC, strideA, strideB, strideC);
    }

    hipEventRecord(end, NULL);
    hipEventSynchronize(end);
    hipDeviceSynchronize();
    hipEventElapsedTime(&elapsed_ms, start, end);
        
    hipEventDestroy(start);
    hipEventDestroy(end);

    HIP_CHECK_ERROR(hipMemset(dC, 0, sizeC));
    //batched_gemm_128x128x16_transe_improved<<<gridDim, blockDim>>>(M, N, K, Batch, dA, dB, dC, strideA, strideB, strideC);
    HIP_CHECK_ERROR(hipModuleLaunchKernel(kernel_func, gridDim.x, gridDim.y, gridDim.z, blockDim.x, blockDim.y, blockDim.z, 0, 0, NULL, (void**)&config ));

    HIP_CHECK_ERROR(hipMemcpy(C, dC, sizeC, hipMemcpyDeviceToHost));

    size_t flop = (std::size_t)2 * (M * N) * K * Batch;
    float time = elapsed_ms / total_loop;
    printf("ELAPSED TIME: %.3f\n", time);
    float tflops = (float)(flop) / (time * (1E9));
    printf("M: %d, N: %d, K: %d, Batch: %d, TFlops: %.3f\n", M, N, K, Batch, tflops);

    bool pass = true; 
    for (int i = 0; i < Batch; ++i) {
        for (int j = 0; j < M; ++j) {
            for (int k = 0; k < N; ++k) {
                float temp = 0.0;
                for (int kk = 0; kk < K; ++kk) {
                    if (!transpose) {
                        temp += (float)A[i * M * K + j * K + kk] * (float)B[i * K * N + kk * N + k];
                    } else {
                        temp += (float)A[i * M * K + j * K + kk] * (float)B[i * K * N + kk + k * K];
                    }
                }
                bhalf_t result = static_cast<__bf16>(temp);
                if (fabs(result - C[i * M * N + j * N + k]) > 1e-6) {
                    printf("%f, %f mismatch\n", static_cast<float>(temp), static_cast<float>(C[i * M * N + j * N + k]));
                    pass = false;
                    break;
                }
            }
            if (!pass) {
                break;
            }
        }
        if (!pass) {
            break;
        }
    }
    if (!pass) {
        printf("BMM result is not correct\n");
    }
    
    free(A);
    free(B);
    free(C);
    hipFree(dA);
    hipFree(dB);
    hipFree(dC);
    return 0;
}

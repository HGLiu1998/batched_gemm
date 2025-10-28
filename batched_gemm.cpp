#include <cmath>
#include <cstdio>
#include <sys/time.h>
#include <iostream>
#include <hip/hip_runtime.h>

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



__global__ void 
batched_matrix_multiplication(uint M, uint N, uint K, uint Batch, const float* A, const float* B, float* C, uint stride_a, uint stride_b, uint stride_c) 
{
    const uint x = blockIdx.x * blockDim.x + threadIdx.x; 
    const uint y = blockIdx.y * blockDim.y + threadIdx.y;
    const uint z = blockIdx.z * blockDim.z + threadIdx.z;

    if (x < M && y < N && z < Batch) {
        float temp = 0.0;
        for (uint i = 0; i < K; ++i) {
            temp += A[z * M * K + x * K + i] * B[z * K * N + i * N + y];        
        }
        printf("%f\n", temp);
        C[z * M * N + x * N + y] = temp;
    }
}

void randomize_matrix(float* mat, int N) {
    struct timeval time{};
    gettimeofday(&time, nullptr);
    srand(time.tv_usec);
    for (int i = 0; i < N; ++i) {
        float temp = static_cast<float>((rand() % 5)) + 0.01 * (rand() % 5);
        temp = (rand() % 2 == 0) ? temp : temp * (-1.);
        mat[i] = temp;
    }

}

int main(int argc, char* argv[])
{
    // tokens = bs * (MTP + 1)
    const unsigned int tokens = 128;
    const unsigned int TP = 1;
    const unsigned int M = 128, K = 128, N = 512;
    const unsigned int Batch = 128; // TP = 1
    const unsigned int stride_a = 1, stride_b = 1, stride_c = 1;


    size_t sizeA = M * Batch * K * sizeof(float);
    size_t sizeB = Batch * K * N * sizeof(float);
    size_t sizeC = M * Batch * N * sizeof(float);
    
    float *A = nullptr, *B = nullptr, *C = nullptr; //host
    float *dA = nullptr, *dB = nullptr, *dC = nullptr; //devices

    A = static_cast<float*>(malloc(sizeA));
    B = static_cast<float*>(malloc(sizeB));
    C = static_cast<float*>(malloc(sizeC));

    randomize_matrix(A, M * Batch * K);
    randomize_matrix(B, Batch * K * N);

    //for (int i = 0 ; i < M * Batch * K; ++i) {
    //    cout << A[i] << endl;
    //}
    
    HIP_CHECK_ERROR(hipMalloc(reinterpret_cast<void**>(&dA), sizeA));
    HIP_CHECK_ERROR(hipMalloc(reinterpret_cast<void**>(&dB), sizeB));
    HIP_CHECK_ERROR(hipMalloc(reinterpret_cast<void**>(&dC), sizeC));

    HIP_CHECK_ERROR(hipMemcpy(dA, A, sizeA, hipMemcpyHostToDevice));
    HIP_CHECK_ERROR(hipMemcpy(dB, B, sizeB, hipMemcpyHostToDevice));

    dim3 blockDim(8, 8, 8);
    dim3 gridDim(CEIL_DIV(M, 8), CEIL_DIV(N, 8), CEIL_DIV(Batch, 8));
    batched_matrix_multiplication<<<gridDim, blockDim>>>(M, N, K, Batch, dA, dB, dC, stride_a, stride_b, stride_c);

    HIP_CHECK_ERROR(hipMemcpy(C, dC, sizeC, hipMemcpyDeviceToHost));

    free(A);
    free(B);
    free(C);
    hipFree(dA);
    hipFree(dB);
    hipFree(dC);
    return 0;
}

#include <cmath>
#include <cstdio>
#include <sys/time.h>
#include <iostream>
#include <hip/hip_runtime.h>

using namespace std;

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


__global__ void batched_matrix_multiplication()
{
    return;
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
    const int tokens = 128;
    const int TP = 1;
    const int M = 128, K = 128, N = 512;
    const int Batch = 128; // TP = 1


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

    for (int i = 0 ; i < M * Batch * K; ++i) {
        cout << A[i] << endl;
    }
    
    hipMalloc(reinterpret_cast<void**>(&dA), sizeA);
    hipMalloc(reinterpret_cast<void**>(&dB), sizeB);
    hipMalloc(reinterpret_cast<void**>(&dC), sizeC);

    

    //dim3 blcokDim();
    //dim3 gridDim();

    //HIP_CHECK_ERROR(hipMalloc())
    return 0;
}
// Example test program comparing C++ vs Assembly versions
// Compile: hipcc -O3 --amdgpu-target=gfx90a test_assembly.cpp -o test_assembly

#include <hip/hip_runtime.h>
#include <iostream>
#include <cmath>
#include <chrono>
#include "batched_gemm_mfma.hpp"
#include "batched_gemm_mfma_improved.hpp"

#define HIP_CHECK(cmd) \
    do { \
        hipError_t error = cmd; \
        if (error != hipSuccess) { \
            std::cerr << "HIP error: " << hipGetErrorString(error) \
                      << " at " << __FILE__ << ":" << __LINE__ << std::endl; \
            exit(EXIT_FAILURE); \
        } \
    } while(0)

void randomize_matrix(bhalf_t* mat, int N) {
    srand(8773);
    for (int i = 0; i < N; ++i) {
        bhalf_t temp = (bhalf_t)((rand() % 5) + 0.01 * (rand() % 5));
        temp = (rand() % 2 == 0) ? temp : temp * (bhalf_t)(-1.);
        mat[i] = static_cast<bhalf_t>(temp);
    }
}

bool verify_results(bhalf_t* result, bhalf_t* expected, int size, float tolerance = 1e-3) {
    for (int i = 0; i < size; ++i) {
        float diff = std::abs((float)result[i] - (float)expected[i]);
        if (diff > tolerance) {
            std::cerr << "Mismatch at index " << i << ": "
                      << (float)result[i] << " vs " << (float)expected[i]
                      << " (diff: " << diff << ")" << std::endl;
            return false;
        }
    }
    return true;
}

// CPU reference implementation for validation
void compute_cpu_reference(const bhalf_t* A, const bhalf_t* B, bhalf_t* C, 
                           uint M, uint N, uint K, uint Batch, bool transpose) {
    std::cout << "Computing CPU reference (this may take a moment)..." << std::endl;
    
    for (int i = 0; i < Batch; ++i) {
        for (int j = 0; j < M; ++j) {
            for (int k = 0; k < N; ++k) {
                float temp = 0.0f;
                for (int kk = 0; kk < K; ++kk) {
                    if (!transpose) {
                        // B is not transposed: B[batch][k][n]
                        temp += (float)A[i * M * K + j * K + kk] * 
                                (float)B[i * K * N + kk * N + k];
                    } else {
                        // B is transposed: B[batch][n][k]
                        temp += (float)A[i * M * K + j * K + kk] * 
                                (float)B[i * K * N + kk + k * K];
                    }
                }
                C[i * M * N + j * N + k] = static_cast<bhalf_t>(temp);
            }
        }
    }
}

bool verify_against_cpu(const bhalf_t* gpu_result, const bhalf_t* cpu_ref, 
                        uint M, uint N, uint Batch, float tolerance = 1e-3) {
    bool pass = true;
    int num_errors = 0;
    const int max_errors_to_show = 10;
    
    for (int i = 0; i < Batch; ++i) {
        for (int j = 0; j < M; ++j) {
            for (int k = 0; k < N; ++k) {
                int idx = i * M * N + j * N + k;
                float diff = std::fabs((float)gpu_result[idx] - (float)cpu_ref[idx]);
                
                if (diff > tolerance) {
                    if (num_errors < max_errors_to_show) {
                        std::cerr << "Mismatch at [batch=" << i << ", row=" << j << ", col=" << k << "]: "
                                  << "GPU=" << (float)gpu_result[idx] 
                                  << " vs CPU=" << (float)cpu_ref[idx]
                                  << " (diff=" << diff << ")" << std::endl;
                    }
                    num_errors++;
                    pass = false;
                }
            }
        }
    }
    
    if (num_errors > max_errors_to_show) {
        std::cerr << "... and " << (num_errors - max_errors_to_show) << " more errors" << std::endl;
    }
    
    if (!pass) {
        std::cerr << "Total errors: " << num_errors << " out of " << (M * N * Batch) << " elements" << std::endl;
    }
    
    return pass;
}

template<typename Func>
float benchmark_kernel(Func kernel, int warmup_iters, int bench_iters) {
    // Warmup
    for (int i = 0; i < warmup_iters; ++i) {
        kernel();
    }
    HIP_CHECK(hipDeviceSynchronize());
    
    // Benchmark
    hipEvent_t start, end;
    HIP_CHECK(hipEventCreate(&start));
    HIP_CHECK(hipEventCreate(&end));

    HIP_CHECK(hipEventRecord(start, NULL));
    for (int i = 0; i < bench_iters; ++i) {
        kernel();
    }
    
    HIP_CHECK(hipEventRecord(end, NULL));
    HIP_CHECK(hipEventSynchronize(end));
    
    float elapsed_ms;
    HIP_CHECK(hipEventElapsedTime(&elapsed_ms, start, end));

    HIP_CHECK(hipEventDestroy(start));
    HIP_CHECK(hipEventDestroy(end));

    return elapsed_ms / bench_iters;
}

int main(int argc, char* argv[]) {
    // Problem size
    const uint M = 128;
    const uint N = 512;
    const uint K = 128;
    const uint Batch = 128;
    
    const uint BM = 128;
    const uint BN = 128;
    
    std::cout << "=== Batched GEMM Assembly Optimization Test ===" << std::endl;
    std::cout << "Problem size: M=" << M << ", N=" << N << ", K=" << K 
              << ", Batch=" << Batch << std::endl;
    
    // Allocate host memory
    size_t sizeA = M * Batch * K * sizeof(bhalf_t);
    size_t sizeB = Batch * K * N * sizeof(bhalf_t);
    size_t sizeC = M * Batch * N * sizeof(bhalf_t);
    
    bhalf_t *h_A = new bhalf_t[M * Batch * K];
    bhalf_t *h_B = new bhalf_t[Batch * K * N];
    bhalf_t *h_C_hip = new bhalf_t[M * Batch * N];
    bhalf_t *h_C_asm = new bhalf_t[M * Batch * N];
    
    // Initialize matrices
    std::cout << "Initializing matrices..." << std::endl;
    randomize_matrix(h_A, M * Batch * K);
    randomize_matrix(h_B, Batch * K * N);
    
    // Allocate device memory
    bhalf_t *d_A, *d_B, *d_C;
    HIP_CHECK(hipMalloc(&d_A, sizeA));
    HIP_CHECK(hipMalloc(&d_B, sizeB));
    HIP_CHECK(hipMalloc(&d_C, sizeC));
    
    // Copy to device
    HIP_CHECK(hipMemcpy(d_A, h_A, sizeA, hipMemcpyHostToDevice));
    HIP_CHECK(hipMemcpy(d_B, h_B, sizeB, hipMemcpyHostToDevice));
    
    // Setup kernel launch parameters
    dim3 gridDim((N + BN - 1) / BN, (M + BM - 1) / BM, Batch);
    dim3 blockDim(256, 1, 1);
    
    dim3 strideA(M * K, K, 1);
    dim3 strideB(N * K, 1, K);  // Transposed B
    dim3 strideC(M * N, N, 1);
    
    std::cout << "Grid: (" << gridDim.x << ", " << gridDim.y << ", " << gridDim.z << ")" << std::endl;
    std::cout << "Block: (" << blockDim.x << ", " << blockDim.y << ", " << blockDim.z << ")" << std::endl;
    std::cout << std::endl;
    
    // ===== Test C++ Version =====
    std::cout << "Testing HIP version..." << std::endl;
    HIP_CHECK(hipMemset(d_C, 0, sizeC));
    
    auto hip_kernel = [&]() {
        batched_matrix_multiplication_matrix_core_128x128x16_transe<<<gridDim, blockDim>>>(
            M, N, K, Batch, d_A, d_B, d_C, strideA, strideB, strideC, 0);
    };
    
    float hip_time = benchmark_kernel(hip_kernel, 10, 100);
    HIP_CHECK(hipMemcpy(h_C_hip, d_C, sizeC, hipMemcpyDeviceToHost));
    
    float hip_tflops = (2.0f * M * N * K * Batch) / (hip_time * 1e9);
    
    std::cout << "  Time:   " << hip_time << " ms" << std::endl;
    std::cout << "  TFLOPs: " << hip_tflops << std::endl;
    std::cout << std::endl;
    
    // ===== Test Assembly Version =====
    std::cout << "Testing Assembly-optimized version..." << std::endl;
    HIP_CHECK(hipMemset(d_C, 0, sizeC));
    
    auto asm_kernel = [&]() {
        batched_gemm_128x128x16_transe_improved<<<gridDim, blockDim>>>(
            M, N, K, Batch, d_A, d_B, d_C, strideA, strideB, strideC);
    };
    
    float asm_time = benchmark_kernel(asm_kernel, 10, 100);
    HIP_CHECK(hipMemcpy(h_C_asm, d_C, sizeC, hipMemcpyDeviceToHost));
    
    float asm_tflops = (2.0f * M * N * K * Batch) / (asm_time * 1e9);
    
    std::cout << "  Time:   " << asm_time << " ms" << std::endl;
    std::cout << "  TFLOPs: " << asm_tflops << std::endl;
    std::cout << std::endl;
    
    // ===== Verify GPU Results Match Each Other =====
    std::cout << "Verifying GPU results match each other..." << std::endl;
    bool gpu_match = verify_results(h_C_asm, h_C_hip, M * Batch * N);
    
    if (gpu_match) {
        std::cout << "✓ HIP and Assembly GPU results match!" << std::endl;
    } else {
        std::cout << "✗ HIP and Assembly GPU results DO NOT match!" << std::endl;
    }
    std::cout << std::endl;
    
    // ===== CPU Reference Validation =====
    std::cout << "=== CPU Reference Validation ===" << std::endl;
    bhalf_t *h_C_cpu = new bhalf_t[M * Batch * N];
    
    bool transpose = true;  // B is transposed (strideB layout)
    compute_cpu_reference(h_A, h_B, h_C_cpu, M, N, K, Batch, transpose);
    
    std::cout << "Validating HIP version against CPU..." << std::endl;
    bool hip_valid = verify_against_cpu(h_C_hip, h_C_cpu, M, N, Batch, 1e-3);
    if (hip_valid) {
        std::cout << "✓ HIP version matches CPU reference!" << std::endl;
    } else {
        std::cout << "✗ HIP version does NOT match CPU reference!" << std::endl;
    }
    std::cout << std::endl;
    
    std::cout << "Validating Assembly version against CPU..." << std::endl;
    bool asm_valid = verify_against_cpu(h_C_asm, h_C_cpu, M, N, Batch, 1e-3);
    if (asm_valid) {
        std::cout << "✓ Assembly version matches CPU reference!" << std::endl;
    } else {
        std::cout << "✗ Assembly version does NOT match CPU reference!" << std::endl;
    }
    std::cout << std::endl;
    
    // ===== Performance Summary =====
    std::cout << "=== Performance Summary ===" << std::endl;
    std::cout << "HIP version:      " << hip_time << " ms (" << hip_tflops << " TFLOPs)" << std::endl;
    std::cout << "Assembly version: " << asm_time << " ms (" << asm_tflops << " TFLOPs)" << std::endl;
    
    float speedup = hip_time / asm_time;
    std::cout << "Speedup:          " << speedup << "x ";
    
    if (speedup > 1.1) {
        std::cout << "🚀 (Good improvement!)" << std::endl;
    } else if (speedup > 1.02) {
        std::cout << "✓ (Modest improvement)" << std::endl;
    } else if (speedup > 0.98) {
        std::cout << "~ (About the same)" << std::endl;
    } else {
        std::cout << "⚠ (Regression - check implementation)" << std::endl;
    }
    std::cout << std::endl;
    
    std::cout << "=== Validation Status ===" << std::endl;
    std::cout << "GPU results match:    " << (gpu_match ? "✓ PASS" : "✗ FAIL") << std::endl;
    std::cout << "HIP vs CPU:           " << (hip_valid ? "✓ PASS" : "✗ FAIL") << std::endl;
    std::cout << "Assembly vs CPU:      " << (asm_valid ? "✓ PASS" : "✗ FAIL") << std::endl;
    
    bool all_valid = gpu_match && hip_valid && asm_valid;
    if (all_valid) {
        std::cout << "\n🎉 All validations PASSED!" << std::endl;
    } else {
        std::cout << "\n⚠️  Some validations FAILED - check implementation!" << std::endl;
    }
    std::cout << std::endl;
    
    // Cleanup
    delete[] h_A;
    delete[] h_B;
    delete[] h_C_hip;
    delete[] h_C_asm;
    delete[] h_C_cpu;
    
    HIP_CHECK(hipFree(d_A));
    HIP_CHECK(hipFree(d_B));
    HIP_CHECK(hipFree(d_C));
    
    return 0;
}


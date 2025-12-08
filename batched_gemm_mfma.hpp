#include <hip/hip_runtime.h>
#include <memory>

using bhalf_t = __bf16;
using half_t = _Float16;
using uint = unsigned int;

using bf16x4 = __bf16 __attribute__((ext_vector_type(4)));
using bf16x8 = __bf16 __attribute__((ext_vector_type(8)));
using floatx16 = float __attribute__((ext_vector_type(16)));

namespace cktile
{   
template <typename Y, typename X>
__host__ __device__ Y bit_cast(const X &x)
{
    static_assert(__has_builtin(__builtin_bit_cast), "");
    static_assert(sizeof(X) == sizeof(Y), "Do not support cast between different size of type");

    return __builtin_bit_cast(Y, x);
}

__host__ __device__ float bf16_to_float(bhalf_t x)
{
    uint16_t xtemp = bit_cast<uint16_t>(x);
    union
    {
        uint32_t int32;
        float fp32;
    } u = {uint32_t(xtemp) << 16};
    return u.fp32;
}


}


#define ASM_DEBUG(maker) \
    __builtin_amdgcn_sched_barrier(0); \
    asm volatile(maker);               \
    __builtin_amdgcn_sched_barrier(0); \


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

__device__ inline float4 load_global_vec4_async(const float4* gptr) {
    float4 v;
    // Use global_load_dwordx4 which is more cache-friendly than flat_load
    asm volatile(
        "global_load_dwordx4 %0, %1, off\n"
        : "=v"(v) 
        : "v"(gptr)
        : "memory"
    );
    return v;   
}

__device__ inline void store_shared_vec(uint32_t lds_off, float2 val) {
    asm volatile(
        "ds_write_b64 %0, %1\n"
        :
        : "v"(lds_off), "v"(val)
        : "memory"
    );
}

template <const uint BM = 64, const uint BN = 64, const uint BK = 32>
__global__ void
__launch_bounds__(512, 2)
batched_matrix_multiplication_matrix_core_64x64x32_2(uint M, uint N, uint K, uint Batch, const bhalf_t *A, const bhalf_t *B, bhalf_t *C, dim3 strideA, dim3 strideB, dim3 strideC, int debug_level = 1)
{
    int blockRow = blockIdx.y;
    int blockCol = blockIdx.x;
    int blockBatch = blockIdx.z;

    int warpIdx = threadIdx.x / 64; // 0: [0-63], 1: [64-127], 2: [128-191], 3: [192-255]
    int warpCol = warpIdx % 2; // 0, 1, 0, 1
    int warpRow = warpIdx / 2; // 0, 0, 1, 1

    int threadIdxInWarp = threadIdx.x % 64;
    int threadRow = threadIdxInWarp / 32; // [0, 1]
    int threadCol = threadIdxInWarp % 32; // [0-31] 

    int strideAB = strideA.x;
    int strideAM = strideA.y;
    int strideAK = strideA.z;

    int strideBB = strideB.x;
    int strideBK = strideB.y;
    int strideBN = strideB.z;

    int strideCB = strideC.x;
    int strideCM = strideC.y;
    int strideCN = strideC.z;

    A += blockBatch * strideAB + blockRow * BM * strideAM;
    B += blockBatch * strideBB + blockCol * BN * strideBN;
    C += blockBatch * strideCB + blockRow * BM * strideCM + blockCol * BN * strideCN;

    bf16x4 a, b;
    floatx16 d = {0};
    
    // Double buffering: two sets of LDS buffers for prefetching (ping-pong pattern)
    __shared__ __attribute__((aligned(16))) bhalf_t As[2][BM * BK]; 
    __shared__ __attribute__((aligned(16))) bhalf_t Bs[2][BN * BK];
    __shared__ __attribute__((aligned(16))) bhalf_t Cs[BN * BM];
   
    uint strideM = threadIdxInWarp;
    uint strideN = threadIdxInWarp;
    uint strideK = warpIdx;

    uint aLoc = threadIdxInWarp * strideAM + strideK * 8 * strideAK;
    uint bLoc = threadIdxInWarp * strideBN + strideK * 8 * strideBK;

    // Simple linear addressing (no swizzling)
    uint asLoc = strideM * BK + strideK * 8;
    uint bsLoc = strideK * 8 + strideN * BK; // transposed 


    uint aRow = threadCol + warpRow * 32; // 0: [0-31] 1:[0-31] 2:[31-63] 3:[31-63]
    uint aCol = threadRow * 4;            // 0: [0] 1:[0] 2:[1] 3:[1]
    uint bRow = threadRow * 4;            // 0, 4  
    uint bCol = threadCol + warpCol * 32; // 0 - 31 32 - 63
    
    uint aRegLoc = aRow * BK + aCol;
    uint bRegLoc = bRow + bCol * BK; // transposed

    int writeIdx = 0;
    int readIdx = 0;
    
    //ASM_DEBUG("; Prefetch A first tile");
    *(bf16x8*)(&As[writeIdx][asLoc]) = *(bf16x8*)(&A[aLoc]);
    
    //ASM_DEBUG("; Prefetch B first tile");
    bf16x8 temp;
    #pragma unroll
    for (int i = 0; i < 8; ++i) {
        temp[i] = B[bLoc + i * strideBK];
    }
    *(bf16x8*)(&Bs[writeIdx][bsLoc]) = temp;
    __syncthreads();
    
    // Advance pointers for next iteration
    A += BK;
    B += BK * strideBK;

    // Main loop with double buffering
    for (int k = BK; k < K; k += BK) {
        // Swap read/write buffers (ping-pong)
        readIdx = writeIdx;
        writeIdx = 1 - writeIdx;
        
        //ASM_DEBUG("; Prefetch A");
        *(bf16x8*)(&As[writeIdx][asLoc]) = *(bf16x8*)(&A[aLoc]);
    
        //ASM_DEBUG("; Prefetch B");
        bf16x8 tempNext;
        #pragma unroll
        for (int i = 0; i < 8; ++i) {
            tempNext[i] = B[bLoc + i * strideBK];
        } 
        *(bf16x8*)(&Bs[writeIdx][bsLoc]) = tempNext;
        
        //ASM_DEBUG("; MFMA");
        #pragma unroll
        for (int i = 0; i < 4; ++i) {
            a = *(bf16x4*)(&As[readIdx][i * 8 + aRegLoc]);
            b = *(bf16x4*)(&Bs[readIdx][i * 8 + bRegLoc]);
            __builtin_amdgcn_s_setprio(1);
            d = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a, b, d, 0, 0, 0);
            __builtin_amdgcn_s_setprio(0);
        }
        
        // Sync before swapping buffers
        __syncthreads();
            
        A += BK;
        B += BK * strideBK;
    }
    
    // Process last tile (no prefetch needed) - interleave loads with MFMA
    readIdx = writeIdx;
    
    // Load first operand
    #pragma unroll
    for (int i = 0; i < 4; ++i) {
        a = *(bf16x4*)(&As[readIdx][i * 8 + aRegLoc]);
        b = *(bf16x4*)(&Bs[readIdx][i * 8 + bRegLoc]);
        d = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a, b, d, 0, 0, 0);
    }
    C += (4 * threadRow + warpRow * 32) * N + threadCol + warpCol * 32;


    #pragma unroll
    for (int i = 0; i < 16; ++i) {
        int rowNum = i % 4;
        int rowIdx = i / 4;
        int idx = (rowNum + rowIdx * 8) * N;
        
        bhalf_t temp;
        temp = static_cast<__bf16>(d[i]);
        C[idx] = temp;              

    }
}


template <const uint BM = 64, const uint BN = 64, const uint BK = 32>
__global__ void
__launch_bounds__(256, 2)
batched_matrix_multiplication_matrix_core_64x64x32(uint M, uint N, uint K, uint Batch, const bhalf_t *A, const bhalf_t *B, bhalf_t *C, dim3 strideA, dim3 strideB, dim3 strideC, int debug_level = 1)
{
    int blockRow = blockIdx.y;
    int blockCol = blockIdx.x;
    int blockBatch = blockIdx.z;

    int warpIdx = threadIdx.x / 64; // 0: [0-63], 1: [64-127], 2: [128-191], 3: [192-255]
    int warpCol = warpIdx % 2; // 0, 1, 0, 1
    int warpRow = warpIdx / 2; // 0, 0, 1, 1

    int threadIdxInWarp = threadIdx.x % 64;
    int threadRow = threadIdxInWarp / 32; // [0, 1]
    int threadCol = threadIdxInWarp % 32; // [0-31] 

    int strideAB = strideA.x;
    int strideAM = strideA.y;
    int strideAK = strideA.z;

    int strideBB = strideB.x;
    int strideBK = strideB.y;
    int strideBN = strideB.z;

    int strideCB = strideC.x;
    int strideCM = strideC.y;
    int strideCN = strideC.z;

    A += blockBatch * strideAB + blockRow * BM * strideAM;
    B += blockBatch * strideBB + blockCol * BN * strideBN;
    C += blockBatch * strideCB + blockRow * BM * strideCM + blockCol * BN * strideCN;

    bf16x4 a, b;
    floatx16 d = {0};
    
    // Double buffering: two sets of LDS buffers for prefetching (ping-pong pattern)
    __shared__ __attribute__((aligned(16))) bhalf_t As[2][BM * BK]; 
    __shared__ __attribute__((aligned(16))) bhalf_t Bs[2][BN * BK];
    __shared__ __attribute__((aligned(16))) bhalf_t Cs[BN * BM];
   
    uint strideM = threadIdxInWarp;
    uint strideN = threadIdxInWarp;
    uint strideK = warpIdx;

    uint aLoc = threadIdxInWarp * strideAM + strideK * 8 * strideAK;
    uint bLoc = threadIdxInWarp * strideBN + strideK * 8 * strideBK;

    // Simple linear addressing (no swizzling)
    uint asLoc = strideM * BK + strideK * 8;
    uint bsLoc = strideK * 8 + strideN * BK; // transposed 


    uint aRow = threadCol + warpRow * 32; // 0: [0-31] 1:[0-31] 2:[31-63] 3:[31-63]
    uint aCol = threadRow * 4;            // 0: [0] 1:[0] 2:[1] 3:[1]
    uint bRow = threadRow * 4;            // 0, 4  
    uint bCol = threadCol + warpCol * 32; // 0 - 31 32 - 63
    
    // Simple linear addressing (no swizzling)
    uint aRegLoc = aRow * BK + aCol;
    uint bRegLoc = bRow + bCol * BK; // transposed

    // Prefetch first tile into buffer 0
    int writeIdx = 0;
    int readIdx = 0;
    
    //ASM_DEBUG("; Prefetch first tile");
    *(bf16x8*)(&As[writeIdx][asLoc]) = *(bf16x8*)(&A[aLoc]);
    
    bf16x8 temp;
    #pragma unroll
    for (int i = 0; i < 8; ++i) {
        temp[i] = B[bLoc + i * strideBK];
    }
    *(bf16x8*)(&Bs[writeIdx][bsLoc]) = temp;
    __syncthreads();
    
    // Advance pointers for next iteration
    A += BK;
    B += BK * strideBK;

    // Main loop with double buffering
    for (int k = BK; k < K; k += BK) {
        // Swap read/write buffers (ping-pong)
        readIdx = writeIdx;
        writeIdx = 1 - writeIdx;
        
        // Interleave: Load for MFMA[0] + Start global prefetch for next tile
        a = *(bf16x4*)(&As[readIdx][0 * 8 + aRegLoc]);
        b = *(bf16x4*)(&Bs[readIdx][0 * 8 + bRegLoc]);
        
        // Start async global load during MFMA (non-blocking)
        //ASM_DEBUG("; Prefetch next tile A (async, overlapped with MFMA[0])");
        *(bf16x8*)(&As[writeIdx][asLoc]) = *(bf16x8*)(&A[aLoc]);
        
        // MFMA[0] executes while global load is in flight
        d = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a, b, d, 0, 0, 0);
        
        // Load for MFMA[1] + Continue B prefetch
        a = *(bf16x4*)(&As[readIdx][1 * 8 + aRegLoc]);
        b = *(bf16x4*)(&Bs[readIdx][1 * 8 + bRegLoc]);
        
        // Prefetch B (strided loads)
        bf16x8 tempNext;
        #pragma unroll
        for (int i = 0; i < 8; ++i) {
            tempNext[i] = B[bLoc + i * strideBK];
        }
        
        d = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a, b, d, 0, 0, 0);
        
        // Load for MFMA[2] + Store B to LDS
        a = *(bf16x4*)(&As[readIdx][2 * 8 + aRegLoc]);
        b = *(bf16x4*)(&Bs[readIdx][2 * 8 + bRegLoc]);
        
        *(bf16x8*)(&Bs[writeIdx][bsLoc]) = tempNext;
        
        d = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a, b, d, 0, 0, 0);
        
        // Load for MFMA[3]
        a = *(bf16x4*)(&As[readIdx][3 * 8 + aRegLoc]);
        b = *(bf16x4*)(&Bs[readIdx][3 * 8 + bRegLoc]);
        
        d = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a, b, d, 0, 0, 0);
        
        // Sync before swapping buffers
        __syncthreads();
            
        A += BK;
        B += BK * strideBK;
    }
    
    // Process last tile (no prefetch needed) - interleave loads with MFMA
    readIdx = writeIdx;
    
    // Load first operands
    a = *(bf16x4*)(&As[readIdx][0 * 8 + aRegLoc]);
    b = *(bf16x4*)(&Bs[readIdx][0 * 8 + bRegLoc]);
    //ASM_DEBUG("; MFMA (last tile) [0]");
    d = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a, b, d, 0, 0, 0);
    
    // Load next during MFMA execution
    a = *(bf16x4*)(&As[readIdx][1 * 8 + aRegLoc]);
    b = *(bf16x4*)(&Bs[readIdx][1 * 8 + bRegLoc]);
    //ASM_DEBUG("; MFMA (last tile) [1]");
    d = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a, b, d, 0, 0, 0);
    
    a = *(bf16x4*)(&As[readIdx][2 * 8 + aRegLoc]);
    b = *(bf16x4*)(&Bs[readIdx][2 * 8 + bRegLoc]);
    //ASM_DEBUG("; MFMA (last tile) [2]");
    d = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a, b, d, 0, 0, 0);
    
    a = *(bf16x4*)(&As[readIdx][3 * 8 + aRegLoc]);
    b = *(bf16x4*)(&Bs[readIdx][3 * 8 + bRegLoc]);
    //ASM_DEBUG("; MFMA (last tile) [3]");
    d = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a, b, d, 0, 0, 0);
    
    C += (4 * threadRow + warpRow * 32) * N + threadCol + warpCol * 32;


    #pragma unroll
    for (int i = 0; i < 16; ++i) {
        int rowNum = i % 4;
        int rowIdx = i / 4;
        int idx = (rowNum + rowIdx * 8) * N;
        
        bhalf_t temp;
        temp = static_cast<__bf16>(d[i]);
        C[idx] = temp;              

    }
}


template <const uint BM = 64, const uint BN = 64, const uint BK = 64>
__global__ void
__launch_bounds__(256, 2)
__attribute__((amdgpu_waves_per_eu(1, 1)))
batched_matrix_multiplication_matrix_core_64x64x4(uint M, uint N, uint K, uint Batch, const bhalf_t *A, const bhalf_t *B, bhalf_t *C, dim3 strideA, dim3 strideB, dim3 strideC, int debug_level = 1)
{
    int blockRow = blockIdx.y;
    int blockCol = blockIdx.x;
    int blockBatch = blockIdx.z;

    int warpIdx = threadIdx.x / 64; // 0: [0-63], 1: [64-127], 2: [128-191], 3: [192-255]
    int warpCol = warpIdx % 2; // 0, 1, 0, 1
    int warpRow = warpIdx / 2; // 0, 0, 1, 1

    int threadIdxInWarp = threadIdx.x % 64;
    int threadRow = threadIdxInWarp / 32; // [0, 1]
    int threadCol = threadIdxInWarp % 32; // [0-31] 

    int strideAB = strideA.x;
    int strideAM = strideA.y;
    int strideAK = strideA.z;

    int strideBB = strideB.x;
    int strideBK = strideB.y;
    int strideBN = strideB.z;

    int strideCB = strideC.x;
    int strideCM = strideC.y;
    int strideCN = strideC.z;

    A += blockBatch * strideAB + blockRow * BM * strideAM;
    B += blockBatch * strideBB + blockCol * BN * strideBN;
    C += blockBatch * strideCB + blockRow * BM * strideCM + blockCol * BN * strideCN;

    bf16x4 a, b;
    floatx16 d = {0};
    
    // Padded LDS buffers to avoid bank conflicts
    __shared__ __attribute__((aligned(16))) bhalf_t As[BM * BK]; 
    //__shared__ __attribute__((aligned(16))) bhalf_t Bs[BN * BK];
    // Transposed + padded LDS buffer for B to avoid bank conflicts
    __shared__ __attribute__((aligned(16))) bhalf_t Bs[BN * BK];
    __shared__ __attribute__((aligned(16))) bhalf_t Cs[BN * BM];
   
    uint aRow = threadCol + warpRow * 32; // 0: [0-31] 1:[0-31] 2:[31-63] 3:[31-63]
    uint aCol = threadRow * 4;            // 0: [0] 1:[0] 2:[1] 3:[1]
    uint bRow = threadRow * 4;            // 0, 4  
    uint bCol = threadCol + warpCol * 32; // 0 - 31 32 - 63

    uint aLoc = aRow * strideAM + aCol * strideAK;
    uint bLoc = bRow * strideBK + bCol * strideBN;

    uint asLoc = aRow * BK + aCol; // padded stride to avoid bank conflicts
    //uint bsLoc = bCol * BK + bRow;
    uint bsLoc = bRow + bCol * BK; // transposed, 

    //A += aLoc;
    //B += bLoc;

    for (int k = 0; k < K; k += BK) {

        ASM_DEBUG("; Global load to LDS");
        //ASM_DEBUG("; Load A");
        
        *(bf16x4*)(&As[asLoc]) = *(bf16x4*)(&A[aLoc]);

        ASM_DEBUG("; Load B");
        // Gather strided from global B, then store transposed into LDS with padding
        bf16x4 temp;
        #pragma unroll
        for (int i = 0; i < 4; ++i) {
            temp[i] = B[bLoc + i * strideBK];
            //Bs[bsLoc + i] = temp[i];
        }
        // Keep original non-transposed for optional debugging/comparison
        *(bf16x4*)(&Bs[bsLoc]) = temp;
        __syncthreads();
        ASM_DEBUG("; LDS load to reg");
        a = *(bf16x4*)(&As[asLoc]);

        b = *(bf16x4*)(&Bs[bsLoc]);

        ASM_DEBUG("; MFMA");
        ///d = __builtin_amdgcn_mfma_f32_32x32x8f16(a, b, d, 0, 0, 0);
        d = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a, b, d, 0, 0, 0);        
        //ASM_DEBUG("; Next BK");
        A += BK;
        B += BK * strideBK;
       
        #if 0
        if (debug_level == 1 && blockIdx.x == 0 && blockIdx.z == 0 && blockIdx.y == 0 && threadIdx.x == 0) {
            for (int i = 0; i < 4; ++i) {
                printf("A: %f, B: %f\n", (float)a[i], (float)b[i]);
            }
            for (int i = 0; i < 16; ++i) {
                 printf("D: %f\n", d[i]);
            }
            printf("\n");
        }
        #endif
       
    }
    
    C += (4 * threadRow + warpRow * 32) * N + threadCol + warpCol * 32;


    //ASM_DEBUG(";Before write C");
    #pragma unroll
    for (int i = 0; i < 16; ++i) {
        int rowNum = i % 4;
        int rowIdx = i / 4;
        int idx = (rowNum + rowIdx * 8) * N;
        
        //__builtin_amdgcn_sched_barrier(0); 
        //asm volatile("; before cast ");
        //__builtin_amdgcn_sched_barrier(0);
        bhalf_t temp;
        //ASM_DEBUG("; static casting");
        temp = static_cast<__bf16>(d[i]);
        //ASM_DEBUG("; before store C");
        C[idx] = temp;              
        //ASM_DEBUG("; before store C");

    }
    //ASM_DEBUG(";After write C");
      
}


template <const uint BM, const uint BN, const uint BK>
__global__ void
__launch_bounds__(256, 1)
batched_matrix_multiplication_matrix_core_64x64(uint M, uint N, uint K, uint Batch, const bhalf_t *A, const bhalf_t *B, bhalf_t *C, bool debug_level = 1)
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
                    printf("A: %f, B: %f\n", cktile::bf16_to_float(a[0][i]), cktile::bf16_to_float(b[0][i]));
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
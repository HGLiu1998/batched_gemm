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

#if 0
template <index_t nloop>
__device__ static constexpr auto HotLoopScheduler()
{
    // Estimated number of VMEM vector loads for A per block:
    //   total A bytes / (threads per block * vector width)
    constexpr index_t Aload_inst =
        (kMPerBlock * kKPerBlock * sizeof(ADataType)) / BlockSize / VectorLoadSize;
    // Estimated number of VMEM vector loads for B per block:
    //   total B bytes / (threads per block * vector width)
    constexpr index_t Bload_inst =
        (kKPerBlock * kNPerBlock * sizeof(BDataType)) / BlockSize / VectorLoadSize;

    // Estimated number of VMEM loads for B's quant data (e.g. scales / zp).
    // First ceil-divide by quant group size (how many elements share one scale),
    // then by vector width to get an approximate number of vector loads.
    constexpr index_t BQload_inst = ck_tile::integer_divide_ceil(
        ck_tile::integer_divide_ceil(kKPerBlock * kNPerBlock * sizeof(BQDataType), QuantGroupSize::kK * QuantGroupSize::kK), VectorLoadSize);

        // ToDo: Hardcoded, need to change in future. How many instruction emit per iteration
    constexpr index_t kLdsInstCycle = 8;
        // Total VMEM load instructions (A + B + quant data)
    constexpr index_t buffer_load_inst = Aload_inst + Bload_inst + BQload_inst;
        // Approximate number of LDS reads per block
    constexpr index_t ds_read_inst = kMPerBlock / kLdsInstCycle;
    // Approximate number of LDS writes per block
    // (e.g., writing A from VMEM into LDS once per A load)
    constexpr index_t ds_write_inst = Aload_inst;
    // Number of MFMA instructions per wave for one block tile:
    constexpr index_t mfma_inst = (kMPerBlock / WG::kM) * (kNPerBlock / WG::kN);
    // How often (in MFMA units) we should insert DS (LDS) operations.
    constexpr index_t ds_rep = mfma_inst / (ds_read_inst + ds_write_inst);
    // How often (in MFMA units) we should insert VMEM buffer loads.
    // buffer_load_rep ≈ "MFMA per VMEM_READ", clamped so that one buffer_load
    // is assumed to cover at most 4 MFMA instructions.
    constexpr index_t buffer_load_rep =
        min(mfma_inst / buffer_load_inst, 4); // 1 buffer_load cover 4 mfma

    static_for<0, nloop, 1>{}([&](auto) {
        static_for<0, mfma_inst, 1>{}([&](auto i_inst) {
            __builtin_amdgcn_sched_group_barrier(LLVMSchedGroupMask::MFMA, 1, 0); // MFMA

            // Insert LDS read/write groups periodically based on ds_rep.
            // The % pattern staggers READ and WRITE so they don't collapse
            // into the same cycle in the model.
            if constexpr(ds_rep > 0 && i_inst % ds_rep == 0)
            {
                __builtin_amdgcn_sched_group_barrier(
                    LLVMSchedGroupMask::DS_READ, 1, 0); // DS read
            }
            if constexpr(ds_rep > 0 && i_inst % ds_rep == 1)
            {
                __builtin_amdgcn_sched_group_barrier(
                    LLVMSchedGroupMask::DS_WRITE, 1, 0); // DS write
            }

            if constexpr(buffer_load_rep > 0 && i_inst % buffer_load_rep == 0)
            {
                if constexpr(ds_write_inst > 0)
                {
                    __builtin_amdgcn_sched_group_barrier(
                        LLVMSchedGroupMask::VMEM_READ, 1, 0); // VMEM read
                }
            }
            // Always mark some VALU work in the loop to reflect auxiliary scalar
            // or vector ALU instructions that coexist with MFMA (Blockscale calculation).
            __builtin_amdgcn_sched_group_barrier(LLVMSchedGroupMask::VALU, 2, 0); // VALU
        });
    });
    __builtin_amdgcn_sched_barrier(0);
}
#endif

enum LLVMSchedGroupMask : int32_t
{
    NONE       = 0,
    ALU        = 1 << 0,
    VALU       = 1 << 1,
    SALU       = 1 << 2,
    MFMA       = 1 << 3,
    VMEM       = 1 << 4,
    VMEM_READ  = 1 << 5,
    VMEM_WRITE = 1 << 6,
    DS         = 1 << 7,
    DS_READ    = 1 << 8,
    DS_WRITE   = 1 << 9,
    ALL        = (DS_WRITE << 1) - 1,
};

template <const uint BM = 128, const uint BN = 128, const uint BK = 16>
__global__ void
__launch_bounds__(512, 2)
batched_matrix_multiplication_matrix_core_128x128x16_IGLP(uint M, uint N, uint K, uint Batch, const bhalf_t *A, const bhalf_t *B, bhalf_t *C, dim3 strideA, dim3 strideB, dim3 strideC, int debug_level = 1)
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

    bf16x4 a[2], b[2];
    floatx16 d[4] = {0};
    
    //constexpr uint BK_PAD = BK + 4;
    // Double buffering: two sets of LDS buffers for prefetching (ping-pong pattern)
    __shared__ __attribute__((aligned(16))) bhalf_t As[2][BM * BK]; 
    __shared__ __attribute__((aligned(16))) bhalf_t Bs[2][BN * BK];
    __shared__ __attribute__((aligned(16))) bhalf_t Cs[BN * BM];

    //uint aLoc = threadIdxInWarp * strideAM + strideK * 8 * strideAK;
    uint aLoc = (threadIdxInWarp + warpRow * 64) * strideAM + (warpCol * 8) * strideAK;
    //uint bLoc = threadIdxInWarp * strideBN + strideK * 8 * strideBK;
    uint bLoc = (threadIdxInWarp + warpCol * 64) * strideBN + (warpRow * 8) * strideBK;

    uint asLoc = (threadIdxInWarp + warpRow * 64) * BK + (warpCol * 8);
    uint bsLoc = (threadIdxInWarp + warpCol * 64) * BK + (warpRow * 8); // transposed


    uint aRow = threadCol + warpRow * 32; // 0: [0-31] 1:[0-31] 2:[31-63] 3:[31-63]
    uint aCol = threadRow * 4;            // 0: [0] 1:[0] 2:[1] 3:[1]
    uint bRow = threadCol + warpCol * 32; // 0 - 31 32 - 63
    uint bCol = threadRow * 4;            // 0, 4
    
    uint aRegLoc = aRow * BK + aCol;
    uint bRegLoc = bRow * BK + bCol; 
    

    int writeIdx = 0;
    int readIdx = 0;
    
    //ASM_DEBUG("; Prefetch A first tile");
    *(bf16x8*)(&As[writeIdx][asLoc]) = *(bf16x8*)(&A[aLoc]);
    
    //ASM_DEBUG("; Prefetch B first tile");
    *(bf16x8*)(&Bs[writeIdx][bsLoc]) = *(bf16x8*)(&B[bLoc]);
    
    __syncthreads();
    
    // Advance pointers for next iteration
    A += BK;
    B += BK * strideBK;
    //__builtin_amdgcn_sched_barrier(0);
    // Main loop with double buffering
    for (int k = BK; k < K; k += BK) {
        // Swap read/write buffers (ping-pong)
        readIdx = writeIdx;
        writeIdx = 1 - writeIdx;
        
        //ASM_DEBUG("; Prefetch A");
        bf16x8 tempNextA, tempNextB;
        tempNextA = *(bf16x8*)(&A[aLoc]);
        //ASM_DEBUG("; Prefetch B");
        tempNextB = *(bf16x8*)(&B[bLoc]);
        //ASM_DEBUG("; MFMA");
        __builtin_amdgcn_sched_barrier(0);
        #pragma unroll
        for (int i = 0; i < 2; ++i) { // K iter
            a[0] = *(bf16x4*)(&As[readIdx][i * 8 + aRegLoc]);
            a[1] = *(bf16x4*)(&As[readIdx][i * 8 + 64 * BK + aRegLoc]);
            b[0] = *(bf16x4*)(&Bs[readIdx][i * 8 + bRegLoc]);
            b[1] = *(bf16x4*)(&Bs[readIdx][i * 8 + 64 * BK + bRegLoc]);
            d[0] = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a[0], b[0], d[0], 0, 0, 0);
            d[1] = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a[0], b[1], d[1], 0, 0, 0);
            d[2] = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a[1], b[0], d[2], 0, 0, 0);
            d[3] = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a[1], b[1], d[3], 0, 0, 0);
        }
        __builtin_amdgcn_sched_barrier(0);

        *(bf16x8*)(&As[writeIdx][asLoc]) = tempNextA;
        *(bf16x8*)(&Bs[writeIdx][bsLoc]) = tempNextB;
        // Sync before swapping buffers
        __builtin_amdgcn_s_barrier();
            
        A += BK;
        B += BK * strideBK;


        //__builtin_amdgcn_sched_group_barrier(LLVMSchedGroupMask::MFMA, 1, 0); // MFMA
        //__builtin_amdgcn_sched_group_barrier(LLVMSchedGroupMask::DS_READ, 1, 0); // DS read
        //__builtin_amdgcn_sched_group_barrier(LLVMSchedGroupMask::DS_WRITE, 1, 0); // DS write
        //__builtin_amdgcn_sched_group_barrier(LLVMSchedGroupMask::VMEM_READ, 1, 0); // VMEM read
        //__builtin_amdgcn_sched_group_barrier(LLVMSchedGroupMask::VALU, 4, 0); // VALU

        //__builtin_amdgcn_sched_barrier(0);
    }
    
    // Process last tile (no prefetch needed) - interleave loads with MFMA
    readIdx = writeIdx;
    // Load first operand
    #pragma unroll
    for (int i = 0; i < 2; ++i) { // K iter
        a[0] = *(bf16x4*)(&As[readIdx][i * 8 + aRegLoc]);
        a[1] = *(bf16x4*)(&As[readIdx][i * 8 + 64 * BK + aRegLoc]);
        b[0] = *(bf16x4*)(&Bs[readIdx][i * 8 + bRegLoc]);
        b[1] = *(bf16x4*)(&Bs[readIdx][i * 8 + 64 * BK + bRegLoc]);
        d[0] = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a[0], b[0], d[0], 0, 0, 0);
        d[1] = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a[0], b[1], d[1], 0, 0, 0);
        d[2] = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a[1], b[0], d[2], 0, 0, 0);
        d[3] = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a[1], b[1], d[3], 0, 0, 0);
    }
        
    C += (4 * threadRow + warpRow * 32) * N + threadCol + warpCol * 32;


    #pragma unroll
    for (int i = 0; i < 16; ++i) {
        int rowNum = i % 4;
        int rowIdx = i / 4;
        int idx = (rowNum + rowIdx * 8) * N;
        
        C[idx] = static_cast<__bf16>(d[0][i]);
        C[idx + 64] = static_cast<__bf16>(d[1][i]);
        C[idx + 64 * N] = static_cast<__bf16>(d[2][i]);
        C[idx + 64 * N + 64] = static_cast<__bf16>(d[3][i]);         

    }
}

template <const uint BM = 128, const uint BN = 128, const uint BK = 16>
__global__ void
__launch_bounds__(512, 2)
batched_matrix_multiplication_matrix_core_128x128x16(uint M, uint N, uint K, uint Batch, const bhalf_t *A, const bhalf_t *B, bhalf_t *C, dim3 strideA, dim3 strideB, dim3 strideC, int debug_level = 1)
{
    int blockRow = blockIdx.y;
    int blockCol = blockIdx.x;
    int blockBatch = blockIdx.z;

    //int warp_group = threadIdx.x / 256;

    //int warpIdx = (threadIdx.x % 256) / 64; // 0: [0-63], 1: [64-127], 2: [128-191], 3: [192-255]
    int warpIdx = threadIdx.x / 64;
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

    bf16x4 a[2], b[2];
    floatx16 d[4] = {0};
    
    // Double buffering: two sets of LDS buffers for prefetching (ping-pong pattern)
    __shared__ __attribute__((aligned(16))) bhalf_t As[2][BM * BK]; 
    __shared__ __attribute__((aligned(16))) bhalf_t Bs[2][BN * BK];
    __shared__ __attribute__((aligned(16))) bhalf_t Cs[BN * BM];

    //uint aLoc = threadIdxInWarp * strideAM + strideK * 8 * strideAK;
    uint aLoc = (threadIdxInWarp + warpRow * 64) * strideAM + (warpCol * 8) * strideAK;
    //uint bLoc = threadIdxInWarp * strideBN + strideK * 8 * strideBK;
    uint bLoc = (threadIdxInWarp + warpCol * 64) * strideBN + (warpRow * 8) * strideBK;

    uint asLoc = (threadIdxInWarp + warpRow * 64) * BK + (warpCol * 8);
    uint bsLoc = (threadIdxInWarp + warpCol * 64) * BK + (warpRow * 8); // transposed


    uint aRow = threadCol + warpRow * 32; // 0: [0-31] 1:[0-31] 2:[31-63] 3:[31-63]
    uint aCol = threadRow * 4;            // 0: [0] 1:[0] 2:[1] 3:[1]
    uint bRow = threadCol + warpCol * 32; // 0 - 31 32 - 63
    uint bCol = threadRow * 4;            // 0, 4
    
    uint aRegLoc = aRow * BK + aCol;
    uint bRegLoc = bRow * BK + bCol; // transposed
    

    int writeIdx = 0;
    int readIdx = 0;
    
    //ASM_DEBUG("; Prefetch A first tile");
    bf16x8 tempA, tempB;
    tempA = *(bf16x8*)(&A[aLoc]);
    *(bf16x8*)(&As[writeIdx][asLoc]) = tempA;
    
    #pragma unroll
    for (int i = 0; i < 8; ++i) {
        tempB[i] = B[bLoc + i * strideBK];
    }
    *(bf16x8*)(&Bs[writeIdx][bsLoc]) = tempB;
    
    __builtin_amdgcn_s_barrier();
    // Advance pointers for next iteration
    A += BK;
    B += BK * strideBK;
    //__builtin_amdgcn_sched_barrier(0);
    // Main loop with double buffering
    for (int k = BK; k < K; k += BK) {
        // Swap read/write buffers (ping-pong)
        readIdx = writeIdx;
        writeIdx = 1 - writeIdx;
        
        //ASM_DEBUG("; Prefetch A");
        bhalf_t tempB1, tempB2, tempB3, tempB4, tempB5, tempB6, tempB7, tempB8;
        bf16x8 tempNextA, tempNextB;

        tempNextA = *(bf16x8*)(&A[aLoc]);
        tempB1 = B[bLoc];
        tempB2 = B[bLoc + strideBK];
        tempB3 = B[bLoc + 2 * strideBK];
        tempB4 = B[bLoc + 3 * strideBK];
        tempB5 = B[bLoc + 4 * strideBK];
        tempB6 = B[bLoc + 5 * strideBK];
        tempB7 = B[bLoc + 6 * strideBK];
        tempB8 = B[bLoc + 7 * strideBK];

        //ASM_DEBUG("; Prefetch B");

        __builtin_amdgcn_sched_barrier(0);
        //ASM_DEBUG("; MFMA");
        #pragma unroll
        for (int i = 0; i < 2; ++i) { // K iter
            a[0] = *(bf16x4*)(&As[readIdx][i * 8 + aRegLoc]);
            a[1] = *(bf16x4*)(&As[readIdx][i * 8 + 64 * BK + aRegLoc]);
            b[0] = *(bf16x4*)(&Bs[readIdx][i * 8 + bRegLoc]);
            b[1] = *(bf16x4*)(&Bs[readIdx][i * 8 + 64 * BK + bRegLoc]);
            d[0] = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a[0], b[0], d[0], 0, 0, 0);
            d[1] = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a[0], b[1], d[1], 0, 0, 0);
            d[2] = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a[1], b[0], d[2], 0, 0, 0);
            d[3] = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a[1], b[1], d[3], 0, 0, 0);
        }

        __builtin_amdgcn_sched_barrier(0);

        tempNextB[0] = tempB1;
        tempNextB[1] = tempB2;
        tempNextB[2] = tempB3;
        tempNextB[3] = tempB4;
        tempNextB[4] = tempB5;
        tempNextB[5] = tempB6;
        tempNextB[6] = tempB7;
        tempNextB[7] = tempB8;

        *(bf16x8*)(&As[writeIdx][asLoc]) = tempNextA;
        *(bf16x8*)(&Bs[writeIdx][bsLoc]) = tempNextB;
            
         __builtin_amdgcn_s_barrier();
        A += BK;
        B += BK * strideBK;
    }
    
    // Process last tile (no prefetch needed) - interleave loads with MFMA
    readIdx = writeIdx;
    
    // Load first operand
    #pragma unroll
    for (int i = 0; i < 2; ++i) { // K iter
        a[0] = *(bf16x4*)(&As[readIdx][i * 8 + aRegLoc]);
        a[1] = *(bf16x4*)(&As[readIdx][i * 8 + 64 * BK + aRegLoc]);
        b[0] = *(bf16x4*)(&Bs[readIdx][i * 8 + bRegLoc]);
        b[1] = *(bf16x4*)(&Bs[readIdx][i * 8 + 64 * BK + bRegLoc]);
        d[0] = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a[0], b[0], d[0], 0, 0, 0);
        d[1] = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a[0], b[1], d[1], 0, 0, 0);
        d[2] = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a[1], b[0], d[2], 0, 0, 0);
        d[3] = __builtin_amdgcn_mfma_f32_32x32x8bf16_1k(a[1], b[1], d[3], 0, 0, 0);
    }
        
    C += (4 * threadRow + warpRow * 32) * N + threadCol + warpCol * 32;


    #pragma unroll
    for (int i = 0; i < 16; ++i) {
        int rowNum = i % 4;
        int rowIdx = i / 4;
        int idx = (rowNum + rowIdx * 8) * N;
        
        C[idx] = static_cast<__bf16>(d[0][i]);
        C[idx + 64] = static_cast<__bf16>(d[1][i]);
        C[idx + 64 * N] = static_cast<__bf16>(d[2][i]);
        C[idx + 64 * N + 64] = static_cast<__bf16>(d[3][i]);         

    }
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

    uint aLoc = (threadIdxInWarp + warpRow * 64) * strideAM + warpCol * 8 * strideAK;
    uint bLoc = (threadIdxInWarp + warpCol * 64) * strideBN + warpRow * 8 * strideBK;

    // Simple linear addressing (no swizzling)
    uint asLoc = (threadIdxInWarp + warpRow * 64) * BK + warpCol * 8 ;
    uint bsLoc = (threadIdxInWarp + warpCol * 64) * BK + warpRow; // transposed 


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
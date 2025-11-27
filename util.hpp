#include <hip/hip_runtime.h>
#include <hip/amd_detail/amd_hip_runtime.h>
#include <hip/amd_detail/hip_ldg.h>


__device__ inline buffer_resource make_buffer_resource(uint64_t ptr, uint32_t range, uint32_t config) {
    return {ptr, range, config};
}

__device__ inline i32x4 make_srsc(const void* ptr, uint32_t range_bytes, uint32_t row_stride_bytes = 0) {
    std::uintptr_t as_int = reinterpret_cast<std::uintptr_t>(ptr);
    std::uint64_t as_u64 = static_cast<std::uint64_t>(as_int);
    buffer_resource rsrc = make_buffer_resource(as_u64, range_bytes, 0x110000);

    row_stride_bytes &= 0x3FFF;
    if (row_stride_bytes) {
        uint64_t stride_field = row_stride_bytes;
        stride_field = stride_field | 0x4000;
        stride_field = stride_field | 0x8000;
        rsrc.ptr |= stride_field << 48;
    }

    return *reinterpret_cast<const i32x4 *>(&rsrc);
}


__device__inline void load(bhalf* src, bhalf* dst) {
    i32x4 srsc = make_srsrc(global_ptr, )
}
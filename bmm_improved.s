	.amdhsa_code_object_version 6
	.section	.text._Z39batched_gemm_128x128x16_improved,"axG",@progbits,_Z39batched_gemm_128x128x16_improved,comdat
	.protected	_Z39batched_gemm_128x128x16_improved
	.globl	_Z39batched_gemm_128x128x16_improved
	.p2align	8
	.type	_Z39batched_gemm_128x128x16_improved,@function
_Z39batched_gemm_128x128x16_improved:
    ; === Prologue: Load kernel arguments and initialize AGPRs ===
	s_load_dwordx2 s[6:7], s[0:1], 0x4
	s_load_dwordx4 s[16:19], s[0:1], 0x10   ; ptr_a, ptr_b
	s_load_dwordx2 s[20:21], s[0:1], 0x20   ; ptr_c
	s_load_dwordx8 s[8:15], s[0:1], 0x28    ; strides
	s_load_dword s5, s[0:1], 0x48           ; batch

    ; Initialize AGPRs (64 cycles, overlapped with scalar loads)
    .cnt = 0
    .rept 64
        v_accvgpr_write_b32 a[.cnt], 0
        .cnt = .cnt + 1
    .endr

    ; --- Address Calculations ---
	v_lshrrev_b32_e32 v1, 7, v0
	v_and_b32_e32 v2, 63, v0
	s_waitcnt lgkmcnt(0)
	s_lshl_b32 s26, s2, 7
	s_mul_i32 s0, s11, s4
	s_mul_i32 s1, s13, s26
	s_add_i32 s0, s1, s0
	s_mov_b32 s1, 0
	v_bfe_u32 v7, v0, 6, 1
	s_lshl_b32 s27, s3, 7
	s_lshl_b64 s[22:23], s[0:1], 1
	v_lshl_or_b32 v6, v1, 6, v2
	s_mul_i32 s8, s8, s4
	s_add_u32 s2, s18, s22
	v_lshlrev_b32_e32 v8, 3, v7
	s_mul_i32 s0, s9, s27
	v_mul_lo_u32 v2, s9, v6
	s_addc_u32 s3, s19, s23
	s_add_i32 s0, s0, s8
	v_mad_u64_u32 v[2:3], s[8:9], s10, v8, v[2:3]
	v_lshlrev_b32_e32 v10, 3, v1
	v_and_b32_e32 v9, 31, v0
	s_lshl_b64 s[24:25], s[0:1], 1
	v_and_b32_e32 v3, 0x7f, v0
	v_mul_lo_u32 v4, s12, v10
	v_lshlrev_b32_e32 v1, 5, v1
	v_lshrrev_b32_e32 v0, 3, v0
	s_add_u32 s28, s16, s24
	v_mad_u64_u32 v[4:5], s[8:9], s13, v3, v[4:5]
	v_mad_u32_u24 v17, v6, 20, v8
	v_mad_u32_u24 v18, v3, 20, v10
	v_or_b32_e32 v3, v1, v9
	v_and_b32_e32 v6, 4, v0
	s_addc_u32 s29, s17, s25
	v_mad_u32_u24 v8, v3, 20, v6
	v_mov_b32_e32 v3, 0
	v_lshl_add_u64 v[10:11], v[2:3], 1, s[28:29]

    ; --- Initial Global Loads (Iter 0) ---
	global_load_dwordx4 v[10:13], v[10:11], off
	v_mov_b32_e32 v5, v3
	v_lshl_add_u64 v[14:15], v[4:5], 1, s[2:3]
	global_load_dwordx4 v[20:23], v[14:15], off
    
    ; Loop Setup
	v_lshl_or_b32 v0, v7, 5, v9
    s_add_i32 s2, s7, -16
	v_lshlrev_b32_e32 v9, 1, v17
	v_mad_u32_u24 v7, v0, 20, v6
    s_cmp_gt_u32 s2, 15
    s_cbranch_scc0 .L_StoreSection

    ; Initial LDS Writes (Iter 0)
	s_waitcnt vmcnt(0)
	ds_write2_b64 v9, v[10:11], v[12:13] offset1:1
	v_mov_b32_e32 v30, 0x2800 ; use v30 as temp
	v_lshl_add_u32 v30, v18, 1, v30
	ds_write2_b64 v30, v[20:21], v[22:23] offset1:1
    s_barrier

    ; Loop stride calculations
	s_lshl_b32 s0, s12, 4
	s_lshr_b32 s7, s2, 4
	s_lshl_b64 s[2:3], s[0:1], 1
	s_add_u32 s0, s2, s22
	s_addc_u32 s9, s3, s23
	s_add_u32 s8, s18, s0
	s_addc_u32 s9, s19, s9
	s_add_u32 s0, s24, s16
	s_addc_u32 s11, s25, s17
	s_add_u32 s10, s0, 32
	s_addc_u32 s11, s11, 0

    s_mov_b32 s1, 0 ; buffer toggle

.L_MainLoop:
    ; === 1. Issue Global Loads for Iteration N+1 (Prefetch) ===
	v_lshl_add_u64 v[20:21], v[2:3], 1, s[10:11]
	global_load_dwordx4 v[20:23], v[20:21], off
	v_lshl_add_u64 v[24:25], v[4:5], 1, s[8:9]
	global_load_dwordx4 v[24:27], v[24:25], off

    ; === 2. Issue LDS Reads for Iteration N ===
	s_mul_i32 s0, s1, 0x1400
	v_lshl_add_u32 v30, v8, 1, s0
	v_lshl_add_u32 v31, v7, 1, s0
	ds_read2st64_b64 v[28:31], v30 offset1:5
	ds_read2st64_b64 v[32:35], v31 offset0:20 offset1:25

    ; === 3. Overlap address calculations with LDS latency ===
	v_add_u32_e32 v38, 16, v30
    s_xor_b32 s1, s1, 1 ; Toggle buffer for next iteration
	v_add_u32_e32 v39, 16, v31
    s_add_u32 s8, s8, s2
    s_addc_u32 s9, s9, s3

    ; === 4. Computation (Iteration N - Part 1) ===
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_32x32x8_bf16 a[48:63], v[28:29], v[32:33], a[48:63]
	v_mfma_f32_32x32x8_bf16 a[32:47], v[28:29], v[34:35], a[32:47]
    
    ; Issue second half LDS reads during MFMA execution (8 cycles per MFMA)
	ds_read2st64_b64 v[28:31], v38 offset1:5
	ds_read2st64_b64 v[32:35], v39 offset0:20 offset1:25

	v_mfma_f32_32x32x8_bf16 a[16:31], v[30:31], v[32:33], a[16:31]
	v_mfma_f32_32x32x8_bf16 a[0:15], v[30:31], v[34:35], a[0:15]

    ; === 5. Computation (Iteration N - Part 2) ===
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_32x32x8_bf16 a[48:63], v[28:29], v[32:33], a[48:63]
	v_mfma_f32_32x32x8_bf16 a[32:47], v[28:29], v[34:35], a[32:47]
	v_mfma_f32_32x32x8_bf16 a[16:31], v[30:31], v[32:33], a[16:31]
	v_mfma_f32_32x32x8_bf16 a[0:15], v[30:31], v[34:35], a[0:15]

    ; === 6. Write Global Data (Iter N+1) to LDS ===
	s_waitcnt vmcnt(0)
	s_mul_i32 s0, s1, 0x1400 ; Next buffer offset
	v_lshl_add_u32 v30, v17, 1, s0
	ds_write2_b64 v30, v[20:21], v[22:23] offset1:1
	v_lshl_add_u32 v30, v18, 1, s0
	v_add_u32_e32 v30, 0x2800, v30
	ds_write2_b64 v30, v[24:25], v[26:27] offset1:1
    
    s_add_u32 s10, s10, 32
    s_addc_u32 s11, s11, 0
	s_barrier ; Wait for all LDS writes in the group
	s_add_i32 s7, s7, -1
	s_cmp_eq_u32 s7, 0
	s_cbranch_scc0 .L_MainLoop

.L_StoreSection:
    ; === 7. Final Computation for the last block ===
    ; (Simplified for this example - normally handles the edge block)
    s_mul_i32 s0, s1, 0x1400
    v_lshl_add_u32 v2, v8, 1, s0
    ds_read_b64 v[2:3], v2
    s_add_i32 s1, s0, 0x2800
    v_lshl_add_u32 v4, v7, 1, s1
    ds_read_b64 v[4:5], v4
    s_waitcnt lgkmcnt(0)
    v_mfma_f32_32x32x8_bf16 a[48:63], v[2:3], v[4:5], a[48:63]
    ; ... more final MFMAs ...

    ; === 8. Store AGPRs back to Global Memory (C matrix) ===
    v_or_b32_e32 v1, v6, v1
    v_mad_u64_u32 v[0:1], s[0:1], v1, s6, v[0:1]
    s_movk_i32 s0, 0x7fff
    
    ; Loop through AGPRs and store (truncated example)
    v_accvgpr_read_b32 v2, a48
    v_bfe_u32 v3, v2, 16, 1
    v_add3_u32 v3, v3, v2, s0
    v_or_b32_e32 v4, 0x400000, v2
    v_cmp_u_f32_e32 vcc, v2, v2
    v_cndmask_b32_e32 v2, v3, v4, vcc
    v_lshl_add_u64 v[0:1], v[0:1], 1, s[20:21] ; base C pointer
    global_store_short_d16_hi v[0:1], v2, off

	s_endpgm

.rodata
.p2align 6
.amdhsa_kernel _Z39batched_gemm_128x128x16_improved
	.amdhsa_group_segment_fixed_size 20480
	.amdhsa_next_free_vgpr 129
	.amdhsa_next_free_sgpr 96
	.amdhsa_accum_offset 40
	.amdhsa_reserve_vcc 1
.end_amdhsa_kernel

.amdgpu_metadata
---
amdhsa.kernels:
  - .agpr_count:     64
    .args:
      - .offset:         0
        .size:           4
        .value_kind:     by_value
      - .offset:         4
        .size:           4
        .value_kind:     by_value
      - .offset:         8
        .size:           4
        .value_kind:     by_value
      - .offset:         12
        .size:           4
        .value_kind:     by_value
      - .address_space:  global
        .offset:         16
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .offset:         24
        .size:           8
        .value_kind:     global_buffer
      - .address_space:  global
        .offset:         32
        .size:           8
        .value_kind:     global_buffer
    .group_segment_fixed_size: 20480
    .kernarg_segment_align: 8
    .kernarg_segment_size: 76
    .name:           _Z39batched_gemm_128x128x16_improved
    .symbol:         _Z39batched_gemm_128x128x16_improved.kd
    .vgpr_count:     104
    .wavefront_size: 64
amdhsa.target:   amdgcn-amd-amdhsa--gfx942
...
.end_amdgpu_metadata

	.amdgcn_target "amdgcn-amd-amdhsa--gfx942"
	.amdhsa_code_object_version 6
	.text
	.protected	_Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b ; -- Begin function _Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b
	.globl	_Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b
	.p2align	8
	.type	_Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b,@function
_Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b: ; @_Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b
; %bb.0:
	s_load_dwordx2 s[16:17], s[0:1], 0x34
	s_load_dwordx2 s[6:7], s[0:1], 0x20
	s_load_dwordx8 s[8:15], s[0:1], 0x0
	v_bfe_u32 v1, v0, 20, 10
	v_bfe_u32 v4, v0, 10, 10
	s_waitcnt lgkmcnt(0)
	s_and_b32 s0, s17, 0xffff
	s_mul_i32 s4, s4, s0
	s_and_b32 s5, s16, 0xffff
	v_add_u32_e32 v1, s4, v1
	s_lshr_b32 s1, s16, 16
	s_mul_i32 s2, s2, s5
	v_mul_lo_u32 v2, v1, s8
	v_and_b32_e32 v0, 0x3ff, v0
	s_mul_i32 s3, s3, s1
	s_cmp_lt_i32 s10, 1
	v_add3_u32 v5, s2, v0, v2
	s_cbranch_scc1 .LBB0_4
; %bb.1:                                ; %.lr.ph
	s_mul_i32 s0, s10, s9
	v_mul_lo_u32 v1, s0, v1
	v_mul_lo_u32 v0, v5, s10
	v_add3_u32 v2, v4, v1, s3
	v_mov_b32_e32 v6, 0
	s_movk_i32 s0, 0x7fff
.LBB0_2:                                ; =>This Inner Loop Header: Depth=1
	v_ashrrev_i32_e32 v3, 31, v2
	v_ashrrev_i32_e32 v1, 31, v0
	v_lshl_add_u64 v[10:11], v[2:3], 1, s[14:15]
	v_lshl_add_u64 v[8:9], v[0:1], 1, s[12:13]
	global_load_ushort v1, v[10:11], off
	global_load_ushort v3, v[8:9], off
	s_add_i32 s10, s10, -1
	v_add_u32_e32 v0, 1, v0
	s_cmp_eq_u32 s10, 0
	v_add_u32_e32 v2, s9, v2
	s_waitcnt vmcnt(1)
	v_lshlrev_b32_e32 v1, 16, v1
	s_waitcnt vmcnt(0)
	v_lshlrev_b32_e32 v3, 16, v3
	v_mul_f32_e32 v1, v3, v1
	v_bfe_u32 v3, v1, 16, 1
	v_or_b32_e32 v7, 0x400000, v1
	v_add3_u32 v3, v3, v1, s0
	v_cmp_u_f32_e32 vcc, v1, v1
	s_nop 1
	v_cndmask_b32_e32 v1, v3, v7, vcc
	v_and_b32_e32 v1, 0xffff0000, v1
	v_add_f32_e32 v6, v6, v1
	s_cbranch_scc0 .LBB0_2
; %bb.3:                                ; %._crit_edge.loopexit
	v_bfe_u32 v0, v6, 16, 1
	s_movk_i32 s0, 0x7fff
	v_add3_u32 v0, v0, v6, s0
	v_or_b32_e32 v1, 0x400000, v6
	v_cmp_u_f32_e32 vcc, v6, v6
	s_nop 1
	v_cndmask_b32_e32 v0, v0, v1, vcc
	v_lshrrev_b32_e32 v0, 16, v0
	s_branch .LBB0_5
.LBB0_4:
	v_mov_b32_e32 v0, 0
.LBB0_5:                                ; %Flow
	v_mul_lo_u32 v1, v5, s9
	v_add3_u32 v4, s3, v4, v1
	v_mov_b32_e32 v2, s6
	v_mov_b32_e32 v3, s7
	v_ashrrev_i32_e32 v5, 31, v4
	v_lshl_add_u64 v[2:3], v[4:5], 1, v[2:3]
	global_store_short v[2:3], v0, off
	s_endpgm
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b
		.amdhsa_group_segment_fixed_size 0
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 296
		.amdhsa_user_sgpr_count 2
		.amdhsa_user_sgpr_dispatch_ptr 0
		.amdhsa_user_sgpr_queue_ptr 0
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_user_sgpr_dispatch_id 0
		.amdhsa_user_sgpr_kernarg_preload_length 0
		.amdhsa_user_sgpr_kernarg_preload_offset 0
		.amdhsa_user_sgpr_private_segment_size 0
		.amdhsa_uses_dynamic_stack 0
		.amdhsa_enable_private_segment 0
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 1
		.amdhsa_system_sgpr_workgroup_id_z 1
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 2
		.amdhsa_next_free_vgpr 12
		.amdhsa_next_free_sgpr 18
		.amdhsa_accum_offset 12
		.amdhsa_reserve_vcc 1
		.amdhsa_float_round_mode_32 0
		.amdhsa_float_round_mode_16_64 0
		.amdhsa_float_denorm_mode_32 3
		.amdhsa_float_denorm_mode_16_64 3
		.amdhsa_dx10_clamp 1
		.amdhsa_ieee_mode 1
		.amdhsa_fp16_overflow 0
		.amdhsa_tg_split 0
		.amdhsa_exception_fp_ieee_invalid_op 0
		.amdhsa_exception_fp_denorm_src 0
		.amdhsa_exception_fp_ieee_div_zero 0
		.amdhsa_exception_fp_ieee_overflow 0
		.amdhsa_exception_fp_ieee_underflow 0
		.amdhsa_exception_fp_ieee_inexact 0
		.amdhsa_exception_int_div_zero 0
	.end_amdhsa_kernel
	.text
.Lfunc_end0:
	.size	_Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b, .Lfunc_end0-_Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b
                                        ; -- End function
	.set _Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b.num_vgpr, 12
	.set _Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b.num_agpr, 0
	.set _Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b.numbered_sgpr, 18
	.set _Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b.private_seg_size, 0
	.set _Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b.uses_vcc, 1
	.set _Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b.uses_flat_scratch, 0
	.set _Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b.has_dyn_sized_stack, 0
	.set _Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b.has_recursion, 0
	.set _Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b.has_indirect_call, 0
	.section	.AMDGPU.csdata,"",@progbits
; Kernel info:
; codeLenInByte = 376
; TotalNumSgprs: 24
; NumVgprs: 12
; NumAgprs: 0
; TotalNumVgprs: 12
; ScratchSize: 0
; MemoryBound: 0
; FloatMode: 240
; IeeeMode: 1
; LDSByteSize: 0 bytes/workgroup (compile time only)
; SGPRBlocks: 2
; VGPRBlocks: 1
; NumSGPRsForWavesPerEU: 24
; NumVGPRsForWavesPerEU: 12
; AccumOffset: 12
; Occupancy: 8
; WaveLimiterHint : 0
; COMPUTE_PGM_RSRC2:SCRATCH_EN: 0
; COMPUTE_PGM_RSRC2:USER_SGPR: 2
; COMPUTE_PGM_RSRC2:TRAP_HANDLER: 0
; COMPUTE_PGM_RSRC2:TGID_X_EN: 1
; COMPUTE_PGM_RSRC2:TGID_Y_EN: 1
; COMPUTE_PGM_RSRC2:TGID_Z_EN: 1
; COMPUTE_PGM_RSRC2:TIDIG_COMP_CNT: 2
; COMPUTE_PGM_RSRC3_GFX90A:ACCUM_OFFSET: 2
; COMPUTE_PGM_RSRC3_GFX90A:TG_SPLIT: 0
	.section	.text._Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i,"axG",@progbits,_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i,comdat
	.protected	_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i ; -- Begin function _Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i
	.globl	_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i
	.p2align	8
	.type	_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i,@function
_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i: ; @_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i
; %bb.0:
	s_load_dwordx2 s[6:7], s[0:1], 0x4
	s_load_dwordx4 s[12:15], s[0:1], 0x10
	s_load_dwordx2 s[16:17], s[0:1], 0x20
	s_load_dwordx4 s[8:11], s[0:1], 0x40
	v_and_b32_e32 v2, 31, v0
	s_waitcnt lgkmcnt(0)
	s_lshl_b32 s11, s3, 6
	s_lshl_b32 s5, s2, 6
	v_lshrrev_b32_e32 v1, 2, v0
	v_lshrrev_b32_e32 v3, 3, v0
	v_lshrrev_b32_e32 v0, 1, v0
	v_and_b32_e32 v1, 32, v1
	v_and_b32_e32 v12, 4, v3
	v_and_or_b32 v0, v0, 32, v2
	s_cmp_eq_u32 s7, 0
	s_mov_b32 s3, 0
	s_cbranch_scc1 .LBB1_3
; %bb.1:                                ; %.lr.ph
	s_load_dwordx4 s[20:23], s[0:1], 0x28
	s_load_dwordx2 s[18:19], s[0:1], 0x38
	v_or_b32_e32 v3, v1, v2
	v_lshlrev_b32_e32 v4, 1, v12
	v_lshl_or_b32 v13, v3, 4, v4
	s_waitcnt lgkmcnt(0)
	s_mul_i32 s1, s20, s4
	s_mul_i32 s2, s21, s11
	s_add_i32 s2, s2, s1
	v_lshlrev_b32_e32 v3, 4, v0
	s_movk_i32 s1, 0x400
	s_mul_i32 s0, s23, s4
	v_or3_b32 v14, v3, v4, s1
	s_mul_i32 s1, s19, s5
	s_add_i32 s0, s1, s0
	s_mov_b32 s1, s3
	s_lshl_b64 s[0:1], s[0:1], 1
	s_add_u32 s0, s14, s0
	s_addc_u32 s1, s15, s1
	v_mul_lo_u32 v5, v12, s18
	v_mul_lo_u32 v4, s19, v0
	s_lshl_b32 s19, s18, 1
	v_or_b32_e32 v3, 1, v12
	v_add3_u32 v6, v5, s19, v4
	v_add_u32_e32 v2, v1, v2
	s_lshl_b32 s14, s18, 3
	v_mad_u64_u32 v[8:9], s[24:25], s18, v3, v[4:5]
	v_add_u32_e32 v10, v4, v5
	v_add_u32_e32 v4, s18, v6
	s_lshl_b64 s[18:19], s[2:3], 1
	v_mul_lo_u32 v2, s21, v2
	v_mov_b32_e32 v7, 0
	v_mad_u64_u32 v[2:3], s[20:21], s22, v12, v[2:3]
	s_add_u32 s12, s12, s18
	s_mov_b32 s15, s3
	v_mov_b32_e32 v5, v7
	v_mov_b32_e32 v11, v7
	v_mov_b32_e32 v9, v7
	v_mov_b32_e32 v3, v7
	s_addc_u32 s13, s13, s19
	v_lshl_add_u64 v[2:3], v[2:3], 1, s[12:13]
	v_lshlrev_b64 v[4:5], 1, v[4:5]
	s_lshl_b64 s[12:13], s[14:15], 1
	v_lshlrev_b64 v[6:7], 1, v[6:7]
	v_lshlrev_b64 v[8:9], 1, v[8:9]
	v_lshlrev_b64 v[10:11], 1, v[10:11]
	v_accvgpr_write_b32 a15, 0
	v_accvgpr_write_b32 a14, 0
	v_accvgpr_write_b32 a13, 0
	v_accvgpr_write_b32 a12, 0
	v_accvgpr_write_b32 a11, 0
	v_accvgpr_write_b32 a10, 0
	v_accvgpr_write_b32 a9, 0
	v_accvgpr_write_b32 a8, 0
	v_accvgpr_write_b32 a7, 0
	v_accvgpr_write_b32 a6, 0
	v_accvgpr_write_b32 a5, 0
	v_accvgpr_write_b32 a4, 0
	v_accvgpr_write_b32 a3, 0
	v_accvgpr_write_b32 a2, 0
	v_accvgpr_write_b32 a1, 0
	v_accvgpr_write_b32 a0, 0
	s_mov_b32 s2, 0x5040100
.LBB1_2:                                ; =>This Inner Loop Header: Depth=1
	v_lshl_add_u64 v[16:17], s[0:1], 0, v[10:11]
	v_lshl_add_u64 v[18:19], s[0:1], 0, v[8:9]
	v_lshl_add_u64 v[20:21], s[0:1], 0, v[6:7]
	v_lshl_add_u64 v[22:23], s[0:1], 0, v[4:5]
	global_load_ushort v15, v[16:17], off
	global_load_ushort v26, v[18:19], off
	global_load_ushort v27, v[20:21], off
	global_load_ushort v28, v[22:23], off
	global_load_dwordx2 v[24:25], v[2:3], off
	s_add_i32 s3, s3, 8
	s_add_u32 s0, s0, s12
	s_addc_u32 s1, s1, s13
	s_cmp_ge_u32 s3, s7
	v_lshl_add_u64 v[2:3], v[2:3], 0, 16
	s_waitcnt vmcnt(3)
	v_perm_b32 v16, v26, v15, s2
	s_waitcnt vmcnt(1)
	v_perm_b32 v17, v28, v27, s2
	s_waitcnt vmcnt(0)
	ds_write_b64 v13, v[24:25]
	ds_write_b64 v14, v[16:17]
	s_waitcnt lgkmcnt(0)
	s_barrier
	ds_read_b64 v[16:17], v13
	ds_read_b64 v[18:19], v14
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_32x32x8_bf16 a[0:15], v[16:17], v[18:19], a[0:15]
	s_cbranch_scc0 .LBB1_2
	s_branch .LBB1_4
.LBB1_3:
	v_accvgpr_write_b32 a0, 0
	v_accvgpr_write_b32 a1, 0
	v_accvgpr_write_b32 a2, 0
	v_accvgpr_write_b32 a3, 0
	v_accvgpr_write_b32 a4, 0
	v_accvgpr_write_b32 a5, 0
	v_accvgpr_write_b32 a6, 0
	v_accvgpr_write_b32 a7, 0
	v_accvgpr_write_b32 a8, 0
	v_accvgpr_write_b32 a9, 0
	v_accvgpr_write_b32 a10, 0
	v_accvgpr_write_b32 a11, 0
	v_accvgpr_write_b32 a12, 0
	v_accvgpr_write_b32 a13, 0
	v_accvgpr_write_b32 a14, 0
	v_accvgpr_write_b32 a15, 0
.LBB1_4:                                ; %Flow181
	s_mul_i32 s0, s9, s11
	s_mul_i32 s1, s8, s4
	s_add_i32 s0, s0, s1
	s_mul_i32 s1, s10, s5
	s_add_i32 s0, s0, s1
	s_mov_b32 s1, 0
	v_or_b32_e32 v1, v12, v1
	s_nop 1
	v_accvgpr_read_b32 v18, a0
	s_lshl_b64 s[0:1], s[0:1], 1
	v_mad_u64_u32 v[0:1], s[2:3], v1, s6, v[0:1]
	s_add_u32 s0, s16, s0
	v_bfe_u32 v12, v18, 16, 1
	s_movk_i32 s2, 0x7fff
	s_addc_u32 s1, s17, s1
	v_mov_b32_e32 v1, 0
	v_add3_u32 v12, v12, v18, s2
	v_or_b32_e32 v19, 0x400000, v18
	v_cmp_u_f32_e32 vcc, v18, v18
	v_accvgpr_read_b32 v17, a1
	v_lshl_add_u64 v[0:1], v[0:1], 1, s[0:1]
	v_cndmask_b32_e32 v12, v12, v19, vcc
	global_store_short_d16_hi v[0:1], v12, off
	v_bfe_u32 v12, v17, 16, 1
	v_add3_u32 v12, v12, v17, s2
	v_or_b32_e32 v18, 0x400000, v17
	v_cmp_u_f32_e32 vcc, v17, v17
	s_ashr_i32 s7, s6, 31
	v_accvgpr_read_b32 v16, a2
	v_cndmask_b32_e32 v12, v12, v18, vcc
	v_lshl_add_u64 v[18:19], s[6:7], 1, v[0:1]
	global_store_short_d16_hi v[18:19], v12, off
	s_lshl_b32 s0, s6, 1
	v_bfe_u32 v12, v16, 16, 1
	v_add3_u32 v12, v12, v16, s2
	v_or_b32_e32 v17, 0x400000, v16
	v_cmp_u_f32_e32 vcc, v16, v16
	s_ashr_i32 s1, s0, 31
	v_accvgpr_read_b32 v15, a3
	v_cndmask_b32_e32 v12, v12, v17, vcc
	v_lshl_add_u64 v[16:17], s[0:1], 1, v[0:1]
	global_store_short_d16_hi v[16:17], v12, off
	s_mul_i32 s0, s6, 3
	v_bfe_u32 v12, v15, 16, 1
	v_add3_u32 v12, v12, v15, s2
	v_or_b32_e32 v16, 0x400000, v15
	v_cmp_u_f32_e32 vcc, v15, v15
	s_ashr_i32 s1, s0, 31
	v_accvgpr_read_b32 v14, a4
	v_cndmask_b32_e32 v12, v12, v16, vcc
	v_lshl_add_u64 v[16:17], s[0:1], 1, v[0:1]
	global_store_short_d16_hi v[16:17], v12, off
	s_lshl_b32 s0, s6, 3
	v_bfe_u32 v12, v14, 16, 1
	v_add3_u32 v12, v12, v14, s2
	v_or_b32_e32 v15, 0x400000, v14
	v_cmp_u_f32_e32 vcc, v14, v14
	s_ashr_i32 s1, s0, 31
	v_accvgpr_read_b32 v13, a5
	v_cndmask_b32_e32 v12, v12, v15, vcc
	v_lshl_add_u64 v[14:15], s[0:1], 1, v[0:1]
	global_store_short_d16_hi v[14:15], v12, off
	s_mul_i32 s0, s6, 9
	v_bfe_u32 v12, v13, 16, 1
	v_add3_u32 v12, v12, v13, s2
	v_or_b32_e32 v14, 0x400000, v13
	v_cmp_u_f32_e32 vcc, v13, v13
	s_ashr_i32 s1, s0, 31
	v_accvgpr_read_b32 v11, a6
	v_cndmask_b32_e32 v14, v12, v14, vcc
	v_lshl_add_u64 v[12:13], s[0:1], 1, v[0:1]
	global_store_short_d16_hi v[12:13], v14, off
	s_mul_i32 s0, s6, 10
	v_bfe_u32 v12, v11, 16, 1
	v_add3_u32 v12, v12, v11, s2
	v_or_b32_e32 v13, 0x400000, v11
	v_cmp_u_f32_e32 vcc, v11, v11
	s_ashr_i32 s1, s0, 31
	v_accvgpr_read_b32 v10, a7
	v_cndmask_b32_e32 v11, v12, v13, vcc
	v_lshl_add_u64 v[12:13], s[0:1], 1, v[0:1]
	global_store_short_d16_hi v[12:13], v11, off
	s_mul_i32 s0, s6, 11
	v_bfe_u32 v11, v10, 16, 1
	v_add3_u32 v11, v11, v10, s2
	v_or_b32_e32 v12, 0x400000, v10
	v_cmp_u_f32_e32 vcc, v10, v10
	s_ashr_i32 s1, s0, 31
	v_accvgpr_read_b32 v9, a8
	v_cndmask_b32_e32 v12, v11, v12, vcc
	v_lshl_add_u64 v[10:11], s[0:1], 1, v[0:1]
	global_store_short_d16_hi v[10:11], v12, off
	s_lshl_b32 s0, s6, 4
	v_bfe_u32 v10, v9, 16, 1
	v_add3_u32 v10, v10, v9, s2
	v_or_b32_e32 v11, 0x400000, v9
	v_cmp_u_f32_e32 vcc, v9, v9
	s_ashr_i32 s1, s0, 31
	v_accvgpr_read_b32 v8, a9
	v_cndmask_b32_e32 v9, v10, v11, vcc
	v_lshl_add_u64 v[10:11], s[0:1], 1, v[0:1]
	global_store_short_d16_hi v[10:11], v9, off
	s_mul_i32 s0, s6, 17
	v_bfe_u32 v9, v8, 16, 1
	v_add3_u32 v9, v9, v8, s2
	v_or_b32_e32 v10, 0x400000, v8
	v_cmp_u_f32_e32 vcc, v8, v8
	s_ashr_i32 s1, s0, 31
	v_accvgpr_read_b32 v7, a10
	v_cndmask_b32_e32 v10, v9, v10, vcc
	v_lshl_add_u64 v[8:9], s[0:1], 1, v[0:1]
	global_store_short_d16_hi v[8:9], v10, off
	s_mul_i32 s0, s6, 18
	v_bfe_u32 v8, v7, 16, 1
	v_add3_u32 v8, v8, v7, s2
	v_or_b32_e32 v9, 0x400000, v7
	v_cmp_u_f32_e32 vcc, v7, v7
	s_ashr_i32 s1, s0, 31
	v_accvgpr_read_b32 v6, a11
	v_cndmask_b32_e32 v7, v8, v9, vcc
	v_lshl_add_u64 v[8:9], s[0:1], 1, v[0:1]
	global_store_short_d16_hi v[8:9], v7, off
	s_mul_i32 s0, s6, 19
	v_bfe_u32 v7, v6, 16, 1
	v_add3_u32 v7, v7, v6, s2
	v_or_b32_e32 v8, 0x400000, v6
	v_cmp_u_f32_e32 vcc, v6, v6
	s_ashr_i32 s1, s0, 31
	v_accvgpr_read_b32 v5, a12
	v_cndmask_b32_e32 v8, v7, v8, vcc
	v_lshl_add_u64 v[6:7], s[0:1], 1, v[0:1]
	global_store_short_d16_hi v[6:7], v8, off
	s_mul_i32 s0, s6, 24
	v_bfe_u32 v6, v5, 16, 1
	v_add3_u32 v6, v6, v5, s2
	v_or_b32_e32 v7, 0x400000, v5
	v_cmp_u_f32_e32 vcc, v5, v5
	s_ashr_i32 s1, s0, 31
	v_accvgpr_read_b32 v4, a13
	v_cndmask_b32_e32 v5, v6, v7, vcc
	v_lshl_add_u64 v[6:7], s[0:1], 1, v[0:1]
	global_store_short_d16_hi v[6:7], v5, off
	s_mul_i32 s0, s6, 25
	v_bfe_u32 v5, v4, 16, 1
	v_add3_u32 v5, v5, v4, s2
	v_or_b32_e32 v6, 0x400000, v4
	v_cmp_u_f32_e32 vcc, v4, v4
	s_ashr_i32 s1, s0, 31
	v_accvgpr_read_b32 v3, a14
	v_cndmask_b32_e32 v6, v5, v6, vcc
	v_lshl_add_u64 v[4:5], s[0:1], 1, v[0:1]
	global_store_short_d16_hi v[4:5], v6, off
	s_mul_i32 s0, s6, 26
	v_bfe_u32 v4, v3, 16, 1
	v_add3_u32 v4, v4, v3, s2
	v_or_b32_e32 v5, 0x400000, v3
	v_cmp_u_f32_e32 vcc, v3, v3
	s_ashr_i32 s1, s0, 31
	v_accvgpr_read_b32 v2, a15
	v_cndmask_b32_e32 v3, v4, v5, vcc
	v_lshl_add_u64 v[4:5], s[0:1], 1, v[0:1]
	global_store_short_d16_hi v[4:5], v3, off
	s_mul_i32 s0, s6, 27
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s2
	v_or_b32_e32 v4, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	s_ashr_i32 s1, s0, 31
	v_lshl_add_u64 v[0:1], s[0:1], 1, v[0:1]
	v_cndmask_b32_e32 v2, v3, v4, vcc
	global_store_short_d16_hi v[0:1], v2, off
	s_endpgm
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i
		.amdhsa_group_segment_fixed_size 2048
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 80
		.amdhsa_user_sgpr_count 2
		.amdhsa_user_sgpr_dispatch_ptr 0
		.amdhsa_user_sgpr_queue_ptr 0
		.amdhsa_user_sgpr_kernarg_segment_ptr 1
		.amdhsa_user_sgpr_dispatch_id 0
		.amdhsa_user_sgpr_kernarg_preload_length 0
		.amdhsa_user_sgpr_kernarg_preload_offset 0
		.amdhsa_user_sgpr_private_segment_size 0
		.amdhsa_uses_dynamic_stack 0
		.amdhsa_enable_private_segment 0
		.amdhsa_system_sgpr_workgroup_id_x 1
		.amdhsa_system_sgpr_workgroup_id_y 1
		.amdhsa_system_sgpr_workgroup_id_z 1
		.amdhsa_system_sgpr_workgroup_info 0
		.amdhsa_system_vgpr_workitem_id 0
		.amdhsa_next_free_vgpr 48
		.amdhsa_next_free_sgpr 26
		.amdhsa_accum_offset 32
		.amdhsa_reserve_vcc 1
		.amdhsa_float_round_mode_32 0
		.amdhsa_float_round_mode_16_64 0
		.amdhsa_float_denorm_mode_32 3
		.amdhsa_float_denorm_mode_16_64 3
		.amdhsa_dx10_clamp 1
		.amdhsa_ieee_mode 1
		.amdhsa_fp16_overflow 0
		.amdhsa_tg_split 0
		.amdhsa_exception_fp_ieee_invalid_op 0
		.amdhsa_exception_fp_denorm_src 0
		.amdhsa_exception_fp_ieee_div_zero 0
		.amdhsa_exception_fp_ieee_overflow 0
		.amdhsa_exception_fp_ieee_underflow 0
		.amdhsa_exception_fp_ieee_inexact 0
		.amdhsa_exception_int_div_zero 0
	.end_amdhsa_kernel
	.section	.text._Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i,"axG",@progbits,_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i,comdat
.Lfunc_end1:
	.size	_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i, .Lfunc_end1-_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i
                                        ; -- End function
	.set _Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i.num_vgpr, 29
	.set _Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i.num_agpr, 16
	.set _Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i.numbered_sgpr, 26
	.set _Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i.private_seg_size, 0
	.set _Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i.uses_vcc, 1
	.set _Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i.uses_flat_scratch, 0
	.set _Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i.has_dyn_sized_stack, 0
	.set _Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i.has_recursion, 0
	.set _Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i.has_indirect_call, 0
	.section	.AMDGPU.csdata,"",@progbits
; Kernel info:
; codeLenInByte = 1856
; TotalNumSgprs: 32
; NumVgprs: 29
; NumAgprs: 16
; TotalNumVgprs: 48
; ScratchSize: 0
; MemoryBound: 0
; FloatMode: 240
; IeeeMode: 1
; LDSByteSize: 2048 bytes/workgroup (compile time only)
; SGPRBlocks: 3
; VGPRBlocks: 5
; NumSGPRsForWavesPerEU: 32
; NumVGPRsForWavesPerEU: 48
; AccumOffset: 32
; Occupancy: 8
; WaveLimiterHint : 0
; COMPUTE_PGM_RSRC2:SCRATCH_EN: 0
; COMPUTE_PGM_RSRC2:USER_SGPR: 2
; COMPUTE_PGM_RSRC2:TRAP_HANDLER: 0
; COMPUTE_PGM_RSRC2:TGID_X_EN: 1
; COMPUTE_PGM_RSRC2:TGID_Y_EN: 1
; COMPUTE_PGM_RSRC2:TGID_Z_EN: 1
; COMPUTE_PGM_RSRC2:TIDIG_COMP_CNT: 0
; COMPUTE_PGM_RSRC3_GFX90A:ACCUM_OFFSET: 7
; COMPUTE_PGM_RSRC3_GFX90A:TG_SPLIT: 0
	.text
	.p2alignl 6, 3212836864
	.fill 256, 4, 3212836864
	.section	.AMDGPU.gpr_maximums,"",@progbits
	.set amdgpu.max_num_vgpr, 0
	.set amdgpu.max_num_agpr, 0
	.set amdgpu.max_num_sgpr, 0
	.text
	.type	__hip_cuid_f59befd3832c6d3e,@object ; @__hip_cuid_f59befd3832c6d3e
	.section	.bss,"aw",@nobits
	.globl	__hip_cuid_f59befd3832c6d3e
__hip_cuid_f59befd3832c6d3e:
	.byte	0                               ; 0x0
	.size	__hip_cuid_f59befd3832c6d3e, 1

	.ident	"AMD clang version 20.0.0git (https://github.com/RadeonOpenCompute/llvm-project roc-7.0.1 25314 f4087f6b428f0e6f575ebac8a8a724dab123d06e)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym __hip_cuid_f59befd3832c6d3e
	.amdgpu_metadata
---
amdhsa.kernels:
  - .agpr_count:     0
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
      - .offset:         40
        .size:           4
        .value_kind:     hidden_block_count_x
      - .offset:         44
        .size:           4
        .value_kind:     hidden_block_count_y
      - .offset:         48
        .size:           4
        .value_kind:     hidden_block_count_z
      - .offset:         52
        .size:           2
        .value_kind:     hidden_group_size_x
      - .offset:         54
        .size:           2
        .value_kind:     hidden_group_size_y
      - .offset:         56
        .size:           2
        .value_kind:     hidden_group_size_z
      - .offset:         58
        .size:           2
        .value_kind:     hidden_remainder_x
      - .offset:         60
        .size:           2
        .value_kind:     hidden_remainder_y
      - .offset:         62
        .size:           2
        .value_kind:     hidden_remainder_z
      - .offset:         80
        .size:           8
        .value_kind:     hidden_global_offset_x
      - .offset:         88
        .size:           8
        .value_kind:     hidden_global_offset_y
      - .offset:         96
        .size:           8
        .value_kind:     hidden_global_offset_z
      - .offset:         104
        .size:           2
        .value_kind:     hidden_grid_dims
    .group_segment_fixed_size: 0
    .kernarg_segment_align: 8
    .kernarg_segment_size: 296
    .language:       OpenCL C
    .language_version:
      - 2
      - 0
    .max_flat_workgroup_size: 1024
    .name:           _Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b
    .private_segment_fixed_size: 0
    .sgpr_count:     24
    .sgpr_spill_count: 0
    .symbol:         _Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     12
    .vgpr_spill_count: 0
    .wavefront_size: 64
  - .agpr_count:     16
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
      - .offset:         40
        .size:           12
        .value_kind:     by_value
      - .offset:         52
        .size:           12
        .value_kind:     by_value
      - .offset:         64
        .size:           12
        .value_kind:     by_value
      - .offset:         76
        .size:           4
        .value_kind:     by_value
    .group_segment_fixed_size: 2048
    .kernarg_segment_align: 8
    .kernarg_segment_size: 80
    .language:       OpenCL C
    .language_version:
      - 2
      - 0
    .max_flat_workgroup_size: 256
    .name:           _Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i
    .private_segment_fixed_size: 0
    .sgpr_count:     32
    .sgpr_spill_count: 0
    .symbol:         _Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     48
    .vgpr_spill_count: 0
    .wavefront_size: 64
amdhsa.target:   amdgcn-amd-amdhsa--gfx942
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata

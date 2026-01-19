
	.amdhsa_code_object_version 6
	.section	.text._Z39batched_gemm_128x128x16_transe_improvedILj128ELj128ELj16EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_,"axG",@progbits,_Z39batched_gemm_128x128x16_transe_improvedILj128ELj128ELj16EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_,comdat
	.protected	_Z39batched_gemm_128x128x16_transe_improvedILj128ELj128ELj16EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_ ; -- Begin function _Z39batched_gemm_128x128x16_transe_improvedILj128ELj128ELj16EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_
	.globl	_Z39batched_gemm_128x128x16_transe_improvedILj128ELj128ELj16EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_
	.p2align	8
	.type	_Z39batched_gemm_128x128x16_transe_improvedILj128ELj128ELj16EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_,@function
_Z39batched_gemm_128x128x16_transe_improvedILj128ELj128ELj16EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_: ; @_Z39batched_gemm_128x128x16_transe_improvedILj128ELj128ELj16EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_
; %bb.0:
	s_load_dwordx2 s[6:7], s[0:1], 0x4
	s_load_dwordx4 s[16:19], s[0:1], 0x10
	s_load_dwordx2 s[20:21], s[0:1], 0x20
	s_load_dwordx8 s[8:15], s[0:1], 0x28
	s_load_dword s5, s[0:1], 0x48
	v_accvgpr_write_b32 a63, 0
	v_accvgpr_write_b32 a62, 0
	v_accvgpr_write_b32 a61, 0
	v_accvgpr_write_b32 a60, 0
	v_accvgpr_write_b32 a59, 0
	v_accvgpr_write_b32 a58, 0
	v_accvgpr_write_b32 a57, 0
	v_accvgpr_write_b32 a56, 0
	v_accvgpr_write_b32 a55, 0
	v_accvgpr_write_b32 a54, 0
	v_accvgpr_write_b32 a53, 0
	v_accvgpr_write_b32 a52, 0
	v_accvgpr_write_b32 a51, 0
	v_accvgpr_write_b32 a50, 0
	v_accvgpr_write_b32 a49, 0
	v_accvgpr_write_b32 a48, 0
	v_accvgpr_write_b32 a47, 0
	v_accvgpr_write_b32 a46, 0
	v_accvgpr_write_b32 a45, 0
	v_accvgpr_write_b32 a44, 0
	v_accvgpr_write_b32 a43, 0
	v_accvgpr_write_b32 a42, 0
	v_accvgpr_write_b32 a41, 0
	v_accvgpr_write_b32 a40, 0
	v_accvgpr_write_b32 a39, 0
	v_accvgpr_write_b32 a38, 0
	v_accvgpr_write_b32 a37, 0
	v_accvgpr_write_b32 a36, 0
	v_accvgpr_write_b32 a35, 0
	v_accvgpr_write_b32 a34, 0
	v_accvgpr_write_b32 a33, 0
	v_accvgpr_write_b32 a32, 0
	v_accvgpr_write_b32 a31, 0
	v_accvgpr_write_b32 a30, 0
	v_accvgpr_write_b32 a29, 0
	v_accvgpr_write_b32 a28, 0
	v_accvgpr_write_b32 a27, 0
	v_accvgpr_write_b32 a26, 0
	v_accvgpr_write_b32 a25, 0
	v_accvgpr_write_b32 a24, 0
	v_accvgpr_write_b32 a23, 0
	v_accvgpr_write_b32 a22, 0
	v_accvgpr_write_b32 a21, 0
	v_accvgpr_write_b32 a20, 0
	v_accvgpr_write_b32 a19, 0
	v_accvgpr_write_b32 a18, 0
	v_accvgpr_write_b32 a17, 0
	v_accvgpr_write_b32 a16, 0
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
	s_lshl_b32 s26, s2, 7
	v_lshrrev_b32_e32 v1, 7, v0
	v_and_b32_e32 v2, 63, v0
	s_waitcnt lgkmcnt(0)
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
	;;#ASMSTART
	global_load_dwordx4 v[10:13], v[10:11], off

	;;#ASMEND
	v_mov_b32_e32 v5, v3
	v_lshl_add_u64 v[14:15], v[4:5], 1, s[2:3]
	;;#ASMSTART
	global_load_dwordx4 v[20:23], v[14:15], off

	;;#ASMEND
	v_lshl_or_b32 v0, v7, 5, v9
	;;#ASMSTART
	s_waitcnt vmcnt(0)

	;;#ASMEND
	v_lshlrev_b32_e32 v9, 1, v17
	v_mad_u32_u24 v7, v0, 20, v6
	ds_write2_b64 v9, v[10:11], v[12:13] offset1:1
	v_mov_b32_e32 v9, 0x2800
	s_add_i32 s2, s7, -16
	v_lshl_add_u32 v9, v18, 1, v9
	s_cmp_gt_u32 s2, 15
	v_add_u32_e32 v15, 8, v8
	v_add_u32_e32 v16, 8, v7
	ds_write2_b64 v9, v[20:21], v[22:23] offset1:1
	s_barrier
	s_cbranch_scc0 .LBB0_4
; %bb.1:                                ; %.lr.ph.preheader
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
	v_add_u32_e32 v12, 0x500, v8
	v_add_u32_e32 v11, 0x500, v7
	v_add_u32_e32 v14, 8, v8
	v_add_u32_e32 v9, 0x508, v8
	v_add_u32_e32 v13, 8, v7
	v_add_u32_e32 v10, 0x508, v7
	s_addc_u32 s11, s11, 0
	s_setprio 1
.LBB0_2:                                ; %.lr.ph
                                        ; =>This Inner Loop Header: Depth=1
	v_lshl_add_u64 v[20:21], v[2:3], 1, s[10:11]
	;;#ASMSTART
	global_load_dwordx4 v[20:23], v[20:21], off

	;;#ASMEND
	v_lshl_add_u64 v[24:25], v[4:5], 1, s[8:9]
	;;#ASMSTART
	global_load_dwordx4 v[24:27], v[24:25], off

	;;#ASMEND
	; sched_barrier mask(0x00000000)
	s_mul_i32 s0, s1, 0x1400
	v_lshl_add_u32 v19, v8, 1, s0
	v_lshl_add_u32 v36, v7, 1, s0
	ds_read2st64_b64 v[28:31], v19 offset1:5
	ds_read2st64_b64 v[32:35], v36 offset0:20 offset1:25

	v_add_u32_e32 v19, 16, v19
	v_add_u32_e32 v32, 16, v36
	s_xor_b32 s1, s1, 1

	s_waitcnt lgkmcnt(0)
	v_mfma_f32_32x32x8_bf16 a[48:63], v[28:29], v[32:33], a[48:63]
	v_mfma_f32_32x32x8_bf16 a[32:47], v[28:29], v[34:35], a[32:47]
	v_mfma_f32_32x32x8_bf16 a[16:31], v[30:31], v[32:33], a[16:31]
	v_mfma_f32_32x32x8_bf16 a[0:15], v[30:31], v[34:35], a[0:15]

	ds_read2st64_b64 v[28:31], v19 offset1:5
	ds_read2st64_b64 v[32:35], v32 offset0:20 offset1:25

	s_waitcnt lgkmcnt(0)
	v_mfma_f32_32x32x8_bf16 a[48:63], v[28:29], v[32:33], a[48:63]
	v_mfma_f32_32x32x8_bf16 a[32:47], v[28:29], v[34:35], a[32:47]
	v_mfma_f32_32x32x8_bf16 a[16:31], v[30:31], v[32:33], a[16:31]
	v_mfma_f32_32x32x8_bf16 a[0:15], v[30:31], v[34:35], a[0:15]
	; sched_barrier mask(0x00000000)
	s_add_u32 s8, s8, s2
	s_mul_i32 s0, s1, 0x1400
	s_addc_u32 s9, s9, s3
	;;#ASMSTART
	s_waitcnt vmcnt(0)

	;;#ASMEND
	v_lshl_add_u32 v19, v17, 1, s0
	s_add_u32 s10, s10, 32
	ds_write2_b64 v19, v[20:21], v[22:23] offset1:1
	v_lshl_add_u32 v19, v18, 1, s0
	s_addc_u32 s11, s11, 0
	s_add_i32 s7, s7, -1
	v_add_u32_e32 v19, 0x2800, v19
	s_cmp_eq_u32 s7, 0
	ds_write2_b64 v19, v[24:25], v[26:27] offset1:1
	s_barrier
	s_cbranch_scc0 .LBB0_2
	s_setprio 0
; %bb.3:                                ; %Flow
	s_branch .LBB0_6
.LBB0_4:
                                        ; implicit-def: $agpr15
                                        ; implicit-def: $agpr31
                                        ; implicit-def: $agpr47
                                        ; implicit-def: $agpr63
                                        ; implicit-def: $sgpr1
                                        ; implicit-def: $vgpr12
                                        ; implicit-def: $vgpr11
                                        ; implicit-def: $vgpr14
                                        ; implicit-def: $vgpr9
                                        ; implicit-def: $vgpr13
                                        ; implicit-def: $vgpr10
	s_cbranch_execz .LBB0_6
; %bb.5:                                ; %.._crit_edge_crit_edge
	v_add_u32_e32 v12, 0x500, v8
	v_add_u32_e32 v11, 0x500, v7
	v_add_u32_e32 v9, 0x508, v8
	v_add_u32_e32 v10, 0x508, v7
	s_mov_b32 s1, 0
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
	v_accvgpr_write_b32 a31, 0
	v_accvgpr_write_b32 a30, 0
	v_accvgpr_write_b32 a29, 0
	v_accvgpr_write_b32 a28, 0
	v_accvgpr_write_b32 a27, 0
	v_accvgpr_write_b32 a26, 0
	v_accvgpr_write_b32 a25, 0
	v_accvgpr_write_b32 a24, 0
	v_accvgpr_write_b32 a23, 0
	v_accvgpr_write_b32 a22, 0
	v_accvgpr_write_b32 a21, 0
	v_accvgpr_write_b32 a20, 0
	v_accvgpr_write_b32 a19, 0
	v_accvgpr_write_b32 a18, 0
	v_accvgpr_write_b32 a17, 0
	v_accvgpr_write_b32 a16, 0
	v_accvgpr_write_b32 a47, 0
	v_accvgpr_write_b32 a46, 0
	v_accvgpr_write_b32 a45, 0
	v_accvgpr_write_b32 a44, 0
	v_accvgpr_write_b32 a43, 0
	v_accvgpr_write_b32 a42, 0
	v_accvgpr_write_b32 a41, 0
	v_accvgpr_write_b32 a40, 0
	v_accvgpr_write_b32 a39, 0
	v_accvgpr_write_b32 a38, 0
	v_accvgpr_write_b32 a37, 0
	v_accvgpr_write_b32 a36, 0
	v_accvgpr_write_b32 a35, 0
	v_accvgpr_write_b32 a34, 0
	v_accvgpr_write_b32 a33, 0
	v_accvgpr_write_b32 a32, 0
	v_accvgpr_write_b32 a63, 0
	v_accvgpr_write_b32 a62, 0
	v_accvgpr_write_b32 a61, 0
	v_accvgpr_write_b32 a60, 0
	v_accvgpr_write_b32 a59, 0
	v_accvgpr_write_b32 a58, 0
	v_accvgpr_write_b32 a57, 0
	v_accvgpr_write_b32 a56, 0
	v_accvgpr_write_b32 a55, 0
	v_accvgpr_write_b32 a54, 0
	v_accvgpr_write_b32 a53, 0
	v_accvgpr_write_b32 a52, 0
	v_accvgpr_write_b32 a51, 0
	v_accvgpr_write_b32 a50, 0
	v_accvgpr_write_b32 a49, 0
	v_accvgpr_write_b32 a48, 0
	v_mov_b32_e32 v13, v16
	v_mov_b32_e32 v14, v15
.LBB0_6:                                ; %._crit_edge
	s_mul_i32 s0, s15, s27
	s_mul_i32 s2, s14, s4
	s_add_i32 s0, s0, s2
	s_mul_i32 s5, s5, s26
	s_add_i32 s2, s0, s5
	s_mov_b32 s3, 0
	s_lshl_b64 s[4:5], s[2:3], 1
	s_add_u32 s4, s20, s4
	s_addc_u32 s5, s21, s5
	; sched_barrier mask(0x00000000)
	s_mul_i32 s0, s1, 0x1400
	v_lshl_add_u32 v2, v8, 1, s0
	ds_read_b64 v[2:3], v2
	s_add_i32 s1, s0, 0x2800
	v_lshl_add_u32 v4, v7, 1, s1
	v_lshl_add_u32 v7, v11, 1, s1
	v_lshl_add_u32 v8, v12, 1, s0
	ds_read_b64 v[4:5], v4
	ds_read_b64 v[16:17], v8
	ds_read_b64 v[18:19], v7
	s_waitcnt lgkmcnt(1)
	v_mfma_f32_32x32x8_bf16 a[16:31], v[16:17], v[4:5], a[16:31]
	;;#ASMSTART
	s_waitcnt lgkmcnt(0)

	;;#ASMEND
	v_lshl_add_u32 v7, v9, 1, s0
	ds_read_b64 v[8:9], v7
	v_lshl_add_u32 v7, v10, 1, s1
	ds_read_b64 v[10:11], v7
	v_mfma_f32_32x32x8_bf16 a[48:63], v[2:3], v[4:5], a[48:63]
	v_lshl_add_u32 v4, v13, 1, s1
	ds_read_b64 v[4:5], v4
	s_waitcnt lgkmcnt(3)
	v_mfma_f32_32x32x8_bf16 a[32:47], v[2:3], v[18:19], a[32:47]
	v_lshl_add_u32 v2, v14, 1, s0
	ds_read_b64 v[2:3], v2
	;;#ASMSTART
	s_waitcnt lgkmcnt(0)

	;;#ASMEND
	v_mfma_f32_32x32x8_bf16 a[0:15], v[16:17], v[18:19], a[0:15]
	s_waitcnt lgkmcnt(0)
	v_mfma_f32_32x32x8_bf16 a[48:63], v[2:3], v[4:5], a[48:63]
	v_mfma_f32_32x32x8_bf16 a[32:47], v[2:3], v[10:11], a[32:47]
	v_mfma_f32_32x32x8_bf16 a[16:31], v[8:9], v[4:5], a[16:31]
	v_mfma_f32_32x32x8_bf16 a[0:15], v[8:9], v[10:11], a[0:15]
	; sched_barrier mask(0x00000000)
	v_or_b32_e32 v1, v6, v1
	v_mad_u64_u32 v[0:1], s[0:1], v1, s6, v[0:1]
	s_nop 5
	v_accvgpr_read_b32 v2, a48
	v_bfe_u32 v3, v2, 16, 1
	s_movk_i32 s0, 0x7fff
	v_add3_u32 v3, v3, v2, s0
	v_or_b32_e32 v4, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	v_mov_b32_e32 v1, 0
	v_lshl_add_u64 v[0:1], v[0:1], 1, s[4:5]
	v_cndmask_b32_e32 v2, v3, v4, vcc
	v_accvgpr_read_b32 v3, a32
	v_bfe_u32 v4, v3, 16, 1
	v_add3_u32 v4, v4, v3, s0
	v_or_b32_e32 v5, 0x400000, v3
	v_cmp_u_f32_e32 vcc, v3, v3
	s_lshl_b32 s2, s6, 6
	s_ashr_i32 s7, s6, 31
	v_cndmask_b32_e32 v3, v4, v5, vcc
	v_accvgpr_read_b32 v4, a16
	v_bfe_u32 v5, v4, 16, 1
	v_add3_u32 v5, v5, v4, s0
	v_or_b32_e32 v6, 0x400000, v4
	v_cmp_u_f32_e32 vcc, v4, v4
	global_store_short_d16_hi v[0:1], v2, off
	global_store_short_d16_hi v[0:1], v3, off offset:128
	v_cndmask_b32_e32 v4, v5, v6, vcc
	v_accvgpr_read_b32 v5, a0
	v_bfe_u32 v6, v5, 16, 1
	v_add3_u32 v6, v6, v5, s0
	v_or_b32_e32 v7, 0x400000, v5
	v_cmp_u_f32_e32 vcc, v5, v5
	v_lshl_add_u64 v[2:3], s[2:3], 1, v[0:1]
	s_add_i32 s2, s2, 64
	v_cndmask_b32_e32 v5, v6, v7, vcc
	global_store_short_d16_hi v[2:3], v4, off
	v_lshl_add_u64 v[2:3], s[2:3], 1, v[0:1]
	global_store_short_d16_hi v[2:3], v5, off
	v_accvgpr_read_b32 v2, a49
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_or_b32_e32 v4, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a33
	v_or_b32_e32 v5, 0x400000, v2
	v_cndmask_b32_e32 v4, v3, v4, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a17
	v_or_b32_e32 v6, 0x400000, v2
	v_cndmask_b32_e32 v5, v3, v5, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a1
	v_or_b32_e32 v7, 0x400000, v2
	v_cndmask_b32_e32 v6, v3, v6, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	s_mul_i32 s4, s6, 0x41
	s_mov_b32 s5, s3
	v_cndmask_b32_e32 v7, v3, v7, vcc
	v_lshl_add_u64 v[2:3], s[6:7], 1, v[0:1]
	global_store_short_d16_hi v[2:3], v4, off
	global_store_short_d16_hi v[2:3], v5, off offset:128
	v_lshl_add_u64 v[2:3], s[4:5], 1, v[0:1]
	s_add_i32 s2, s2, s6
	global_store_short_d16_hi v[2:3], v6, off
	v_lshl_add_u64 v[2:3], s[2:3], 1, v[0:1]
	global_store_short_d16_hi v[2:3], v7, off
	v_accvgpr_read_b32 v2, a50
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_or_b32_e32 v4, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a34
	v_or_b32_e32 v5, 0x400000, v2
	v_cndmask_b32_e32 v4, v3, v4, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a18
	v_or_b32_e32 v6, 0x400000, v2
	v_cndmask_b32_e32 v5, v3, v5, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a2
	s_lshl_b32 s4, s6, 1
	v_cndmask_b32_e32 v6, v3, v6, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_or_b32_e32 v7, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	s_ashr_i32 s5, s4, 31
	s_add_i32 s2, s2, s6
	v_cndmask_b32_e32 v7, v3, v7, vcc
	v_lshl_add_u64 v[2:3], s[4:5], 1, v[0:1]
	s_mul_i32 s4, s6, 0x42
	s_mov_b32 s5, s3
	global_store_short_d16_hi v[2:3], v4, off
	global_store_short_d16_hi v[2:3], v5, off offset:128
	v_lshl_add_u64 v[2:3], s[4:5], 1, v[0:1]
	global_store_short_d16_hi v[2:3], v6, off
	v_lshl_add_u64 v[2:3], s[2:3], 1, v[0:1]
	global_store_short_d16_hi v[2:3], v7, off
	v_accvgpr_read_b32 v2, a51
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_or_b32_e32 v4, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a35
	v_or_b32_e32 v5, 0x400000, v2
	v_cndmask_b32_e32 v4, v3, v4, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a19
	v_or_b32_e32 v6, 0x400000, v2
	v_cndmask_b32_e32 v5, v3, v5, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a3
	s_mul_i32 s4, s6, 3
	v_cndmask_b32_e32 v6, v3, v6, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_or_b32_e32 v7, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	s_ashr_i32 s5, s4, 31
	s_add_i32 s2, s2, s6
	v_cndmask_b32_e32 v7, v3, v7, vcc
	v_lshl_add_u64 v[2:3], s[4:5], 1, v[0:1]
	s_mul_i32 s4, s6, 0x43
	s_mov_b32 s5, s3
	global_store_short_d16_hi v[2:3], v4, off
	global_store_short_d16_hi v[2:3], v5, off offset:128
	v_lshl_add_u64 v[2:3], s[4:5], 1, v[0:1]
	global_store_short_d16_hi v[2:3], v6, off
	v_lshl_add_u64 v[2:3], s[2:3], 1, v[0:1]
	global_store_short_d16_hi v[2:3], v7, off
	v_accvgpr_read_b32 v2, a52
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_or_b32_e32 v4, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a36
	v_or_b32_e32 v5, 0x400000, v2
	v_cndmask_b32_e32 v4, v3, v4, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a20
	v_or_b32_e32 v6, 0x400000, v2
	v_cndmask_b32_e32 v5, v3, v5, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a4
	s_lshl_b32 s4, s6, 3
	v_cndmask_b32_e32 v6, v3, v6, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_or_b32_e32 v7, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	s_ashr_i32 s5, s4, 31
	s_mul_i32 s1, s6, 5
	v_cndmask_b32_e32 v7, v3, v7, vcc
	v_lshl_add_u64 v[2:3], s[4:5], 1, v[0:1]
	s_mul_i32 s4, s6, 0x48
	s_mov_b32 s5, s3
	global_store_short_d16_hi v[2:3], v4, off
	global_store_short_d16_hi v[2:3], v5, off offset:128
	v_lshl_add_u64 v[2:3], s[4:5], 1, v[0:1]
	s_add_i32 s2, s2, s1
	global_store_short_d16_hi v[2:3], v6, off
	v_lshl_add_u64 v[2:3], s[2:3], 1, v[0:1]
	global_store_short_d16_hi v[2:3], v7, off
	v_accvgpr_read_b32 v2, a53
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_or_b32_e32 v4, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a37
	v_or_b32_e32 v5, 0x400000, v2
	v_cndmask_b32_e32 v4, v3, v4, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a21
	v_or_b32_e32 v6, 0x400000, v2
	v_cndmask_b32_e32 v5, v3, v5, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a5
	s_mul_i32 s4, s6, 9
	v_cndmask_b32_e32 v6, v3, v6, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_or_b32_e32 v7, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	s_ashr_i32 s5, s4, 31
	s_add_i32 s2, s2, s6
	v_cndmask_b32_e32 v7, v3, v7, vcc
	v_lshl_add_u64 v[2:3], s[4:5], 1, v[0:1]
	s_mul_i32 s4, s6, 0x49
	s_mov_b32 s5, s3
	global_store_short_d16_hi v[2:3], v4, off
	global_store_short_d16_hi v[2:3], v5, off offset:128
	v_lshl_add_u64 v[2:3], s[4:5], 1, v[0:1]
	global_store_short_d16_hi v[2:3], v6, off
	v_lshl_add_u64 v[2:3], s[2:3], 1, v[0:1]
	global_store_short_d16_hi v[2:3], v7, off
	v_accvgpr_read_b32 v2, a54
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_or_b32_e32 v4, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a38
	v_or_b32_e32 v5, 0x400000, v2
	v_cndmask_b32_e32 v4, v3, v4, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a22
	v_or_b32_e32 v6, 0x400000, v2
	v_cndmask_b32_e32 v5, v3, v5, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a6
	s_mul_i32 s4, s6, 10
	v_cndmask_b32_e32 v6, v3, v6, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_or_b32_e32 v7, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	s_ashr_i32 s5, s4, 31
	s_add_i32 s2, s2, s6
	v_cndmask_b32_e32 v7, v3, v7, vcc
	v_lshl_add_u64 v[2:3], s[4:5], 1, v[0:1]
	s_mul_i32 s4, s6, 0x4a
	s_mov_b32 s5, s3
	global_store_short_d16_hi v[2:3], v4, off
	global_store_short_d16_hi v[2:3], v5, off offset:128
	v_lshl_add_u64 v[2:3], s[4:5], 1, v[0:1]
	global_store_short_d16_hi v[2:3], v6, off
	v_lshl_add_u64 v[2:3], s[2:3], 1, v[0:1]
	global_store_short_d16_hi v[2:3], v7, off
	v_accvgpr_read_b32 v2, a55
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_or_b32_e32 v4, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a39
	v_or_b32_e32 v5, 0x400000, v2
	v_cndmask_b32_e32 v4, v3, v4, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a23
	v_or_b32_e32 v6, 0x400000, v2
	v_cndmask_b32_e32 v5, v3, v5, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a7
	s_mul_i32 s4, s6, 11
	v_cndmask_b32_e32 v6, v3, v6, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_or_b32_e32 v7, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	s_ashr_i32 s5, s4, 31
	s_add_i32 s2, s2, s6
	v_cndmask_b32_e32 v7, v3, v7, vcc
	v_lshl_add_u64 v[2:3], s[4:5], 1, v[0:1]
	s_mul_i32 s4, s6, 0x4b
	s_mov_b32 s5, s3
	global_store_short_d16_hi v[2:3], v4, off
	global_store_short_d16_hi v[2:3], v5, off offset:128
	v_lshl_add_u64 v[2:3], s[4:5], 1, v[0:1]
	global_store_short_d16_hi v[2:3], v6, off
	v_lshl_add_u64 v[2:3], s[2:3], 1, v[0:1]
	global_store_short_d16_hi v[2:3], v7, off
	v_accvgpr_read_b32 v2, a56
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_or_b32_e32 v4, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a40
	v_or_b32_e32 v5, 0x400000, v2
	v_cndmask_b32_e32 v4, v3, v4, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a24
	v_or_b32_e32 v6, 0x400000, v2
	v_cndmask_b32_e32 v5, v3, v5, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a8
	s_lshl_b32 s4, s6, 4
	v_cndmask_b32_e32 v6, v3, v6, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_or_b32_e32 v7, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	s_ashr_i32 s5, s4, 31
	s_add_i32 s2, s2, s1
	v_cndmask_b32_e32 v7, v3, v7, vcc
	v_lshl_add_u64 v[2:3], s[4:5], 1, v[0:1]
	s_mul_i32 s4, s6, 0x50
	s_mov_b32 s5, s3
	global_store_short_d16_hi v[2:3], v4, off
	global_store_short_d16_hi v[2:3], v5, off offset:128
	v_lshl_add_u64 v[2:3], s[4:5], 1, v[0:1]
	global_store_short_d16_hi v[2:3], v6, off
	v_lshl_add_u64 v[2:3], s[2:3], 1, v[0:1]
	global_store_short_d16_hi v[2:3], v7, off
	v_accvgpr_read_b32 v2, a57
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_or_b32_e32 v4, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a41
	v_or_b32_e32 v5, 0x400000, v2
	v_cndmask_b32_e32 v4, v3, v4, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a25
	v_or_b32_e32 v6, 0x400000, v2
	v_cndmask_b32_e32 v5, v3, v5, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a9
	s_mul_i32 s4, s6, 17
	v_cndmask_b32_e32 v6, v3, v6, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_or_b32_e32 v7, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	s_ashr_i32 s5, s4, 31
	s_add_i32 s2, s2, s6
	v_cndmask_b32_e32 v7, v3, v7, vcc
	v_lshl_add_u64 v[2:3], s[4:5], 1, v[0:1]
	s_mul_i32 s4, s6, 0x51
	s_mov_b32 s5, s3
	global_store_short_d16_hi v[2:3], v4, off
	global_store_short_d16_hi v[2:3], v5, off offset:128
	v_lshl_add_u64 v[2:3], s[4:5], 1, v[0:1]
	global_store_short_d16_hi v[2:3], v6, off
	v_lshl_add_u64 v[2:3], s[2:3], 1, v[0:1]
	global_store_short_d16_hi v[2:3], v7, off
	v_accvgpr_read_b32 v2, a58
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_or_b32_e32 v4, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a42
	v_or_b32_e32 v5, 0x400000, v2
	v_cndmask_b32_e32 v4, v3, v4, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a26
	v_or_b32_e32 v6, 0x400000, v2
	v_cndmask_b32_e32 v5, v3, v5, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a10
	s_mul_i32 s4, s6, 18
	v_cndmask_b32_e32 v6, v3, v6, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_or_b32_e32 v7, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	s_ashr_i32 s5, s4, 31
	s_add_i32 s2, s2, s6
	v_cndmask_b32_e32 v7, v3, v7, vcc
	v_lshl_add_u64 v[2:3], s[4:5], 1, v[0:1]
	s_mul_i32 s4, s6, 0x52
	s_mov_b32 s5, s3
	global_store_short_d16_hi v[2:3], v4, off
	global_store_short_d16_hi v[2:3], v5, off offset:128
	v_lshl_add_u64 v[2:3], s[4:5], 1, v[0:1]
	global_store_short_d16_hi v[2:3], v6, off
	v_lshl_add_u64 v[2:3], s[2:3], 1, v[0:1]
	global_store_short_d16_hi v[2:3], v7, off
	v_accvgpr_read_b32 v2, a59
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_or_b32_e32 v4, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a43
	v_or_b32_e32 v5, 0x400000, v2
	v_cndmask_b32_e32 v4, v3, v4, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a27
	v_or_b32_e32 v6, 0x400000, v2
	v_cndmask_b32_e32 v5, v3, v5, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a11
	s_mul_i32 s4, s6, 19
	v_cndmask_b32_e32 v6, v3, v6, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_or_b32_e32 v7, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	s_ashr_i32 s5, s4, 31
	s_add_i32 s2, s2, s6
	v_cndmask_b32_e32 v7, v3, v7, vcc
	v_lshl_add_u64 v[2:3], s[4:5], 1, v[0:1]
	s_mul_i32 s4, s6, 0x53
	s_mov_b32 s5, s3
	global_store_short_d16_hi v[2:3], v4, off
	global_store_short_d16_hi v[2:3], v5, off offset:128
	v_lshl_add_u64 v[2:3], s[4:5], 1, v[0:1]
	global_store_short_d16_hi v[2:3], v6, off
	v_lshl_add_u64 v[2:3], s[2:3], 1, v[0:1]
	global_store_short_d16_hi v[2:3], v7, off
	v_accvgpr_read_b32 v2, a60
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_or_b32_e32 v4, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a44
	v_or_b32_e32 v5, 0x400000, v2
	v_cndmask_b32_e32 v4, v3, v4, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a28
	v_or_b32_e32 v6, 0x400000, v2
	v_cndmask_b32_e32 v5, v3, v5, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a12
	s_mul_i32 s4, s6, 24
	v_cndmask_b32_e32 v6, v3, v6, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_or_b32_e32 v7, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	s_ashr_i32 s5, s4, 31
	s_add_i32 s2, s2, s1
	v_cndmask_b32_e32 v7, v3, v7, vcc
	v_lshl_add_u64 v[2:3], s[4:5], 1, v[0:1]
	s_mul_i32 s4, s6, 0x58
	s_mov_b32 s5, s3
	global_store_short_d16_hi v[2:3], v4, off
	global_store_short_d16_hi v[2:3], v5, off offset:128
	v_lshl_add_u64 v[2:3], s[4:5], 1, v[0:1]
	global_store_short_d16_hi v[2:3], v6, off
	v_lshl_add_u64 v[2:3], s[2:3], 1, v[0:1]
	global_store_short_d16_hi v[2:3], v7, off
	v_accvgpr_read_b32 v2, a61
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_or_b32_e32 v4, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a45
	v_or_b32_e32 v5, 0x400000, v2
	v_cndmask_b32_e32 v4, v3, v4, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a29
	v_or_b32_e32 v6, 0x400000, v2
	v_cndmask_b32_e32 v5, v3, v5, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a13
	s_mul_i32 s4, s6, 25
	v_cndmask_b32_e32 v6, v3, v6, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_or_b32_e32 v7, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	s_ashr_i32 s5, s4, 31
	s_add_i32 s2, s2, s6
	v_cndmask_b32_e32 v7, v3, v7, vcc
	v_lshl_add_u64 v[2:3], s[4:5], 1, v[0:1]
	s_mul_i32 s4, s6, 0x59
	s_mov_b32 s5, s3
	global_store_short_d16_hi v[2:3], v4, off
	global_store_short_d16_hi v[2:3], v5, off offset:128
	v_lshl_add_u64 v[2:3], s[4:5], 1, v[0:1]
	global_store_short_d16_hi v[2:3], v6, off
	v_lshl_add_u64 v[2:3], s[2:3], 1, v[0:1]
	global_store_short_d16_hi v[2:3], v7, off
	v_accvgpr_read_b32 v2, a62
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_or_b32_e32 v4, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a46
	v_or_b32_e32 v5, 0x400000, v2
	v_cndmask_b32_e32 v4, v3, v4, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a30
	v_or_b32_e32 v6, 0x400000, v2
	v_cndmask_b32_e32 v5, v3, v5, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a14
	s_mul_i32 s4, s6, 26
	v_cndmask_b32_e32 v6, v3, v6, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_or_b32_e32 v7, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	s_ashr_i32 s5, s4, 31
	s_add_i32 s2, s2, s6
	v_cndmask_b32_e32 v7, v3, v7, vcc
	v_lshl_add_u64 v[2:3], s[4:5], 1, v[0:1]
	s_mul_i32 s4, s6, 0x5a
	s_mov_b32 s5, s3
	global_store_short_d16_hi v[2:3], v4, off
	global_store_short_d16_hi v[2:3], v5, off offset:128
	v_lshl_add_u64 v[2:3], s[4:5], 1, v[0:1]
	global_store_short_d16_hi v[2:3], v6, off
	v_lshl_add_u64 v[2:3], s[2:3], 1, v[0:1]
	global_store_short_d16_hi v[2:3], v7, off
	v_accvgpr_read_b32 v2, a63
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_or_b32_e32 v4, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a47
	v_or_b32_e32 v5, 0x400000, v2
	v_cndmask_b32_e32 v4, v3, v4, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a31
	v_or_b32_e32 v6, 0x400000, v2
	v_cndmask_b32_e32 v5, v3, v5, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_cmp_u_f32_e32 vcc, v2, v2
	v_accvgpr_read_b32 v2, a15
	s_mul_i32 s4, s6, 27
	v_cndmask_b32_e32 v6, v3, v6, vcc
	v_bfe_u32 v3, v2, 16, 1
	v_add3_u32 v3, v3, v2, s0
	v_or_b32_e32 v7, 0x400000, v2
	v_cmp_u_f32_e32 vcc, v2, v2
	s_ashr_i32 s5, s4, 31
	s_mul_i32 s0, s6, 0x5b
	v_cndmask_b32_e32 v7, v3, v7, vcc
	v_lshl_add_u64 v[2:3], s[4:5], 1, v[0:1]
	s_mov_b32 s1, s3
	s_add_i32 s2, s2, s6
	global_store_short_d16_hi v[2:3], v4, off
	global_store_short_d16_hi v[2:3], v5, off offset:128
	v_lshl_add_u64 v[2:3], s[0:1], 1, v[0:1]
	v_lshl_add_u64 v[0:1], s[2:3], 1, v[0:1]
	global_store_short_d16_hi v[2:3], v6, off
	global_store_short_d16_hi v[0:1], v7, off
	s_endpgm
	.section	.rodata,"a",@progbits
	.p2align	6, 0x0
	.amdhsa_kernel _Z39batched_gemm_128x128x16_transe_improvedILj128ELj128ELj16EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_
		.amdhsa_group_segment_fixed_size 20480
		.amdhsa_private_segment_fixed_size 0
		.amdhsa_kernarg_size 76
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
		.amdhsa_next_free_vgpr 129
		.amdhsa_next_free_sgpr 96
		.amdhsa_accum_offset 40
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
	.section	.text._Z39batched_gemm_128x128x16_transe_improvedILj128ELj128ELj16EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_,"axG",@progbits,_Z39batched_gemm_128x128x16_transe_improvedILj128ELj128ELj16EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_,comdat
.Lfunc_end0:
	.size	_Z39batched_gemm_128x128x16_transe_improvedILj128ELj128ELj16EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_, .Lfunc_end0-_Z39batched_gemm_128x128x16_transe_improvedILj128ELj128ELj16EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_
                                        ; -- End function
	.set _Z39batched_gemm_128x128x16_transe_improvedILj128ELj128ELj16EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_.num_vgpr, 37
	.set _Z39batched_gemm_128x128x16_transe_improvedILj128ELj128ELj16EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_.num_agpr, 64
	.set _Z39batched_gemm_128x128x16_transe_improvedILj128ELj128ELj16EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_.numbered_sgpr, 30
	.set _Z39batched_gemm_128x128x16_transe_improvedILj128ELj128ELj16EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_.private_seg_size, 0
	.set _Z39batched_gemm_128x128x16_transe_improvedILj128ELj128ELj16EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_.uses_vcc, 1
	.set _Z39batched_gemm_128x128x16_transe_improvedILj128ELj128ELj16EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_.uses_flat_scratch, 0
	.set _Z39batched_gemm_128x128x16_transe_improvedILj128ELj128ELj16EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_.has_dyn_sized_stack, 0
	.set _Z39batched_gemm_128x128x16_transe_improvedILj128ELj128ELj16EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_.has_recursion, 0
	.set _Z39batched_gemm_128x128x16_transe_improvedILj128ELj128ELj16EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_.has_indirect_call, 0
	.section	.AMDGPU.csdata,"",@progbits
; Kernel info:
; codeLenInByte = 5904
; TotalNumSgprs: 36
; NumVgprs: 37
; NumAgprs: 64
; TotalNumVgprs: 104
; ScratchSize: 0
; MemoryBound: 0
; FloatMode: 240
; IeeeMode: 1
; LDSByteSize: 20480 bytes/workgroup (compile time only)
; SGPRBlocks: 12
; VGPRBlocks: 16
; NumSGPRsForWavesPerEU: 102
; NumVGPRsForWavesPerEU: 129
; AccumOffset: 40
; Occupancy: 3
; WaveLimiterHint : 1
; COMPUTE_PGM_RSRC2:SCRATCH_EN: 0
; COMPUTE_PGM_RSRC2:USER_SGPR: 2
; COMPUTE_PGM_RSRC2:TRAP_HANDLER: 0
; COMPUTE_PGM_RSRC2:TGID_X_EN: 1
; COMPUTE_PGM_RSRC2:TGID_Y_EN: 1
; COMPUTE_PGM_RSRC2:TGID_Z_EN: 1
; COMPUTE_PGM_RSRC2:TIDIG_COMP_CNT: 0
; COMPUTE_PGM_RSRC3_GFX90A:ACCUM_OFFSET: 9
; COMPUTE_PGM_RSRC3_GFX90A:TG_SPLIT: 0
	.text
	.p2alignl 6, 3212836864
	.fill 256, 4, 3212836864
	.section	.AMDGPU.gpr_maximums,"",@progbits
	.set amdgpu.max_num_vgpr, 0
	.set amdgpu.max_num_agpr, 0
	.set amdgpu.max_num_sgpr, 0
	.text
	.type	__hip_cuid_924673a8825c1a02,@object ; @__hip_cuid_924673a8825c1a02
	.section	.bss,"aw",@nobits
	.globl	__hip_cuid_924673a8825c1a02
__hip_cuid_924673a8825c1a02:
	.byte	0                               ; 0x0
	.size	__hip_cuid_924673a8825c1a02, 1

	.ident	"AMD clang version 20.0.0git (https://github.com/RadeonOpenCompute/llvm-project roc-7.0.1 25314 f4087f6b428f0e6f575ebac8a8a724dab123d06e)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym __hip_cuid_924673a8825c1a02
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
      - .offset:         40
        .size:           12
        .value_kind:     by_value
      - .offset:         52
        .size:           12
        .value_kind:     by_value
      - .offset:         64
        .size:           12
        .value_kind:     by_value
    .group_segment_fixed_size: 20480
    .kernarg_segment_align: 8
    .kernarg_segment_size: 76
    .language:       OpenCL C
    .language_version:
      - 2
      - 0
    .max_flat_workgroup_size: 256
    .name:           _Z39batched_gemm_128x128x16_transe_improvedILj128ELj128ELj16EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_
    .private_segment_fixed_size: 0
    .sgpr_count:     36
    .sgpr_spill_count: 0
    .symbol:         _Z39batched_gemm_128x128x16_transe_improvedILj128ELj128ELj16EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_.kd
    .uniform_work_group_size: 1
    .uses_dynamic_stack: false
    .vgpr_count:     104
    .vgpr_spill_count: 0
    .wavefront_size: 64
amdhsa.target:   amdgcn-amd-amdhsa--gfx942
amdhsa.version:
  - 1
  - 2
...

	.end_amdgpu_metadata

	.file	"batched_gemm.cpp"
                                        # Start of file scope inline assembly
	.globl	_ZSt21ios_base_library_initv

                                        # End of file scope inline assembly
	.text
	.globl	_ZN6cktile13bf16_to_floatEDF16b # -- Begin function _ZN6cktile13bf16_to_floatEDF16b
	.p2align	4
	.type	_ZN6cktile13bf16_to_floatEDF16b,@function
_ZN6cktile13bf16_to_floatEDF16b:        # @_ZN6cktile13bf16_to_floatEDF16b
	.cfi_startproc
# %bb.0:
	pextrw	$0, %xmm0, %eax
	shll	$16, %eax
	movd	%eax, %xmm0
	retq
.Lfunc_end0:
	.size	_ZN6cktile13bf16_to_floatEDF16b, .Lfunc_end0-_ZN6cktile13bf16_to_floatEDF16b
	.cfi_endproc
                                        # -- End function
	.globl	_Z50__device_stub__batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b # -- Begin function _Z50__device_stub__batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b
	.p2align	4
	.type	_Z50__device_stub__batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b,@function
_Z50__device_stub__batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b: # @_Z50__device_stub__batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b
	.cfi_startproc
# %bb.0:
	subq	$136, %rsp
	.cfi_def_cfa_offset 144
	movl	%edi, 12(%rsp)
	movl	%esi, 8(%rsp)
	movl	%edx, 4(%rsp)
	movl	%ecx, (%rsp)
	movq	%r8, 72(%rsp)
	movq	%r9, 64(%rsp)
	leaq	12(%rsp), %rax
	movq	%rax, 80(%rsp)
	leaq	8(%rsp), %rax
	movq	%rax, 88(%rsp)
	leaq	4(%rsp), %rax
	movq	%rax, 96(%rsp)
	movq	%rsp, %rax
	movq	%rax, 104(%rsp)
	leaq	72(%rsp), %rax
	movq	%rax, 112(%rsp)
	leaq	64(%rsp), %rax
	movq	%rax, 120(%rsp)
	leaq	144(%rsp), %rax
	movq	%rax, 128(%rsp)
	leaq	48(%rsp), %rdi
	leaq	32(%rsp), %rsi
	leaq	24(%rsp), %rdx
	leaq	16(%rsp), %rcx
	callq	__hipPopCallConfiguration
	movq	48(%rsp), %rsi
	movl	56(%rsp), %edx
	movq	32(%rsp), %rcx
	movl	40(%rsp), %r8d
	leaq	80(%rsp), %r9
	movl	$_Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b, %edi
	pushq	16(%rsp)
	.cfi_adjust_cfa_offset 8
	pushq	32(%rsp)
	.cfi_adjust_cfa_offset 8
	callq	hipLaunchKernel
	addq	$152, %rsp
	.cfi_adjust_cfa_offset -152
	retq
.Lfunc_end1:
	.size	_Z50__device_stub__batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b, .Lfunc_end1-_Z50__device_stub__batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b
	.cfi_endproc
                                        # -- End function
	.globl	_Z16randomize_matrixPDF16bi     # -- Begin function _Z16randomize_matrixPDF16bi
	.p2align	4
	.type	_Z16randomize_matrixPDF16bi,@function
_Z16randomize_matrixPDF16bi:            # @_Z16randomize_matrixPDF16bi
	.cfi_startproc
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%rbx
	.cfi_def_cfa_offset 40
	subq	$24, %rsp
	.cfi_def_cfa_offset 64
	.cfi_offset %rbx, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movl	%esi, %ebp
	movq	%rdi, %rbx
	xorps	%xmm0, %xmm0
	movaps	%xmm0, (%rsp)
	movq	%rsp, %rdi
	xorl	%esi, %esi
	callq	gettimeofday
	movl	$8773, %edi                     # imm = 0x2245
	callq	srand
	testl	%ebp, %ebp
	jle	.LBB2_3
# %bb.1:                                # %.lr.ph.preheader
	movl	%ebp, %r14d
	xorl	%r15d, %r15d
	.p2align	4
.LBB2_2:                                # %.lr.ph
                                        # =>This Inner Loop Header: Depth=1
	callq	rand
	callq	rand
	callq	rand
	movw	$16256, (%rbx,%r15,2)           # imm = 0x3F80
	incq	%r15
	cmpq	%r15, %r14
	jne	.LBB2_2
.LBB2_3:                                # %._crit_edge
	addq	$24, %rsp
	.cfi_def_cfa_offset 40
	popq	%rbx
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.Lfunc_end2:
	.size	_Z16randomize_matrixPDF16bi, .Lfunc_end2-_Z16randomize_matrixPDF16bi
	.cfi_endproc
                                        # -- End function
	.section	.rodata.cst4,"aM",@progbits,4
	.p2align	2, 0x0                          # -- Begin function main
.LCPI3_0:
	.long	0x42c80000                      # float 100
	.section	.rodata.cst8,"aM",@progbits,8
	.p2align	3, 0x0
.LCPI3_1:
	.quad	0x41cdcd6500000000              # double 1.0E+9
.LCPI3_2:
	.quad	0x41e0000000000000              # double 2147483648
.LCPI3_4:
	.quad	0x3eb0c6f7a0b5ed8d              # double 9.9999999999999995E-7
	.section	.rodata.cst16,"aM",@progbits,16
	.p2align	4, 0x0
.LCPI3_3:
	.long	0x7fffffff                      # float NaN
	.long	0x7fffffff                      # float NaN
	.long	0x7fffffff                      # float NaN
	.long	0x7fffffff                      # float NaN
	.text
	.globl	main
	.p2align	4
	.type	main,@function
main:                                   # @main
.Lfunc_begin0:
	.cfi_startproc
	.cfi_personality 3, __gxx_personality_v0
	.cfi_lsda 3, .Lexception0
# %bb.0:
	pushq	%rbp
	.cfi_def_cfa_offset 16
	pushq	%r15
	.cfi_def_cfa_offset 24
	pushq	%r14
	.cfi_def_cfa_offset 32
	pushq	%r13
	.cfi_def_cfa_offset 40
	pushq	%r12
	.cfi_def_cfa_offset 48
	pushq	%rbx
	.cfi_def_cfa_offset 56
	subq	$648, %rsp                      # imm = 0x288
	.cfi_def_cfa_offset 704
	.cfi_offset %rbx, -56
	.cfi_offset %r12, -48
	.cfi_offset %r13, -40
	.cfi_offset %r14, -32
	.cfi_offset %r15, -24
	.cfi_offset %rbp, -16
	movq	$0, 80(%rsp)
	movq	$0, 72(%rsp)
	movq	$0, 40(%rsp)
	.cfi_escape 0x2e, 0x00
	movl	$4194304, %edi                  # imm = 0x400000
	callq	malloc
	movq	%rax, %r15
	.cfi_escape 0x2e, 0x00
	movl	$16777216, %edi                 # imm = 0x1000000
	callq	malloc
	movq	%rax, %r14
	.cfi_escape 0x2e, 0x00
	movl	$16777216, %edi                 # imm = 0x1000000
	callq	malloc
	movq	%rax, 112(%rsp)                 # 8-byte Spill
	xorps	%xmm0, %xmm0
	movaps	%xmm0, 272(%rsp)
	.cfi_escape 0x2e, 0x00
	xorl	%ebx, %ebx
	leaq	272(%rsp), %rdi
	xorl	%esi, %esi
	callq	gettimeofday
	.cfi_escape 0x2e, 0x00
	movl	$8773, %edi                     # imm = 0x2245
	callq	srand
	.p2align	4
.LBB3_1:                                # %.lr.ph.i
                                        # =>This Inner Loop Header: Depth=1
	.cfi_escape 0x2e, 0x00
	callq	rand
	.cfi_escape 0x2e, 0x00
	callq	rand
	.cfi_escape 0x2e, 0x00
	callq	rand
	movw	$16256, (%r15,%rbx,2)           # imm = 0x3F80
	incq	%rbx
	cmpq	$2097152, %rbx                  # imm = 0x200000
	jne	.LBB3_1
# %bb.2:                                # %_Z16randomize_matrixPDF16bi.exit
	xorps	%xmm0, %xmm0
	movaps	%xmm0, 272(%rsp)
	.cfi_escape 0x2e, 0x00
	xorl	%ebx, %ebx
	leaq	272(%rsp), %rdi
	xorl	%esi, %esi
	callq	gettimeofday
	.cfi_escape 0x2e, 0x00
	movl	$8773, %edi                     # imm = 0x2245
	callq	srand
	.p2align	4
.LBB3_3:                                # %.lr.ph.i208
                                        # =>This Inner Loop Header: Depth=1
	.cfi_escape 0x2e, 0x00
	callq	rand
	.cfi_escape 0x2e, 0x00
	callq	rand
	.cfi_escape 0x2e, 0x00
	callq	rand
	movw	$16256, (%r14,%rbx,2)           # imm = 0x3F80
	incq	%rbx
	cmpq	$8388608, %rbx                  # imm = 0x800000
	jne	.LBB3_3
# %bb.4:                                # %_Z16randomize_matrixPDF16bi.exit212
	.cfi_escape 0x2e, 0x00
	movl	$.Lstr, %edi
	callq	puts@PLT
	.cfi_escape 0x2e, 0x00
	leaq	80(%rsp), %rdi
	movl	$4194304, %esi                  # imm = 0x400000
	callq	hipMalloc
	testl	%eax, %eax
	jne	.LBB3_52
# %bb.5:
	.cfi_escape 0x2e, 0x00
	leaq	72(%rsp), %rdi
	movl	$16777216, %esi                 # imm = 0x1000000
	callq	hipMalloc
	testl	%eax, %eax
	jne	.LBB3_62
# %bb.6:
	.cfi_escape 0x2e, 0x00
	leaq	40(%rsp), %rdi
	movl	$16777216, %esi                 # imm = 0x1000000
	callq	hipMalloc
	testl	%eax, %eax
	jne	.LBB3_72
# %bb.7:
	movq	40(%rsp), %rdi
	.cfi_escape 0x2e, 0x00
	movl	$16777216, %edx                 # imm = 0x1000000
	xorl	%esi, %esi
	callq	hipMemset
	testl	%eax, %eax
	jne	.LBB3_82
# %bb.8:
	movq	80(%rsp), %rdi
	.cfi_escape 0x2e, 0x00
	movl	$4194304, %edx                  # imm = 0x400000
	movq	%r15, %rsi
	movl	$1, %ecx
	callq	hipMemcpy
	testl	%eax, %eax
	jne	.LBB3_92
# %bb.9:
	movq	72(%rsp), %rdi
	.cfi_escape 0x2e, 0x00
	movl	$16777216, %edx                 # imm = 0x1000000
	movq	%r14, %rsi
	movl	$1, %ecx
	callq	hipMemcpy
	testl	%eax, %eax
	jne	.LBB3_102
# %bb.10:                               # %.preheader360
	movq	%r15, 232(%rsp)                 # 8-byte Spill
	movabsq	$8589934600, %r12               # imm = 0x200000008
	movl	$50, %ebp
	movabsq	$4294967552, %r13               # imm = 0x100000100
	movabsq	$2199023321088, %rbx            # imm = 0x20000010000
	jmp	.LBB3_12
	.p2align	4
.LBB3_11:                               #   in Loop: Header=BB3_12 Depth=1
	decl	%ebp
	je	.LBB3_15
.LBB3_12:                               # =>This Inner Loop Header: Depth=1
	movq	40(%rsp), %rdi
	.cfi_escape 0x2e, 0x00
	movl	$16777216, %edx                 # imm = 0x1000000
	xorl	%esi, %esi
	callq	hipMemset
	testl	%eax, %eax
	jne	.LBB3_32
# %bb.13:                               #   in Loop: Header=BB3_12 Depth=1
	.cfi_escape 0x2e, 0x00
	movq	%r12, %rdi
	movl	$128, %esi
	movq	%r13, %rdx
	movl	$1, %ecx
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	callq	__hipPushCallConfiguration
	testl	%eax, %eax
	jne	.LBB3_11
# %bb.14:                               #   in Loop: Header=BB3_12 Depth=1
	movq	80(%rsp), %rax
	movq	%rax, 216(%rsp)
	movq	72(%rsp), %rax
	movq	%rax, 208(%rsp)
	movq	40(%rsp), %rax
	movq	%rax, 200(%rsp)
	movq	%rbx, 168(%rsp)
	movl	$1, 176(%rsp)
	movq	%rbx, 152(%rsp)
	movl	$1, 160(%rsp)
	movabsq	$549755830272, %rax             # imm = 0x8000004000
	movq	%rax, 136(%rsp)
	movl	$1, 144(%rsp)
	movl	$128, 68(%rsp)
	movl	$512, 64(%rsp)                  # imm = 0x200
	movl	$128, 60(%rsp)
	movl	$128, 56(%rsp)
	movl	$1, 52(%rsp)
	leaq	68(%rsp), %rax
	movq	%rax, 272(%rsp)
	leaq	64(%rsp), %rax
	movq	%rax, 280(%rsp)
	leaq	60(%rsp), %rax
	movq	%rax, 288(%rsp)
	leaq	56(%rsp), %rax
	movq	%rax, 296(%rsp)
	leaq	216(%rsp), %rax
	movq	%rax, 304(%rsp)
	leaq	208(%rsp), %rax
	movq	%rax, 312(%rsp)
	leaq	200(%rsp), %rax
	movq	%rax, 320(%rsp)
	leaq	136(%rsp), %rax
	movq	%rax, 328(%rsp)
	leaq	152(%rsp), %rax
	movq	%rax, 336(%rsp)
	leaq	168(%rsp), %rax
	movq	%rax, 344(%rsp)
	leaq	52(%rsp), %rax
	movq	%rax, 352(%rsp)
	.cfi_escape 0x2e, 0x00
	leaq	8(%rsp), %rdi
	leaq	88(%rsp), %rsi
	leaq	192(%rsp), %rdx
	leaq	184(%rsp), %rcx
	callq	__hipPopCallConfiguration
	movq	8(%rsp), %rsi
	movl	16(%rsp), %edx
	movq	88(%rsp), %rcx
	movl	96(%rsp), %r8d
	.cfi_escape 0x2e, 0x10
	movl	$_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i, %edi
	leaq	272(%rsp), %r9
	pushq	184(%rsp)
	.cfi_adjust_cfa_offset 8
	pushq	200(%rsp)
	.cfi_adjust_cfa_offset 8
	callq	hipLaunchKernel
	addq	$16, %rsp
	.cfi_adjust_cfa_offset -16
	jmp	.LBB3_11
.LBB3_15:
	.cfi_escape 0x2e, 0x00
	leaq	128(%rsp), %rdi
	callq	hipEventCreate
	.cfi_escape 0x2e, 0x00
	leaq	104(%rsp), %rdi
	callq	hipEventCreate
	.cfi_escape 0x2e, 0x00
	callq	hipDeviceSynchronize
	movq	128(%rsp), %rdi
	.cfi_escape 0x2e, 0x00
	xorl	%esi, %esi
	callq	hipEventRecord
	movl	$100, %ebp
	jmp	.LBB3_17
	.p2align	4
.LBB3_16:                               #   in Loop: Header=BB3_17 Depth=1
	decl	%ebp
	je	.LBB3_20
.LBB3_17:                               # =>This Inner Loop Header: Depth=1
	movq	40(%rsp), %rdi
	.cfi_escape 0x2e, 0x00
	movl	$16777216, %edx                 # imm = 0x1000000
	xorl	%esi, %esi
	callq	hipMemset
	testl	%eax, %eax
	jne	.LBB3_42
# %bb.18:                               #   in Loop: Header=BB3_17 Depth=1
	.cfi_escape 0x2e, 0x00
	movq	%r12, %rdi
	movl	$128, %esi
	movq	%r13, %rdx
	movl	$1, %ecx
	xorl	%r8d, %r8d
	xorl	%r9d, %r9d
	callq	__hipPushCallConfiguration
	testl	%eax, %eax
	jne	.LBB3_16
# %bb.19:                               #   in Loop: Header=BB3_17 Depth=1
	movq	80(%rsp), %rax
	movq	%rax, 216(%rsp)
	movq	72(%rsp), %rax
	movq	%rax, 208(%rsp)
	movq	40(%rsp), %rax
	movq	%rax, 200(%rsp)
	movq	%rbx, 168(%rsp)
	movl	$1, 176(%rsp)
	movq	%rbx, 152(%rsp)
	movl	$1, 160(%rsp)
	movabsq	$549755830272, %rax             # imm = 0x8000004000
	movq	%rax, 136(%rsp)
	movl	$1, 144(%rsp)
	movl	$128, 68(%rsp)
	movl	$512, 64(%rsp)                  # imm = 0x200
	movl	$128, 60(%rsp)
	movl	$128, 56(%rsp)
	movl	$1, 52(%rsp)
	leaq	68(%rsp), %rax
	movq	%rax, 272(%rsp)
	leaq	64(%rsp), %rax
	movq	%rax, 280(%rsp)
	leaq	60(%rsp), %rax
	movq	%rax, 288(%rsp)
	leaq	56(%rsp), %rax
	movq	%rax, 296(%rsp)
	leaq	216(%rsp), %rax
	movq	%rax, 304(%rsp)
	leaq	208(%rsp), %rax
	movq	%rax, 312(%rsp)
	leaq	200(%rsp), %rax
	movq	%rax, 320(%rsp)
	leaq	136(%rsp), %rax
	movq	%rax, 328(%rsp)
	leaq	152(%rsp), %rax
	movq	%rax, 336(%rsp)
	leaq	168(%rsp), %rax
	movq	%rax, 344(%rsp)
	leaq	52(%rsp), %rax
	movq	%rax, 352(%rsp)
	.cfi_escape 0x2e, 0x00
	leaq	8(%rsp), %rdi
	leaq	88(%rsp), %rsi
	leaq	192(%rsp), %rdx
	leaq	184(%rsp), %rcx
	callq	__hipPopCallConfiguration
	movq	8(%rsp), %rsi
	movl	16(%rsp), %edx
	movq	88(%rsp), %rcx
	movl	96(%rsp), %r8d
	.cfi_escape 0x2e, 0x10
	movl	$_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i, %edi
	leaq	272(%rsp), %r9
	pushq	184(%rsp)
	.cfi_adjust_cfa_offset 8
	pushq	200(%rsp)
	.cfi_adjust_cfa_offset 8
	callq	hipLaunchKernel
	addq	$16, %rsp
	.cfi_adjust_cfa_offset -16
	jmp	.LBB3_16
.LBB3_20:
	movq	104(%rsp), %rdi
	.cfi_escape 0x2e, 0x00
	xorl	%esi, %esi
	callq	hipEventRecord
	movq	104(%rsp), %rdi
	.cfi_escape 0x2e, 0x00
	callq	hipEventSynchronize
	.cfi_escape 0x2e, 0x00
	callq	hipDeviceSynchronize
	movq	128(%rsp), %rsi
	movq	104(%rsp), %rdx
	.cfi_escape 0x2e, 0x00
	leaq	88(%rsp), %rdi
	callq	hipEventElapsedTime
	movq	128(%rsp), %rdi
	.cfi_escape 0x2e, 0x00
	callq	hipEventDestroy
	movq	104(%rsp), %rdi
	.cfi_escape 0x2e, 0x00
	callq	hipEventDestroy
	movq	40(%rsp), %rsi
	.cfi_escape 0x2e, 0x00
	movl	$16777216, %edx                 # imm = 0x1000000
	movq	112(%rsp), %rdi                 # 8-byte Reload
	movl	$2, %ecx
	callq	hipMemcpy
	testl	%eax, %eax
	jne	.LBB3_112
# %bb.21:
	movss	88(%rsp), %xmm0                 # xmm0 = mem[0],zero,zero,zero
	divss	.LCPI3_0(%rip), %xmm0
	cvtss2sd	%xmm0, %xmm0
	movsd	%xmm0, 120(%rsp)                # 8-byte Spill
	.cfi_escape 0x2e, 0x00
	movl	$.L.str.5, %edi
	movb	$1, %al
	callq	printf
	movsd	120(%rsp), %xmm1                # 8-byte Reload
                                        # xmm1 = mem[0],zero
	mulsd	.LCPI3_1(%rip), %xmm1
	movsd	.LCPI3_2(%rip), %xmm0           # xmm0 = [2.147483648E+9,0.0E+0]
	divsd	%xmm1, %xmm0
	cvtsd2ss	%xmm0, %xmm0
	cvtss2sd	%xmm0, %xmm0
	.cfi_escape 0x2e, 0x00
	movl	$.L.str.6, %edi
	movl	$128, %esi
	movl	$512, %edx                      # imm = 0x200
	movl	$128, %ecx
	movl	$128, %r8d
	movb	$1, %al
	callq	printf
	movq	232(%rsp), %rbp                 # 8-byte Reload
	addq	$2, %rbp
	movq	%r14, %r15
	addq	$1024, %r15                     # imm = 0x400
	xorl	%eax, %eax
.LBB3_22:                               # %.preheader359
                                        # =>This Loop Header: Depth=1
                                        #     Child Loop BB3_23 Depth 2
                                        #       Child Loop BB3_24 Depth 3
                                        #         Child Loop BB3_25 Depth 4
	movq	%rax, 240(%rsp)                 # 8-byte Spill
	shlq	$17, %rax
	addq	112(%rsp), %rax                 # 8-byte Folded Reload
	movq	%rbp, 248(%rsp)                 # 8-byte Spill
	xorl	%ebx, %ebx
	movq	%r15, 264(%rsp)                 # 8-byte Spill
	movq	%rax, 256(%rsp)                 # 8-byte Spill
.LBB3_23:                               # %.preheader358
                                        #   Parent Loop BB3_22 Depth=1
                                        # =>  This Loop Header: Depth=2
                                        #       Child Loop BB3_24 Depth 3
                                        #         Child Loop BB3_25 Depth 4
	movq	%rbx, %r12
	shlq	$10, %r12
	addq	%rax, %r12
	xorl	%r13d, %r13d
	.p2align	4
.LBB3_24:                               # %.preheader
                                        #   Parent Loop BB3_22 Depth=1
                                        #     Parent Loop BB3_23 Depth=2
                                        # =>    This Loop Header: Depth=3
                                        #         Child Loop BB3_25 Depth 4
	xorps	%xmm0, %xmm0
	movq	%r15, %rax
	xorl	%ecx, %ecx
	.p2align	4
.LBB3_25:                               #   Parent Loop BB3_22 Depth=1
                                        #     Parent Loop BB3_23 Depth=2
                                        #       Parent Loop BB3_24 Depth=3
                                        # =>      This Inner Loop Header: Depth=4
	movzwl	-2(%rbp,%rcx,2), %edx
	shll	$16, %edx
	movd	%edx, %xmm2
	movzwl	-1024(%rax), %edx
	shll	$16, %edx
	movd	%edx, %xmm1
	mulss	%xmm2, %xmm1
	addss	%xmm0, %xmm1
	movzwl	(%rbp,%rcx,2), %edx
	shll	$16, %edx
	movd	%edx, %xmm2
	movzwl	(%rax), %edx
	shll	$16, %edx
	movd	%edx, %xmm0
	mulss	%xmm2, %xmm0
	addss	%xmm1, %xmm0
	addq	$2, %rcx
	addq	$2048, %rax                     # imm = 0x800
	cmpq	$128, %rcx
	jne	.LBB3_25
# %bb.26:                               #   in Loop: Header=BB3_24 Depth=3
	.cfi_escape 0x2e, 0x00
	movss	%xmm0, 120(%rsp)                # 4-byte Spill
	callq	__truncsfbf2@PLT
	pextrw	$0, %xmm0, %eax
	movzwl	(%r12,%r13,2), %ecx
	shll	$16, %ecx
	movd	%ecx, %xmm1
	shll	$16, %eax
	movd	%eax, %xmm0
	movd	%xmm1, 228(%rsp)                # 4-byte Folded Spill
	subss	%xmm1, %xmm0
	.cfi_escape 0x2e, 0x00
	callq	__truncsfbf2@PLT
	pextrw	$0, %xmm0, %eax
	shll	$16, %eax
	movd	%eax, %xmm0
	pand	.LCPI3_3(%rip), %xmm0
	.cfi_escape 0x2e, 0x00
	callq	__truncsfbf2@PLT
	pextrw	$0, %xmm0, %eax
	shll	$16, %eax
	movd	%eax, %xmm0
	cvtss2sd	%xmm0, %xmm0
	ucomisd	.LCPI3_4(%rip), %xmm0
	ja	.LBB3_30
# %bb.27:                               #   in Loop: Header=BB3_24 Depth=3
	incq	%r13
	addq	$2, %r15
	cmpq	$512, %r13                      # imm = 0x200
	jne	.LBB3_24
# %bb.28:                               #   in Loop: Header=BB3_23 Depth=2
	incq	%rbx
	addq	$256, %rbp                      # imm = 0x100
	cmpq	$128, %rbx
	movq	264(%rsp), %r15                 # 8-byte Reload
	movq	256(%rsp), %rax                 # 8-byte Reload
	jne	.LBB3_23
# %bb.29:                               #   in Loop: Header=BB3_22 Depth=1
	movq	240(%rsp), %rax                 # 8-byte Reload
	incq	%rax
	movq	248(%rsp), %rbp                 # 8-byte Reload
	addq	$32768, %rbp                    # imm = 0x8000
	addq	$131072, %r15                   # imm = 0x20000
	cmpq	$128, %rax
	jne	.LBB3_22
	jmp	.LBB3_31
.LBB3_30:                               # %.thread356
	movss	120(%rsp), %xmm0                # 4-byte Reload
                                        # xmm0 = mem[0],zero,zero,zero
	cvtss2sd	%xmm0, %xmm0
	movss	228(%rsp), %xmm1                # 4-byte Reload
                                        # xmm1 = mem[0],zero,zero,zero
	cvtss2sd	%xmm1, %xmm1
	.cfi_escape 0x2e, 0x00
	movl	$.L.str.7, %edi
	movb	$2, %al
	callq	printf
	.cfi_escape 0x2e, 0x00
	movl	$.Lstr.1, %edi
	callq	puts@PLT
.LBB3_31:                               # %.loopexit
	.cfi_escape 0x2e, 0x00
	movq	232(%rsp), %rdi                 # 8-byte Reload
	callq	free
	.cfi_escape 0x2e, 0x00
	movq	%r14, %rdi
	callq	free
	.cfi_escape 0x2e, 0x00
	movq	112(%rsp), %rdi                 # 8-byte Reload
	callq	free
	movq	80(%rsp), %rdi
	.cfi_escape 0x2e, 0x00
	callq	hipFree
	movq	72(%rsp), %rdi
	.cfi_escape 0x2e, 0x00
	callq	hipFree
	movq	40(%rsp), %rdi
	.cfi_escape 0x2e, 0x00
	callq	hipFree
	xorl	%eax, %eax
	addq	$648, %rsp                      # imm = 0x288
	.cfi_def_cfa_offset 56
	popq	%rbx
	.cfi_def_cfa_offset 48
	popq	%r12
	.cfi_def_cfa_offset 40
	popq	%r13
	.cfi_def_cfa_offset 32
	popq	%r14
	.cfi_def_cfa_offset 24
	popq	%r15
	.cfi_def_cfa_offset 16
	popq	%rbp
	.cfi_def_cfa_offset 8
	retq
.LBB3_32:
	.cfi_def_cfa_offset 704
	movl	%eax, %r15d
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rbx
	movq	%rbx, %rdi
	callq	_ZNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEEC1Ev
.Ltmp138:
	.cfi_escape 0x2e, 0x00
	movl	$.L.str.1, %esi
	movl	$21, %edx
	movq	%rbx, %rdi
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp139:
# %bb.33:                               # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit251
.Ltmp140:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	movl	$.L.str.2, %esi
	movl	$16, %edx
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp141:
# %bb.34:                               # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit252
.Ltmp142:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	movl	$.L.str.3, %esi
	movl	$1, %edx
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp143:
# %bb.35:                               # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit253
.Ltmp144:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	movl	$100, %esi
	callq	_ZNSolsEi
.Ltmp145:
# %bb.36:
.Ltmp146:
	movq	%rax, %rbx
	.cfi_escape 0x2e, 0x00
	movl	$.L.str.4, %esi
	movl	$2, %edx
	movq	%rax, %rdi
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp147:
# %bb.37:                               # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit254
.Ltmp148:
	.cfi_escape 0x2e, 0x00
	movl	%r15d, %edi
	callq	hipGetErrorString
.Ltmp149:
# %bb.38:
.Ltmp150:
	.cfi_escape 0x2e, 0x00
	movq	%rbx, %rdi
	movq	%rax, %rsi
	callq	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
.Ltmp151:
# %bb.39:
	.cfi_escape 0x2e, 0x00
	movl	$16, %edi
	callq	__cxa_allocate_exception
	movq	%rax, %r14
.Ltmp153:
	.cfi_escape 0x2e, 0x00
	leaq	8(%rsp), %rdi
	leaq	272(%rsp), %rsi
	callq	_ZNKSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEE3strEv
.Ltmp154:
# %bb.40:
	movb	$1, %bpl
.Ltmp156:
	.cfi_escape 0x2e, 0x00
	leaq	8(%rsp), %rsi
	movq	%r14, %rdi
	callq	_ZNSt13runtime_errorC1ERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
.Ltmp157:
# %bb.41:
	xorl	%ebp, %ebp
.Ltmp158:
	.cfi_escape 0x2e, 0x00
	movl	$_ZTISt13runtime_error, %esi
	movl	$_ZNSt13runtime_errorD1Ev, %edx
	movq	%r14, %rdi
	callq	__cxa_throw
.Ltmp159:
	jmp	.LBB3_122
.LBB3_42:
	movl	%eax, %r15d
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rbx
	movq	%rbx, %rdi
	callq	_ZNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEEC1Ev
.Ltmp161:
	.cfi_escape 0x2e, 0x00
	movl	$.L.str.1, %esi
	movl	$21, %edx
	movq	%rbx, %rdi
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp162:
# %bb.43:                               # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit258
.Ltmp163:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	movl	$.L.str.2, %esi
	movl	$16, %edx
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp164:
# %bb.44:                               # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit259
.Ltmp165:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	movl	$.L.str.3, %esi
	movl	$1, %edx
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp166:
# %bb.45:                               # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit260
.Ltmp167:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	movl	$112, %esi
	callq	_ZNSolsEi
.Ltmp168:
# %bb.46:
.Ltmp169:
	movq	%rax, %rbx
	.cfi_escape 0x2e, 0x00
	movl	$.L.str.4, %esi
	movl	$2, %edx
	movq	%rax, %rdi
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp170:
# %bb.47:                               # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit261
.Ltmp171:
	.cfi_escape 0x2e, 0x00
	movl	%r15d, %edi
	callq	hipGetErrorString
.Ltmp172:
# %bb.48:
.Ltmp173:
	.cfi_escape 0x2e, 0x00
	movq	%rbx, %rdi
	movq	%rax, %rsi
	callq	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
.Ltmp174:
# %bb.49:
	.cfi_escape 0x2e, 0x00
	movl	$16, %edi
	callq	__cxa_allocate_exception
	movq	%rax, %r14
.Ltmp176:
	.cfi_escape 0x2e, 0x00
	leaq	8(%rsp), %rdi
	leaq	272(%rsp), %rsi
	callq	_ZNKSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEE3strEv
.Ltmp177:
# %bb.50:
	movb	$1, %bpl
.Ltmp179:
	.cfi_escape 0x2e, 0x00
	leaq	8(%rsp), %rsi
	movq	%r14, %rdi
	callq	_ZNSt13runtime_errorC1ERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
.Ltmp180:
# %bb.51:
	xorl	%ebp, %ebp
.Ltmp181:
	.cfi_escape 0x2e, 0x00
	movl	$_ZTISt13runtime_error, %esi
	movl	$_ZNSt13runtime_errorD1Ev, %edx
	movq	%r14, %rdi
	callq	__cxa_throw
.Ltmp182:
	jmp	.LBB3_122
.LBB3_52:
	movl	%eax, %ebx
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %r14
	movq	%r14, %rdi
	callq	_ZNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEEC1Ev
.Ltmp0:
	.cfi_escape 0x2e, 0x00
	movl	$.L.str.1, %esi
	movl	$21, %edx
	movq	%r14, %rdi
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp1:
# %bb.53:                               # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit
.Ltmp2:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	movl	$.L.str.2, %esi
	movl	$16, %edx
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp3:
# %bb.54:                               # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit213
.Ltmp4:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	movl	$.L.str.3, %esi
	movl	$1, %edx
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp5:
# %bb.55:                               # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit214
.Ltmp6:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	movl	$73, %esi
	callq	_ZNSolsEi
.Ltmp7:
# %bb.56:
.Ltmp8:
	movq	%rax, %r14
	.cfi_escape 0x2e, 0x00
	movl	$.L.str.4, %esi
	movl	$2, %edx
	movq	%rax, %rdi
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp9:
# %bb.57:                               # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit215
.Ltmp10:
	.cfi_escape 0x2e, 0x00
	movl	%ebx, %edi
	callq	hipGetErrorString
.Ltmp11:
# %bb.58:
.Ltmp12:
	.cfi_escape 0x2e, 0x00
	movq	%r14, %rdi
	movq	%rax, %rsi
	callq	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
.Ltmp13:
# %bb.59:
	.cfi_escape 0x2e, 0x00
	movl	$16, %edi
	callq	__cxa_allocate_exception
	movq	%rax, %r14
.Ltmp15:
	.cfi_escape 0x2e, 0x00
	leaq	8(%rsp), %rdi
	leaq	272(%rsp), %rsi
	callq	_ZNKSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEE3strEv
.Ltmp16:
# %bb.60:
	movb	$1, %bpl
.Ltmp18:
	.cfi_escape 0x2e, 0x00
	leaq	8(%rsp), %rsi
	movq	%r14, %rdi
	callq	_ZNSt13runtime_errorC1ERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
.Ltmp19:
# %bb.61:
	xorl	%ebp, %ebp
.Ltmp20:
	.cfi_escape 0x2e, 0x00
	movl	$_ZTISt13runtime_error, %esi
	movl	$_ZNSt13runtime_errorD1Ev, %edx
	movq	%r14, %rdi
	callq	__cxa_throw
.Ltmp21:
	jmp	.LBB3_122
.LBB3_62:
	movl	%eax, %ebx
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %r14
	movq	%r14, %rdi
	callq	_ZNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEEC1Ev
.Ltmp23:
	.cfi_escape 0x2e, 0x00
	movl	$.L.str.1, %esi
	movl	$21, %edx
	movq	%r14, %rdi
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp24:
# %bb.63:                               # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit216
.Ltmp25:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	movl	$.L.str.2, %esi
	movl	$16, %edx
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp26:
# %bb.64:                               # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit217
.Ltmp27:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	movl	$.L.str.3, %esi
	movl	$1, %edx
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp28:
# %bb.65:                               # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit218
.Ltmp29:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	movl	$74, %esi
	callq	_ZNSolsEi
.Ltmp30:
# %bb.66:
.Ltmp31:
	movq	%rax, %r14
	.cfi_escape 0x2e, 0x00
	movl	$.L.str.4, %esi
	movl	$2, %edx
	movq	%rax, %rdi
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp32:
# %bb.67:                               # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit219
.Ltmp33:
	.cfi_escape 0x2e, 0x00
	movl	%ebx, %edi
	callq	hipGetErrorString
.Ltmp34:
# %bb.68:
.Ltmp35:
	.cfi_escape 0x2e, 0x00
	movq	%r14, %rdi
	movq	%rax, %rsi
	callq	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
.Ltmp36:
# %bb.69:
	.cfi_escape 0x2e, 0x00
	movl	$16, %edi
	callq	__cxa_allocate_exception
	movq	%rax, %r14
.Ltmp38:
	.cfi_escape 0x2e, 0x00
	leaq	8(%rsp), %rdi
	leaq	272(%rsp), %rsi
	callq	_ZNKSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEE3strEv
.Ltmp39:
# %bb.70:
	movb	$1, %bpl
.Ltmp41:
	.cfi_escape 0x2e, 0x00
	leaq	8(%rsp), %rsi
	movq	%r14, %rdi
	callq	_ZNSt13runtime_errorC1ERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
.Ltmp42:
# %bb.71:
	xorl	%ebp, %ebp
.Ltmp43:
	.cfi_escape 0x2e, 0x00
	movl	$_ZTISt13runtime_error, %esi
	movl	$_ZNSt13runtime_errorD1Ev, %edx
	movq	%r14, %rdi
	callq	__cxa_throw
.Ltmp44:
	jmp	.LBB3_122
.LBB3_72:
	movl	%eax, %ebx
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %r14
	movq	%r14, %rdi
	callq	_ZNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEEC1Ev
.Ltmp46:
	.cfi_escape 0x2e, 0x00
	movl	$.L.str.1, %esi
	movl	$21, %edx
	movq	%r14, %rdi
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp47:
# %bb.73:                               # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit223
.Ltmp48:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	movl	$.L.str.2, %esi
	movl	$16, %edx
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp49:
# %bb.74:                               # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit224
.Ltmp50:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	movl	$.L.str.3, %esi
	movl	$1, %edx
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp51:
# %bb.75:                               # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit225
.Ltmp52:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	movl	$75, %esi
	callq	_ZNSolsEi
.Ltmp53:
# %bb.76:
.Ltmp54:
	movq	%rax, %r14
	.cfi_escape 0x2e, 0x00
	movl	$.L.str.4, %esi
	movl	$2, %edx
	movq	%rax, %rdi
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp55:
# %bb.77:                               # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit226
.Ltmp56:
	.cfi_escape 0x2e, 0x00
	movl	%ebx, %edi
	callq	hipGetErrorString
.Ltmp57:
# %bb.78:
.Ltmp58:
	.cfi_escape 0x2e, 0x00
	movq	%r14, %rdi
	movq	%rax, %rsi
	callq	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
.Ltmp59:
# %bb.79:
	.cfi_escape 0x2e, 0x00
	movl	$16, %edi
	callq	__cxa_allocate_exception
	movq	%rax, %r14
.Ltmp61:
	.cfi_escape 0x2e, 0x00
	leaq	8(%rsp), %rdi
	leaq	272(%rsp), %rsi
	callq	_ZNKSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEE3strEv
.Ltmp62:
# %bb.80:
	movb	$1, %bpl
.Ltmp64:
	.cfi_escape 0x2e, 0x00
	leaq	8(%rsp), %rsi
	movq	%r14, %rdi
	callq	_ZNSt13runtime_errorC1ERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
.Ltmp65:
# %bb.81:
	xorl	%ebp, %ebp
.Ltmp66:
	.cfi_escape 0x2e, 0x00
	movl	$_ZTISt13runtime_error, %esi
	movl	$_ZNSt13runtime_errorD1Ev, %edx
	movq	%r14, %rdi
	callq	__cxa_throw
.Ltmp67:
	jmp	.LBB3_122
.LBB3_82:
	movl	%eax, %ebx
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %r14
	movq	%r14, %rdi
	callq	_ZNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEEC1Ev
.Ltmp69:
	.cfi_escape 0x2e, 0x00
	movl	$.L.str.1, %esi
	movl	$21, %edx
	movq	%r14, %rdi
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp70:
# %bb.83:                               # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit230
.Ltmp71:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	movl	$.L.str.2, %esi
	movl	$16, %edx
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp72:
# %bb.84:                               # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit231
.Ltmp73:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	movl	$.L.str.3, %esi
	movl	$1, %edx
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp74:
# %bb.85:                               # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit232
.Ltmp75:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	movl	$79, %esi
	callq	_ZNSolsEi
.Ltmp76:
# %bb.86:
.Ltmp77:
	movq	%rax, %r14
	.cfi_escape 0x2e, 0x00
	movl	$.L.str.4, %esi
	movl	$2, %edx
	movq	%rax, %rdi
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp78:
# %bb.87:                               # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit233
.Ltmp79:
	.cfi_escape 0x2e, 0x00
	movl	%ebx, %edi
	callq	hipGetErrorString
.Ltmp80:
# %bb.88:
.Ltmp81:
	.cfi_escape 0x2e, 0x00
	movq	%r14, %rdi
	movq	%rax, %rsi
	callq	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
.Ltmp82:
# %bb.89:
	.cfi_escape 0x2e, 0x00
	movl	$16, %edi
	callq	__cxa_allocate_exception
	movq	%rax, %r14
.Ltmp84:
	.cfi_escape 0x2e, 0x00
	leaq	8(%rsp), %rdi
	leaq	272(%rsp), %rsi
	callq	_ZNKSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEE3strEv
.Ltmp85:
# %bb.90:
	movb	$1, %bpl
.Ltmp87:
	.cfi_escape 0x2e, 0x00
	leaq	8(%rsp), %rsi
	movq	%r14, %rdi
	callq	_ZNSt13runtime_errorC1ERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
.Ltmp88:
# %bb.91:
	xorl	%ebp, %ebp
.Ltmp89:
	.cfi_escape 0x2e, 0x00
	movl	$_ZTISt13runtime_error, %esi
	movl	$_ZNSt13runtime_errorD1Ev, %edx
	movq	%r14, %rdi
	callq	__cxa_throw
.Ltmp90:
	jmp	.LBB3_122
.LBB3_92:
	movl	%eax, %ebx
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %r14
	movq	%r14, %rdi
	callq	_ZNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEEC1Ev
.Ltmp92:
	.cfi_escape 0x2e, 0x00
	movl	$.L.str.1, %esi
	movl	$21, %edx
	movq	%r14, %rdi
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp93:
# %bb.93:                               # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit237
.Ltmp94:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	movl	$.L.str.2, %esi
	movl	$16, %edx
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp95:
# %bb.94:                               # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit238
.Ltmp96:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	movl	$.L.str.3, %esi
	movl	$1, %edx
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp97:
# %bb.95:                               # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit239
.Ltmp98:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	movl	$81, %esi
	callq	_ZNSolsEi
.Ltmp99:
# %bb.96:
.Ltmp100:
	movq	%rax, %r14
	.cfi_escape 0x2e, 0x00
	movl	$.L.str.4, %esi
	movl	$2, %edx
	movq	%rax, %rdi
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp101:
# %bb.97:                               # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit240
.Ltmp102:
	.cfi_escape 0x2e, 0x00
	movl	%ebx, %edi
	callq	hipGetErrorString
.Ltmp103:
# %bb.98:
.Ltmp104:
	.cfi_escape 0x2e, 0x00
	movq	%r14, %rdi
	movq	%rax, %rsi
	callq	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
.Ltmp105:
# %bb.99:
	.cfi_escape 0x2e, 0x00
	movl	$16, %edi
	callq	__cxa_allocate_exception
	movq	%rax, %r14
.Ltmp107:
	.cfi_escape 0x2e, 0x00
	leaq	8(%rsp), %rdi
	leaq	272(%rsp), %rsi
	callq	_ZNKSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEE3strEv
.Ltmp108:
# %bb.100:
	movb	$1, %bpl
.Ltmp110:
	.cfi_escape 0x2e, 0x00
	leaq	8(%rsp), %rsi
	movq	%r14, %rdi
	callq	_ZNSt13runtime_errorC1ERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
.Ltmp111:
# %bb.101:
	xorl	%ebp, %ebp
.Ltmp112:
	.cfi_escape 0x2e, 0x00
	movl	$_ZTISt13runtime_error, %esi
	movl	$_ZNSt13runtime_errorD1Ev, %edx
	movq	%r14, %rdi
	callq	__cxa_throw
.Ltmp113:
	jmp	.LBB3_122
.LBB3_102:
	movl	%eax, %ebx
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %r14
	movq	%r14, %rdi
	callq	_ZNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEEC1Ev
.Ltmp115:
	.cfi_escape 0x2e, 0x00
	movl	$.L.str.1, %esi
	movl	$21, %edx
	movq	%r14, %rdi
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp116:
# %bb.103:                              # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit244
.Ltmp117:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	movl	$.L.str.2, %esi
	movl	$16, %edx
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp118:
# %bb.104:                              # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit245
.Ltmp119:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	movl	$.L.str.3, %esi
	movl	$1, %edx
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp120:
# %bb.105:                              # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit246
.Ltmp121:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	movl	$82, %esi
	callq	_ZNSolsEi
.Ltmp122:
# %bb.106:
.Ltmp123:
	movq	%rax, %r14
	.cfi_escape 0x2e, 0x00
	movl	$.L.str.4, %esi
	movl	$2, %edx
	movq	%rax, %rdi
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp124:
# %bb.107:                              # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit247
.Ltmp125:
	.cfi_escape 0x2e, 0x00
	movl	%ebx, %edi
	callq	hipGetErrorString
.Ltmp126:
# %bb.108:
.Ltmp127:
	.cfi_escape 0x2e, 0x00
	movq	%r14, %rdi
	movq	%rax, %rsi
	callq	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
.Ltmp128:
# %bb.109:
	.cfi_escape 0x2e, 0x00
	movl	$16, %edi
	callq	__cxa_allocate_exception
	movq	%rax, %r14
.Ltmp130:
	.cfi_escape 0x2e, 0x00
	leaq	8(%rsp), %rdi
	leaq	272(%rsp), %rsi
	callq	_ZNKSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEE3strEv
.Ltmp131:
# %bb.110:
	movb	$1, %bpl
.Ltmp133:
	.cfi_escape 0x2e, 0x00
	leaq	8(%rsp), %rsi
	movq	%r14, %rdi
	callq	_ZNSt13runtime_errorC1ERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
.Ltmp134:
# %bb.111:
	xorl	%ebp, %ebp
.Ltmp135:
	.cfi_escape 0x2e, 0x00
	movl	$_ZTISt13runtime_error, %esi
	movl	$_ZNSt13runtime_errorD1Ev, %edx
	movq	%r14, %rdi
	callq	__cxa_throw
.Ltmp136:
	jmp	.LBB3_122
.LBB3_112:
	movl	%eax, %ebx
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %r14
	movq	%r14, %rdi
	callq	_ZNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEEC1Ev
.Ltmp184:
	.cfi_escape 0x2e, 0x00
	movl	$.L.str.1, %esi
	movl	$21, %edx
	movq	%r14, %rdi
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp185:
# %bb.113:                              # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit271
.Ltmp186:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	movl	$.L.str.2, %esi
	movl	$16, %edx
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp187:
# %bb.114:                              # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit272
.Ltmp188:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	movl	$.L.str.3, %esi
	movl	$1, %edx
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp189:
# %bb.115:                              # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit273
.Ltmp190:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	movl	$126, %esi
	callq	_ZNSolsEi
.Ltmp191:
# %bb.116:
.Ltmp192:
	movq	%rax, %r14
	.cfi_escape 0x2e, 0x00
	movl	$.L.str.4, %esi
	movl	$2, %edx
	movq	%rax, %rdi
	callq	_ZSt16__ostream_insertIcSt11char_traitsIcEERSt13basic_ostreamIT_T0_ES6_PKS3_l
.Ltmp193:
# %bb.117:                              # %_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc.exit274
.Ltmp194:
	.cfi_escape 0x2e, 0x00
	movl	%ebx, %edi
	callq	hipGetErrorString
.Ltmp195:
# %bb.118:
.Ltmp196:
	.cfi_escape 0x2e, 0x00
	movq	%r14, %rdi
	movq	%rax, %rsi
	callq	_ZStlsISt11char_traitsIcEERSt13basic_ostreamIcT_ES5_PKc
.Ltmp197:
# %bb.119:
	.cfi_escape 0x2e, 0x00
	movl	$16, %edi
	callq	__cxa_allocate_exception
	movq	%rax, %r14
.Ltmp199:
	.cfi_escape 0x2e, 0x00
	leaq	8(%rsp), %rdi
	leaq	272(%rsp), %rsi
	callq	_ZNKSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEE3strEv
.Ltmp200:
# %bb.120:
	movb	$1, %bpl
.Ltmp202:
	.cfi_escape 0x2e, 0x00
	leaq	8(%rsp), %rsi
	movq	%r14, %rdi
	callq	_ZNSt13runtime_errorC1ERKNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEEE
.Ltmp203:
# %bb.121:
	xorl	%ebp, %ebp
.Ltmp204:
	.cfi_escape 0x2e, 0x00
	movl	$_ZTISt13runtime_error, %esi
	movl	$_ZNSt13runtime_errorD1Ev, %edx
	movq	%r14, %rdi
	callq	__cxa_throw
.Ltmp205:
.LBB3_122:
.LBB3_123:
.Ltmp206:
	movq	%rax, %rbx
	movq	8(%rsp), %rdi
	leaq	24(%rsp), %rax
	cmpq	%rax, %rdi
	je	.LBB3_125
# %bb.124:                              # %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit277
	movq	24(%rsp), %rsi
	incq	%rsi
	.cfi_escape 0x2e, 0x00
	callq	_ZdlPvm
.LBB3_125:                              # %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit277
	testb	%bpl, %bpl
	jne	.LBB3_127
	jmp	.LBB3_128
.LBB3_126:                              # %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit277.thread
.Ltmp201:
	movq	%rax, %rbx
.LBB3_127:
	.cfi_escape 0x2e, 0x00
	movq	%r14, %rdi
	callq	__cxa_free_exception
.LBB3_128:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	callq	_ZNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEED1Ev
	.cfi_escape 0x2e, 0x00
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.LBB3_129:
.Ltmp137:
	movq	%rax, %rbx
	movq	8(%rsp), %rdi
	leaq	24(%rsp), %rax
	cmpq	%rax, %rdi
	je	.LBB3_131
# %bb.130:                              # %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit250
	movq	24(%rsp), %rsi
	incq	%rsi
	.cfi_escape 0x2e, 0x00
	callq	_ZdlPvm
.LBB3_131:                              # %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit250
	testb	%bpl, %bpl
	jne	.LBB3_133
	jmp	.LBB3_134
.LBB3_132:                              # %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit250.thread
.Ltmp132:
	movq	%rax, %rbx
.LBB3_133:
	.cfi_escape 0x2e, 0x00
	movq	%r14, %rdi
	callq	__cxa_free_exception
.LBB3_134:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	callq	_ZNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEED1Ev
	.cfi_escape 0x2e, 0x00
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.LBB3_135:
.Ltmp114:
	movq	%rax, %rbx
	movq	8(%rsp), %rdi
	leaq	24(%rsp), %rax
	cmpq	%rax, %rdi
	je	.LBB3_137
# %bb.136:                              # %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit243
	movq	24(%rsp), %rsi
	incq	%rsi
	.cfi_escape 0x2e, 0x00
	callq	_ZdlPvm
.LBB3_137:                              # %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit243
	testb	%bpl, %bpl
	jne	.LBB3_139
	jmp	.LBB3_140
.LBB3_138:                              # %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit243.thread
.Ltmp109:
	movq	%rax, %rbx
.LBB3_139:
	.cfi_escape 0x2e, 0x00
	movq	%r14, %rdi
	callq	__cxa_free_exception
.LBB3_140:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	callq	_ZNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEED1Ev
	.cfi_escape 0x2e, 0x00
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.LBB3_141:
.Ltmp91:
	movq	%rax, %rbx
	movq	8(%rsp), %rdi
	leaq	24(%rsp), %rax
	cmpq	%rax, %rdi
	je	.LBB3_143
# %bb.142:                              # %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit236
	movq	24(%rsp), %rsi
	incq	%rsi
	.cfi_escape 0x2e, 0x00
	callq	_ZdlPvm
.LBB3_143:                              # %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit236
	testb	%bpl, %bpl
	jne	.LBB3_145
	jmp	.LBB3_146
.LBB3_144:                              # %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit236.thread
.Ltmp86:
	movq	%rax, %rbx
.LBB3_145:
	.cfi_escape 0x2e, 0x00
	movq	%r14, %rdi
	callq	__cxa_free_exception
.LBB3_146:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	callq	_ZNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEED1Ev
	.cfi_escape 0x2e, 0x00
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.LBB3_147:
.Ltmp68:
	movq	%rax, %rbx
	movq	8(%rsp), %rdi
	leaq	24(%rsp), %rax
	cmpq	%rax, %rdi
	je	.LBB3_149
# %bb.148:                              # %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit229
	movq	24(%rsp), %rsi
	incq	%rsi
	.cfi_escape 0x2e, 0x00
	callq	_ZdlPvm
.LBB3_149:                              # %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit229
	testb	%bpl, %bpl
	jne	.LBB3_151
	jmp	.LBB3_152
.LBB3_150:                              # %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit229.thread
.Ltmp63:
	movq	%rax, %rbx
.LBB3_151:
	.cfi_escape 0x2e, 0x00
	movq	%r14, %rdi
	callq	__cxa_free_exception
.LBB3_152:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	callq	_ZNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEED1Ev
	.cfi_escape 0x2e, 0x00
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.LBB3_153:
.Ltmp45:
	movq	%rax, %rbx
	movq	8(%rsp), %rdi
	leaq	24(%rsp), %rax
	cmpq	%rax, %rdi
	je	.LBB3_155
# %bb.154:                              # %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit222
	movq	24(%rsp), %rsi
	incq	%rsi
	.cfi_escape 0x2e, 0x00
	callq	_ZdlPvm
.LBB3_155:                              # %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit222
	testb	%bpl, %bpl
	jne	.LBB3_157
	jmp	.LBB3_158
.LBB3_156:                              # %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit222.thread
.Ltmp40:
	movq	%rax, %rbx
.LBB3_157:
	.cfi_escape 0x2e, 0x00
	movq	%r14, %rdi
	callq	__cxa_free_exception
.LBB3_158:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	callq	_ZNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEED1Ev
	.cfi_escape 0x2e, 0x00
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.LBB3_159:
.Ltmp22:
	movq	%rax, %rbx
	movq	8(%rsp), %rdi
	leaq	24(%rsp), %rax
	cmpq	%rax, %rdi
	je	.LBB3_161
# %bb.160:                              # %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit
	movq	24(%rsp), %rsi
	incq	%rsi
	.cfi_escape 0x2e, 0x00
	callq	_ZdlPvm
.LBB3_161:                              # %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit
	testb	%bpl, %bpl
	jne	.LBB3_163
	jmp	.LBB3_184
.LBB3_162:                              # %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit.thread
.Ltmp17:
	movq	%rax, %rbx
.LBB3_163:
	.cfi_escape 0x2e, 0x00
	movq	%r14, %rdi
	callq	__cxa_free_exception
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	callq	_ZNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEED1Ev
	.cfi_escape 0x2e, 0x00
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.LBB3_164:
.Ltmp183:
	movq	%rax, %rbx
	movq	8(%rsp), %rdi
	leaq	24(%rsp), %rax
	cmpq	%rax, %rdi
	je	.LBB3_166
# %bb.165:                              # %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit264
	movq	24(%rsp), %rsi
	incq	%rsi
	.cfi_escape 0x2e, 0x00
	callq	_ZdlPvm
.LBB3_166:                              # %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit264
	testb	%bpl, %bpl
	jne	.LBB3_168
	jmp	.LBB3_169
.LBB3_167:                              # %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit264.thread
.Ltmp178:
	movq	%rax, %rbx
.LBB3_168:
	.cfi_escape 0x2e, 0x00
	movq	%r14, %rdi
	callq	__cxa_free_exception
.LBB3_169:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	callq	_ZNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEED1Ev
	.cfi_escape 0x2e, 0x00
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.LBB3_170:
.Ltmp160:
	movq	%rax, %rbx
	movq	8(%rsp), %rdi
	leaq	24(%rsp), %rax
	cmpq	%rax, %rdi
	je	.LBB3_172
# %bb.171:                              # %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit257
	movq	24(%rsp), %rsi
	incq	%rsi
	.cfi_escape 0x2e, 0x00
	callq	_ZdlPvm
.LBB3_172:                              # %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit257
	testb	%bpl, %bpl
	jne	.LBB3_174
	jmp	.LBB3_175
.LBB3_173:                              # %_ZNSt7__cxx1112basic_stringIcSt11char_traitsIcESaIcEED2Ev.exit257.thread
.Ltmp155:
	movq	%rax, %rbx
.LBB3_174:
	.cfi_escape 0x2e, 0x00
	movq	%r14, %rdi
	callq	__cxa_free_exception
.LBB3_175:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	callq	_ZNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEED1Ev
	.cfi_escape 0x2e, 0x00
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.LBB3_176:
.Ltmp198:
	jmp	.LBB3_182
.LBB3_177:
.Ltmp129:
	jmp	.LBB3_182
.LBB3_178:
.Ltmp106:
	jmp	.LBB3_182
.LBB3_179:
.Ltmp83:
	jmp	.LBB3_182
.LBB3_180:
.Ltmp60:
	jmp	.LBB3_182
.LBB3_181:
.Ltmp37:
	jmp	.LBB3_182
.LBB3_183:
.Ltmp14:
	movq	%rax, %rbx
.LBB3_184:
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	callq	_ZNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEED1Ev
	.cfi_escape 0x2e, 0x00
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.LBB3_185:
.Ltmp175:
	jmp	.LBB3_182
.LBB3_186:
.Ltmp152:
.LBB3_182:
	movq	%rax, %rbx
	.cfi_escape 0x2e, 0x00
	leaq	272(%rsp), %rdi
	callq	_ZNSt7__cxx1119basic_ostringstreamIcSt11char_traitsIcESaIcEED1Ev
	.cfi_escape 0x2e, 0x00
	movq	%rbx, %rdi
	callq	_Unwind_Resume@PLT
.Lfunc_end3:
	.size	main, .Lfunc_end3-main
	.cfi_endproc
	.section	.gcc_except_table,"a",@progbits
	.p2align	2, 0x0
GCC_except_table3:
.Lexception0:
	.byte	255                             # @LPStart Encoding = omit
	.byte	255                             # @TType Encoding = omit
	.byte	1                               # Call site Encoding = uleb128
	.uleb128 .Lcst_end0-.Lcst_begin0
.Lcst_begin0:
	.uleb128 .Lfunc_begin0-.Lfunc_begin0    # >> Call Site 1 <<
	.uleb128 .Ltmp138-.Lfunc_begin0         #   Call between .Lfunc_begin0 and .Ltmp138
	.byte	0                               #     has no landing pad
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp138-.Lfunc_begin0         # >> Call Site 2 <<
	.uleb128 .Ltmp151-.Ltmp138              #   Call between .Ltmp138 and .Ltmp151
	.uleb128 .Ltmp152-.Lfunc_begin0         #     jumps to .Ltmp152
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp151-.Lfunc_begin0         # >> Call Site 3 <<
	.uleb128 .Ltmp153-.Ltmp151              #   Call between .Ltmp151 and .Ltmp153
	.byte	0                               #     has no landing pad
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp153-.Lfunc_begin0         # >> Call Site 4 <<
	.uleb128 .Ltmp154-.Ltmp153              #   Call between .Ltmp153 and .Ltmp154
	.uleb128 .Ltmp155-.Lfunc_begin0         #     jumps to .Ltmp155
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp156-.Lfunc_begin0         # >> Call Site 5 <<
	.uleb128 .Ltmp159-.Ltmp156              #   Call between .Ltmp156 and .Ltmp159
	.uleb128 .Ltmp160-.Lfunc_begin0         #     jumps to .Ltmp160
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp159-.Lfunc_begin0         # >> Call Site 6 <<
	.uleb128 .Ltmp161-.Ltmp159              #   Call between .Ltmp159 and .Ltmp161
	.byte	0                               #     has no landing pad
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp161-.Lfunc_begin0         # >> Call Site 7 <<
	.uleb128 .Ltmp174-.Ltmp161              #   Call between .Ltmp161 and .Ltmp174
	.uleb128 .Ltmp175-.Lfunc_begin0         #     jumps to .Ltmp175
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp174-.Lfunc_begin0         # >> Call Site 8 <<
	.uleb128 .Ltmp176-.Ltmp174              #   Call between .Ltmp174 and .Ltmp176
	.byte	0                               #     has no landing pad
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp176-.Lfunc_begin0         # >> Call Site 9 <<
	.uleb128 .Ltmp177-.Ltmp176              #   Call between .Ltmp176 and .Ltmp177
	.uleb128 .Ltmp178-.Lfunc_begin0         #     jumps to .Ltmp178
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp179-.Lfunc_begin0         # >> Call Site 10 <<
	.uleb128 .Ltmp182-.Ltmp179              #   Call between .Ltmp179 and .Ltmp182
	.uleb128 .Ltmp183-.Lfunc_begin0         #     jumps to .Ltmp183
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp182-.Lfunc_begin0         # >> Call Site 11 <<
	.uleb128 .Ltmp0-.Ltmp182                #   Call between .Ltmp182 and .Ltmp0
	.byte	0                               #     has no landing pad
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp0-.Lfunc_begin0           # >> Call Site 12 <<
	.uleb128 .Ltmp13-.Ltmp0                 #   Call between .Ltmp0 and .Ltmp13
	.uleb128 .Ltmp14-.Lfunc_begin0          #     jumps to .Ltmp14
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp13-.Lfunc_begin0          # >> Call Site 13 <<
	.uleb128 .Ltmp15-.Ltmp13                #   Call between .Ltmp13 and .Ltmp15
	.byte	0                               #     has no landing pad
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp15-.Lfunc_begin0          # >> Call Site 14 <<
	.uleb128 .Ltmp16-.Ltmp15                #   Call between .Ltmp15 and .Ltmp16
	.uleb128 .Ltmp17-.Lfunc_begin0          #     jumps to .Ltmp17
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp18-.Lfunc_begin0          # >> Call Site 15 <<
	.uleb128 .Ltmp21-.Ltmp18                #   Call between .Ltmp18 and .Ltmp21
	.uleb128 .Ltmp22-.Lfunc_begin0          #     jumps to .Ltmp22
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp21-.Lfunc_begin0          # >> Call Site 16 <<
	.uleb128 .Ltmp23-.Ltmp21                #   Call between .Ltmp21 and .Ltmp23
	.byte	0                               #     has no landing pad
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp23-.Lfunc_begin0          # >> Call Site 17 <<
	.uleb128 .Ltmp36-.Ltmp23                #   Call between .Ltmp23 and .Ltmp36
	.uleb128 .Ltmp37-.Lfunc_begin0          #     jumps to .Ltmp37
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp36-.Lfunc_begin0          # >> Call Site 18 <<
	.uleb128 .Ltmp38-.Ltmp36                #   Call between .Ltmp36 and .Ltmp38
	.byte	0                               #     has no landing pad
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp38-.Lfunc_begin0          # >> Call Site 19 <<
	.uleb128 .Ltmp39-.Ltmp38                #   Call between .Ltmp38 and .Ltmp39
	.uleb128 .Ltmp40-.Lfunc_begin0          #     jumps to .Ltmp40
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp41-.Lfunc_begin0          # >> Call Site 20 <<
	.uleb128 .Ltmp44-.Ltmp41                #   Call between .Ltmp41 and .Ltmp44
	.uleb128 .Ltmp45-.Lfunc_begin0          #     jumps to .Ltmp45
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp44-.Lfunc_begin0          # >> Call Site 21 <<
	.uleb128 .Ltmp46-.Ltmp44                #   Call between .Ltmp44 and .Ltmp46
	.byte	0                               #     has no landing pad
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp46-.Lfunc_begin0          # >> Call Site 22 <<
	.uleb128 .Ltmp59-.Ltmp46                #   Call between .Ltmp46 and .Ltmp59
	.uleb128 .Ltmp60-.Lfunc_begin0          #     jumps to .Ltmp60
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp59-.Lfunc_begin0          # >> Call Site 23 <<
	.uleb128 .Ltmp61-.Ltmp59                #   Call between .Ltmp59 and .Ltmp61
	.byte	0                               #     has no landing pad
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp61-.Lfunc_begin0          # >> Call Site 24 <<
	.uleb128 .Ltmp62-.Ltmp61                #   Call between .Ltmp61 and .Ltmp62
	.uleb128 .Ltmp63-.Lfunc_begin0          #     jumps to .Ltmp63
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp64-.Lfunc_begin0          # >> Call Site 25 <<
	.uleb128 .Ltmp67-.Ltmp64                #   Call between .Ltmp64 and .Ltmp67
	.uleb128 .Ltmp68-.Lfunc_begin0          #     jumps to .Ltmp68
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp67-.Lfunc_begin0          # >> Call Site 26 <<
	.uleb128 .Ltmp69-.Ltmp67                #   Call between .Ltmp67 and .Ltmp69
	.byte	0                               #     has no landing pad
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp69-.Lfunc_begin0          # >> Call Site 27 <<
	.uleb128 .Ltmp82-.Ltmp69                #   Call between .Ltmp69 and .Ltmp82
	.uleb128 .Ltmp83-.Lfunc_begin0          #     jumps to .Ltmp83
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp82-.Lfunc_begin0          # >> Call Site 28 <<
	.uleb128 .Ltmp84-.Ltmp82                #   Call between .Ltmp82 and .Ltmp84
	.byte	0                               #     has no landing pad
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp84-.Lfunc_begin0          # >> Call Site 29 <<
	.uleb128 .Ltmp85-.Ltmp84                #   Call between .Ltmp84 and .Ltmp85
	.uleb128 .Ltmp86-.Lfunc_begin0          #     jumps to .Ltmp86
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp87-.Lfunc_begin0          # >> Call Site 30 <<
	.uleb128 .Ltmp90-.Ltmp87                #   Call between .Ltmp87 and .Ltmp90
	.uleb128 .Ltmp91-.Lfunc_begin0          #     jumps to .Ltmp91
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp90-.Lfunc_begin0          # >> Call Site 31 <<
	.uleb128 .Ltmp92-.Ltmp90                #   Call between .Ltmp90 and .Ltmp92
	.byte	0                               #     has no landing pad
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp92-.Lfunc_begin0          # >> Call Site 32 <<
	.uleb128 .Ltmp105-.Ltmp92               #   Call between .Ltmp92 and .Ltmp105
	.uleb128 .Ltmp106-.Lfunc_begin0         #     jumps to .Ltmp106
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp105-.Lfunc_begin0         # >> Call Site 33 <<
	.uleb128 .Ltmp107-.Ltmp105              #   Call between .Ltmp105 and .Ltmp107
	.byte	0                               #     has no landing pad
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp107-.Lfunc_begin0         # >> Call Site 34 <<
	.uleb128 .Ltmp108-.Ltmp107              #   Call between .Ltmp107 and .Ltmp108
	.uleb128 .Ltmp109-.Lfunc_begin0         #     jumps to .Ltmp109
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp110-.Lfunc_begin0         # >> Call Site 35 <<
	.uleb128 .Ltmp113-.Ltmp110              #   Call between .Ltmp110 and .Ltmp113
	.uleb128 .Ltmp114-.Lfunc_begin0         #     jumps to .Ltmp114
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp113-.Lfunc_begin0         # >> Call Site 36 <<
	.uleb128 .Ltmp115-.Ltmp113              #   Call between .Ltmp113 and .Ltmp115
	.byte	0                               #     has no landing pad
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp115-.Lfunc_begin0         # >> Call Site 37 <<
	.uleb128 .Ltmp128-.Ltmp115              #   Call between .Ltmp115 and .Ltmp128
	.uleb128 .Ltmp129-.Lfunc_begin0         #     jumps to .Ltmp129
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp128-.Lfunc_begin0         # >> Call Site 38 <<
	.uleb128 .Ltmp130-.Ltmp128              #   Call between .Ltmp128 and .Ltmp130
	.byte	0                               #     has no landing pad
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp130-.Lfunc_begin0         # >> Call Site 39 <<
	.uleb128 .Ltmp131-.Ltmp130              #   Call between .Ltmp130 and .Ltmp131
	.uleb128 .Ltmp132-.Lfunc_begin0         #     jumps to .Ltmp132
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp133-.Lfunc_begin0         # >> Call Site 40 <<
	.uleb128 .Ltmp136-.Ltmp133              #   Call between .Ltmp133 and .Ltmp136
	.uleb128 .Ltmp137-.Lfunc_begin0         #     jumps to .Ltmp137
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp136-.Lfunc_begin0         # >> Call Site 41 <<
	.uleb128 .Ltmp184-.Ltmp136              #   Call between .Ltmp136 and .Ltmp184
	.byte	0                               #     has no landing pad
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp184-.Lfunc_begin0         # >> Call Site 42 <<
	.uleb128 .Ltmp197-.Ltmp184              #   Call between .Ltmp184 and .Ltmp197
	.uleb128 .Ltmp198-.Lfunc_begin0         #     jumps to .Ltmp198
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp197-.Lfunc_begin0         # >> Call Site 43 <<
	.uleb128 .Ltmp199-.Ltmp197              #   Call between .Ltmp197 and .Ltmp199
	.byte	0                               #     has no landing pad
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp199-.Lfunc_begin0         # >> Call Site 44 <<
	.uleb128 .Ltmp200-.Ltmp199              #   Call between .Ltmp199 and .Ltmp200
	.uleb128 .Ltmp201-.Lfunc_begin0         #     jumps to .Ltmp201
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp202-.Lfunc_begin0         # >> Call Site 45 <<
	.uleb128 .Ltmp205-.Ltmp202              #   Call between .Ltmp202 and .Ltmp205
	.uleb128 .Ltmp206-.Lfunc_begin0         #     jumps to .Ltmp206
	.byte	0                               #   On action: cleanup
	.uleb128 .Ltmp205-.Lfunc_begin0         # >> Call Site 46 <<
	.uleb128 .Lfunc_end3-.Ltmp205           #   Call between .Ltmp205 and .Lfunc_end3
	.byte	0                               #     has no landing pad
	.byte	0                               #   On action: cleanup
.Lcst_end0:
	.p2align	2, 0x0
                                        # -- End function
	.section	.text._Z64__device_stub__batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i,"axG",@progbits,_Z64__device_stub__batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i,comdat
	.weak	_Z64__device_stub__batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i # -- Begin function _Z64__device_stub__batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i
	.p2align	4
	.type	_Z64__device_stub__batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i,@function
_Z64__device_stub__batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i: # @_Z64__device_stub__batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i
	.cfi_startproc
# %bb.0:
	subq	$168, %rsp
	.cfi_def_cfa_offset 176
	movl	%edi, 12(%rsp)
	movl	%esi, 8(%rsp)
	movl	%edx, 4(%rsp)
	movl	%ecx, (%rsp)
	movq	%r8, 72(%rsp)
	movq	%r9, 64(%rsp)
	leaq	12(%rsp), %rax
	movq	%rax, 80(%rsp)
	leaq	8(%rsp), %rax
	movq	%rax, 88(%rsp)
	leaq	4(%rsp), %rax
	movq	%rax, 96(%rsp)
	movq	%rsp, %rax
	movq	%rax, 104(%rsp)
	leaq	72(%rsp), %rax
	movq	%rax, 112(%rsp)
	leaq	64(%rsp), %rax
	movq	%rax, 120(%rsp)
	leaq	176(%rsp), %rax
	movq	%rax, 128(%rsp)
	leaq	184(%rsp), %rax
	movq	%rax, 136(%rsp)
	leaq	200(%rsp), %rax
	movq	%rax, 144(%rsp)
	leaq	216(%rsp), %rax
	movq	%rax, 152(%rsp)
	leaq	232(%rsp), %rax
	movq	%rax, 160(%rsp)
	leaq	48(%rsp), %rdi
	leaq	32(%rsp), %rsi
	leaq	24(%rsp), %rdx
	leaq	16(%rsp), %rcx
	callq	__hipPopCallConfiguration
	movq	48(%rsp), %rsi
	movl	56(%rsp), %edx
	movq	32(%rsp), %rcx
	movl	40(%rsp), %r8d
	leaq	80(%rsp), %r9
	movl	$_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i, %edi
	pushq	16(%rsp)
	.cfi_adjust_cfa_offset 8
	pushq	32(%rsp)
	.cfi_adjust_cfa_offset 8
	callq	hipLaunchKernel
	addq	$184, %rsp
	.cfi_adjust_cfa_offset -184
	retq
.Lfunc_end4:
	.size	_Z64__device_stub__batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i, .Lfunc_end4-_Z64__device_stub__batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i
	.cfi_endproc
                                        # -- End function
	.text
	.p2align	4                               # -- Begin function __hip_module_ctor
	.type	__hip_module_ctor,@function
__hip_module_ctor:                      # @__hip_module_ctor
	.cfi_startproc
# %bb.0:
	pushq	%rbx
	.cfi_def_cfa_offset 16
	subq	$32, %rsp
	.cfi_def_cfa_offset 48
	.cfi_offset %rbx, -16
	movq	__hip_gpubin_handle_f59befd3832c6d3e(%rip), %rbx
	testq	%rbx, %rbx
	jne	.LBB5_2
# %bb.1:
	movl	$__hip_fatbin_wrapper, %edi
	callq	__hipRegisterFatBinary
	movq	%rax, %rbx
	movq	%rax, __hip_gpubin_handle_f59befd3832c6d3e(%rip)
.LBB5_2:
	xorps	%xmm0, %xmm0
	movups	%xmm0, 16(%rsp)
	movups	%xmm0, (%rsp)
	movl	$_Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b, %esi
	movl	$.L__unnamed_1, %edx
	movl	$.L__unnamed_1, %ecx
	movq	%rbx, %rdi
	movl	$-1, %r8d
	xorl	%r9d, %r9d
	callq	__hipRegisterFunction
	xorps	%xmm0, %xmm0
	movups	%xmm0, 16(%rsp)
	movups	%xmm0, (%rsp)
	movl	$_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i, %esi
	movl	$.L__unnamed_2, %edx
	movl	$.L__unnamed_2, %ecx
	movq	%rbx, %rdi
	movl	$-1, %r8d
	xorl	%r9d, %r9d
	callq	__hipRegisterFunction
	movl	$__hip_module_dtor, %edi
	addq	$32, %rsp
	.cfi_def_cfa_offset 16
	popq	%rbx
	.cfi_def_cfa_offset 8
	jmp	atexit                          # TAILCALL
.Lfunc_end5:
	.size	__hip_module_ctor, .Lfunc_end5-__hip_module_ctor
	.cfi_endproc
                                        # -- End function
	.p2align	4                               # -- Begin function __hip_module_dtor
	.type	__hip_module_dtor,@function
__hip_module_dtor:                      # @__hip_module_dtor
	.cfi_startproc
# %bb.0:
	movq	__hip_gpubin_handle_f59befd3832c6d3e(%rip), %rdi
	testq	%rdi, %rdi
	je	.LBB6_2
# %bb.1:
	pushq	%rax
	.cfi_def_cfa_offset 16
	callq	__hipUnregisterFatBinary
	movq	$0, __hip_gpubin_handle_f59befd3832c6d3e(%rip)
	addq	$8, %rsp
	.cfi_def_cfa_offset 8
.LBB6_2:
	retq
.Lfunc_end6:
	.size	__hip_module_dtor, .Lfunc_end6-__hip_module_dtor
	.cfi_endproc
                                        # -- End function
	.type	_Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b,@object # @_Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b
	.section	.rodata,"a",@progbits
	.globl	_Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b
	.p2align	3, 0x0
_Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b:
	.quad	_Z50__device_stub__batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b
	.size	_Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b, 8

	.type	.L.str.1,@object                # @.str.1
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.1:
	.asciz	"HIP Function Failed ("
	.size	.L.str.1, 22

	.type	.L.str.2,@object                # @.str.2
.L.str.2:
	.asciz	"batched_gemm.cpp"
	.size	.L.str.2, 17

	.type	.L.str.3,@object                # @.str.3
.L.str.3:
	.asciz	","
	.size	.L.str.3, 2

	.type	.L.str.4,@object                # @.str.4
.L.str.4:
	.asciz	") "
	.size	.L.str.4, 3

	.type	_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i,@object # @_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i
	.section	.rodata._Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i,"aG",@progbits,_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i,comdat
	.weak	_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i
	.p2align	3, 0x0
_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i:
	.quad	_Z64__device_stub__batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i
	.size	_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i, 8

	.type	.L.str.5,@object                # @.str.5
	.section	.rodata.str1.1,"aMS",@progbits,1
.L.str.5:
	.asciz	"ELAPSED TIME: %.3f\n"
	.size	.L.str.5, 20

	.type	.L.str.6,@object                # @.str.6
.L.str.6:
	.asciz	"M: %d, N: %d, K: %d, Batch: %d, TFlops: %.3f\n"
	.size	.L.str.6, 46

	.type	.L.str.7,@object                # @.str.7
.L.str.7:
	.asciz	"%f, %f mismatch\n"
	.size	.L.str.7, 17

	.type	.L__unnamed_1,@object           # @0
.L__unnamed_1:
	.asciz	"_Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b"
	.size	.L__unnamed_1, 60

	.type	.L__unnamed_2,@object           # @1
.L__unnamed_2:
	.asciz	"_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i"
	.size	.L__unnamed_2, 103

	.type	.L__unnamed_3,@object           # @2
	.section	.hip_fatbin,"a",@progbits
	.p2align	12, 0x0
.L__unnamed_3:
	.asciz	"__CLANG_OFFLOAD_BUNDLE__\002\000\000\000\000\000\000\000\000\020\000\000\000\000\000\000\000\000\000\000\000\000\000\000\036\000\000\000\000\000\000\000host-x86_64-unknown-linux-gnu-\000\020\000\000\000\000\000\000\330.\000\000\000\000\000\000\037\000\000\000\000\000\000\000hipv4-amdgcn-amd-amdhsa--gfx942\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\177ELF\002\001\001@\004\000\000\000\000\000\000\000\003\000\340\000\001\000\000\000\000\000\000\000\000\000\000\000@\000\000\000\000\000\000\000\230*\000\000\000\000\000\000L\005\000\000@\0008\000\t\000@\000\021\000\017\000\006\000\000\000\004\000\000\000@\000\000\000\000\000\000\000@\000\000\000\000\000\000\000@\000\000\000\000\000\000\000\370\001\000\000\000\000\000\000\370\001\000\000\000\000\000\000\b\000\000\000\000\000\000\000\001\000\000\000\004\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\200\017\000\000\000\000\000\000\200\017\000\000\000\000\000\000\000\020\000\000\000\000\000\000\001\000\000\000\005\000\000\000\000\020\000\000\000\000\000\000\000 \000\000\000\000\000\000\000 \000\000\000\000\000\000@\r\000\000\000\000\000\000@\r\000\000\000\000\000\000\000\020\000\000\000\000\000\000\001\000\000\000\006\000\000\000@\035\000\000\000\000\000\000@=\000\000\000\000\000\000@=\000\000\000\000\000\000p\000\000\000\000\000\000\000\300\002\000\000\000\000\000\000\000\020\000\000\000\000\000\000\001\000\000\000\006\000\000\000\260\035\000\000\000\000\000\000\260M\000\000\000\000\000\000\260M\000\000\000\000\000\000\000\000\000\000\000\000\000\000\001\000\000\000\000\000\000\000\000\020\000\000\000\000\000\000\002\000\000\000\006\000\000\000@\035\000\000\000\000\000\000@=\000\000\000\000\000\000@=\000\000\000\000\000\000p\000\000\000\000\000\000\000p\000\000\000\000\000\000\000\b\000\000\000\000\000\000\000R\345td\004\000\000\000@\035\000\000\000\000\000\000@=\000\000\000\000\000\000@=\000\000\000\000\000\000p\000\000\000\000\000\000\000\300\002\000\000\000\000\000\000\001\000\000\000\000\000\000\000Q\345td\006\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\004\000\000\000\004\000\000\0008\002\000\000\000\000\000\0008\002\000\000\000\000\000\0008\002\000\000\000\000\000\000(\n\000\000\000\000\000\000(\n\000\000\000\000\000\000\004\000\000\000\000\000\000\000\007\000\000\000\022\n\000\000 \000\000\000AMDGPU\000\000\203\256amdhsa.kernels\222\336\000\022\253.agpr_count\000\245.args\334\000\024\203\247.offset\000\245.size\004\253.value_kind\250by_value\203\247.offset\004\245.size\004\253.value_kind\250by_value\203\247.offset\b\245.size\004\253.value_kind\250by_value\203\247.offset\f\245.size\004\253.value_kind\250by_value\204\256.address_space\246global\247.offset\020\245.size\b\253.value_kind\255global_buffer\204\256.address_space\246global\247.offset\030\245.size\b\253.value_kind\255global_buffer\204\256.address_space\246global\247.offset \245.size\b\253.value_kind\255global_buffer\203\247.offset(\245.size\004\253.value_kind\264hidden_block_count_x\203\247.offset,\245.size\004\253.value_kind\264hidden_block_count_y\203\247.offset0\245.size\004\253.value_kind\264hidden_block_count_z\203\247.offset4\245.size\002\253.value_kind\263hidden_group_size_x\203\247.offset6\245.size\002\253.value_kind\263hidden_group_size_y\203\247.offset8\245.size\002\253.value_kind\263hidden_group_size_z\203\247.offset:\245.size\002\253.value_kind\262hidden_remainder_x\203\247.offset<\245.size\002\253.value_kind\262hidden_remainder_y\203\247.offset>\245.size\002\253.value_kind\262hidden_remainder_z\203\247.offsetP\245.size\b\253.value_kind\266hidden_global_offset_x\203\247.offsetX\245.size\b\253.value_kind\266hidden_global_offset_y\203\247.offset`\245.size\b\253.value_kind\266hidden_global_offset_z\203\247.offseth\245.size\002\253.value_kind\260hidden_grid_dims\271.group_segment_fixed_size\000\266.kernarg_segment_align\b\265.kernarg_segment_size\315\001(\251.language\250OpenCL C\261.language_version\222\002\000\270.max_flat_workgroup_size\315\004\000\245.name\331;_Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b\273.private_segment_fixed_size\000\253.sgpr_count\030\261.sgpr_spill_count\000\247.symbol\331>_Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b.kd\270.uniform_work_group_size\001\263.uses_dynamic_stack\302\253.vgpr_count\f\261.vgpr_spill_count\000\257.wavefront_size@\336\000\022\253.agpr_count\020\245.args\233\203\247.offset\000\245.size\004\253.value_kind\250by_value\203\247.offset\004\245.size\004\253.value_kind\250by_value\203\247.offset\b\245.size\004\253.value_kind\250by_value\203\247.offset\f\245.size\004\253.value_kind\250by_value\204\256.address_space\246global\247.offset\020\245.size\b\253.value_kind\255global_buffer\204\256.address_space\246global\247.offset\030\245.size\b\253.value_kind\255global_buffer\204\256.address_space\246global\247.offset \245.size\b\253.value_kind\255global_buffer\203\247.offset(\245.size\f\253.value_kind\250by_value\203\247.offset4\245.size\f\253.value_kind\250by_value\203\247.offset@\245.size\f\253.value_kind\250by_value\203\247.offsetL\245.size\004\253.value_kind\250by_value\271.group_segment_fixed_size\315\b\000\266.kernarg_segment_align\b\265.kernarg_segment_sizeP\251.language\250OpenCL C\261.language_version\222\002\000\270.max_flat_workgroup_size\315\001\000\245.name\331f_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i\273.private_segment_fixed_size\000\253.sgpr_count \261.sgpr_spill_count\000\247.symbol\331i_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i.kd\270.uniform_work_group_size\001\263.uses_dynamic_stack\302\253.vgpr_count0\261.vgpr_spill_count\000\257.wavefront_size@\255amdhsa.target\271amdgcn-amd-amdhsa--gfx942\256amdhsa.version\222\001\002\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\001\000\000\000\022\003\007\000\000 \000\000\000\000\000\000x\001\000\000\000\000\000\000=\000\000\000\021\003\006\000\000\017\000\000\000\000\000\000@\000\000\000\000\000\000\000|\000\000\000\022\003\007\000\000&\000\000\000\000\000\000@\007\000\000\000\000\000\000\343\000\000\000\021\003\006\000@\017\000\000\000\000\000\000@\000\000\000\000\000\000\000M\001\000\000\021\000\n\000\260M\000\000\000\000\000\000\001\000\000\000\000\000\000\000\001\000\000\000\001\000\000\000\001\000\000\000\032\000\000\000\000\000\201\000 \202\002\t\001\000\000\000:\343_B8/\232\226\372W\237\276\370k~^1\321^\247\006\000\000\000\006\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\003\000\000\000\004\000\000\000\005\000\000\000\000\000\000\000\000\000\000\000\001\000\000\000\000\000\000\000\002\000\000\000\000\000\000\000\000_Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b\000_Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b.kd\000_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i\000_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i.kd\000__hip_cuid_f59befd3832c6d3e\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000(\001\000\000\000\000\000\000\000\021\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\002\000\000\000\201\000\257\000\204\023\000\000\b\000\000\000\000\000\000\000\000\b\000\000\000\000\000\000P\000\000\000\000\000\000\000\300\026\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\007\000\000\000\305\000\257\000\204\003\000\000\b\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\004\006\3004\000\000\000\200\001\006\300 \000\000\000\000\002\016\300\000\000\000\000\001\000\310\321\000))\002\004\000\310\321\000\025)\002\177\300\214\277\021\377\000\206\377\377\000\000\004\000\004\222\020\377\005\206\377\377\000\000\004\002\002h\020\220\001\217\002\005\002\222\002\000\205\322\001\021\000\000\377\000\000&\377\003\000\000\003\001\003\222\n\201\004\277\005\000\377\321\002\000\n\0045\000\205\277\n\t\000\222\001\000\205\322\000\002\002\000\000\000\205\322\005\025\000\000\002\000\377\321\004\003\016\000\200\002\f~\377\177\000\260\237\004\006\"\237\000\002\"\n\000\b\322\002\0039\000\b\000\b\322\000\0031\000\000\200H\334\n\000\177\001\000\200H\334\b\000\177\003\n\301\n\201\201\000\000h\n\200\006\277\t\004\004hq\017\214\277\220\002\002$p\017\214\277\220\006\006$\003\003\002\n\003\000\310\321\001!\005\002\377\002\016(\000\000@\000\003\000\377\321\003\003\002\000\001\003\220|\001\000\200\277\003\017\002\000\377\002\002&\000\000\377\377\006\003\f\002\340\377\204\277\000\000\310\321\006!\005\002\377\177\000\260\000\000\377\321\000\r\002\000\377\f\002(\000\000@\000\006\r\220|\001\000\200\277\000\003\000\000\220\000\000 \001\000\202\277\200\002\000~\001\000\205\322\005\023\000\000\004\000\377\321\003\b\006\004\006\002\004~\007\002\006~\237\b\n\"\002\000\b\322\004\003\t\004\000\200h\334\002\000\177\000\000\000\201\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\200\277\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\200\001\006\300\004\000\000\000\000\003\n\300\020\000\000\000\000\004\006\300 \000\000\000\000\002\n\300@\000\000\000\237\000\004&\177\300\214\277\003\206\013\216\002\206\005\216\202\000\002 \203\000\006 \201\000\000 \240\002\002&\204\006\030&\000\000\001\322\000A\t\004\007\200\006\277\200\000\203\276\215\000\205\277\000\005\n\300(\000\000\000\200\004\006\3008\000\000\000\001\005\006(\201\030\b$\r\000\000\322\003\t\021\004\177\300\214\277\024\004\001\222\025\013\002\222\002\001\002\201\204\000\006$\000\004\001\260\027\004\000\222\016\000\002\322\003\t\006\000\023\005\001\222\001\000\000\201\003\000\201\276\000\201\200\216\016\000\000\200\017\001\001\202\005\000\205\322\f%\000\000\004\000\205\322\023\000\002\000\022\201\023\216\201\030\006(\006\000\377\321\005'\020\004\001\005\004h\022\203\016\216\b\030\350\321\022\006\022\004\004\013\024h\022\f\bh\002\201\222\216\002\000\205\322\025\004\002\000\200\002\016~\002\024\350\321\026\030\n\004\f\022\f\200\003\000\217\276\007\003\n~\007\003\026~\007\003\022~\007\003\006~\r\023\r\202\002\000\b\322\002\0031\000\004\000\217\322\201\b\002\000\016\201\214\216\006\000\217\322\201\f\002\000\b\000\217\322\201\020\002\000\n\000\217\322\201\024\002\000\017@\331\323\200\000\000\030\016@\331\323\200\000\000\030\r@\331\323\200\000\000\030\f@\331\323\200\000\000\030\013@\331\323\200\000\000\030\n@\331\323\200\000\000\030\t@\331\323\200\000\000\030\b@\331\323\200\000\000\030\007@\331\323\200\000\000\030\006@\331\323\200\000\000\030\005@\331\323\200\000\000\030\004@\331\323\200\000\000\030\003@\331\323\200\000\000\030\002@\331\323\200\000\000\030\001@\331\323\200\000\000\030\000@\331\323\200\000\000\030\377\000\202\276\000\001\004\005\020\000\b\322\000\000)\004\022\000\b\322\000\000!\004\024\000\b\322\000\000\031\004\026\000\b\322\000\000\021\004\000\200H\334\020\000\177\017\000\200H\334\022\000\177\032\000\200H\334\024\000\177\033\000\200H\334\026\000\177\034\000\200T\334\002\000\177\030\003\210\003\201\000\f\000\200\001\r\001\202\003\007\t\277\002\000\b\322\002\001A\002s\017\214\277\020\000\355\321\032\037\n\000q\017\214\277\021\000\355\321\0347\n\000p\017\214\277\000\000\232\330\r\030\000\000\000\000\232\330\016\020\000\000\177\300\214\277\000\000\212\277\000\000\354\330\r\000\000\020\000\000\354\330\016\000\000\022\177\300\214\277\000\200\340\323\020%\002\004\323\377\204\277 \000\202\277\000@\331\323\200\000\000\030\001@\331\323\200\000\000\030\002@\331\323\200\000\000\030\003@\331\323\200\000\000\030\004@\331\323\200\000\000\030\005@\331\323\200\000\000\030\006@\331\323\200\000\000\030\007@\331\323\200\000\000\030\b@\331\323\200\000\000\030\t@\331\323\200\000\000\030\n@\331\323\200\000\000\030\013@\331\323\200\000\000\030\f@\331\323\200\000\000\030\r@\331\323\200\000\000\030\016@\331\323\200\000\000\030\017@\331\323\200\000\000\030\t\013\000\222\b\004\001\222\000\001\000\201\n\005\001\222\000\001\000\201\200\000\201\276\f\003\002(\001\000\200\277\022@\330\323\000\001\000\030\000\201\200\216\000\002\350\321\001\r\000\004\020\000\000\200\f\000\310\321\022!\005\002\377\177\002\260\021\001\001\202\200\002\002~\f\000\377\321\f%\n\000\377$&(\000\000@\000\022%\220|\021@\330\323\001\001\000\030\000\000\b\322\000\003\001\000\f'\030\000\000\200l\334\000\f\177\000\f\000\310\321\021!\005\002\f\000\377\321\f#\n\000\377\"$(\000\000@\000\021#\220|\006\237\007\220\020@\330\323\002\001\000\030\f%\030\000\022\000\b\322\006\002\001\004\000\200l\334\022\f\177\000\006\201\000\216\f\000\310\321\020!\005\002\f\000\377\321\f!\n\000\377 \"(\000\000@\000\020!\220|\000\237\001\220\017@\330\323\003\001\000\030\f#\030\000\020\000\b\322\000\002\001\004\000\200l\334\020\f\177\000\006\203\000\222\f\000\310\321\017!\005\002\f\000\377\321\f\037\n\000\377\036 (\000\000@\000\017\037\220|\000\237\001\220\016@\330\323\004\001\000\030\f!\030\000\020\000\b\322\000\002\001\004\000\200l\334\020\f\177\000\006\203\000\216\f\000\310\321\016!\005\002\f\000\377\321\f\035\n\000\377\034\036(\000\000@\000\016\035\220|\000\237\001\220\r@\330\323\005\001\000\030\f\037\030\000\016\000\b\322\000\002\001\004\000\200l\334\016\f\177\000\006\211\000\222\f\000\310\321\r!\005\002\f\000\377\321\f\033\n\000\377\032\034(\000\000@\000\r\033\220|\000\237\001\220\013@\330\323\006\001\000\030\f\035\034\000\f\000\b\322\000\002\001\004\000\200l\334\f\016\177\000\006\212\000\222\f\000\310\321\013!\005\002\f\000\377\321\f\027\n\000\377\026\032(\000\000@\000\013\027\220|\000\237\001\220\n@\330\323\007\001\000\030\f\033\026\000\f\000\b\322\000\002\001\004\000\200l\334\f\013\177\000\006\213\000\222\013\000\310\321\n!\005\002\013\000\377\321\013\025\n\000\377\024\030(\000\000@\000\n\025\220|\000\237\001\220\t@\330\323\b\001\000\030\013\031\030\000\n\000\b\322\000\002\001\004\000\200l\334\n\f\177\000\006\204\000\216\n\000\310\321\t!\005\002\n\000\377\321\n\023\n\000\377\022\026(\000\000@\000\t\023\220|\000\237\001\220\b@\330\323\t\001\000\030\n\027\022\000\n\000\b\322\000\002\001\004\000\200l\334\n\t\177\000\006\221\000\222\t\000\310\321\b!\005\002\t\000\377\321\t\021\n\000\377\020\024(\000\000@\000\b\021\220|\000\237\001\220\007@\330\323\n\001\000\030\t\025\024\000\b\000\b\322\000\002\001\004\000\200l\334\b\n\177\000\006\222\000\222\b\000\310\321\007!\005\002\b\000\377\321\b\017\n\000\377\016\022(\000\000@\000\007\017\220|\000\237\001\220\006@\330\323\013\001\000\030\b\023\016\000\b\000\b\322\000\002\001\004\000\200l\334\b\007\177\000\006\223\000\222\007\000\310\321\006!\005\002\007\000\377\321\007\r\n\000\377\f\020(\000\000@\000\006\r\220|\000\237\001\220\005@\330\323\f\001\000\030\007\021\020\000\006\000\b\322\000\002\001\004\000\200l\334\006\b\177\000\006\230\000\222\006\000\310\321\005!\005\002\006\000\377\321\006\013\n\000\377\n\016(\000\000@\000\005\013\220|\000\237\001\220\004@\330\323\r\001\000\030\006\017\n\000\006\000\b\322\000\002\001\004\000\200l\334\006\005\177\000\006\231\000\222\005\000\310\321\004!\005\002\005\000\377\321\005\t\n\000\377\b\f(\000\000@\000\004\t\220|\000\237\001\220\003@\330\323\016\001\000\030\005\r\f\000\004\000\b\322\000\002\001\004\000\200l\334\004\006\177\000\006\232\000\222\004\000\310\321\003!\005\002\004\000\377\321\004\007\n\000\377\006\n(\000\000@\000\003\007\220|\000\237\001\220\002@\330\323\017\001\000\030\004\013\006\000\004\000\b\322\000\002\001\004\000\200l\334\004\003\177\000\006\233\000\222\003\000\310\321\002!\005\002\003\000\377\321\003\005\n\000\377\004\b(\000\000@\000\002\005\220|\000\237\001\220\000\000\b\322\000\002\001\004\003\t\004\000\000\200l\334\000\002\177\000\000\000\201\277\006\000\000\000\000\000\000\000`\f\000\000\000\000\000\000\013\000\000\000\000\000\000\000\030\000\000\000\000\000\000\000\005\000\000\000\000\000\000\000X\r\000\000\000\000\000\000\n\000\000\000\000\000\000\000i\001\000\000\000\000\000\000\365\376\377o\000\000\000\000\360\f\000\000\000\000\000\000\004\000\000\000\000\000\000\000 \r\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000AMD clang version 20.0.0git (https://github.com/RadeonOpenCompute/llvm-project roc-7.0.1 25314 f4087f6b428f0e6f575ebac8a8a724dab123d06e)\000Linker: AMD LLD 20.0.0 (/longer_pathname_so_that_rpms_can_support_packaging_the_debug_info_for_all_os_profiles/src/llvm-project/llvm f4087f6b428f0e6f575ebac8a8a724dab123d06e)\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\001\000\000\000\000\000\361\377\f\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000F\000\000\000\000\000\361\377\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\213\000\000\000\000\000\361\377\022\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\325\000\000\000\000\000\361\377\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\"\001\000\000\000\000\361\377\001\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000g\001\000\000\000\000\361\377\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\265\001\000\000\000\000\361\377\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\005\002\000\000\000\000\361\377\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000O\002\000\000\000\000\361\377\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\235\002\000\000\000\000\361\377\035\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\r\003\000\000\000\000\361\377\020\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000}\003\000\000\000\000\361\377\032\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\362\003\000\000\000\000\361\377\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000j\004\000\000\000\000\361\377\001\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\332\004\000\000\000\000\361\377\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000S\005\000\000\000\000\361\377\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\316\005\000\000\000\000\361\377\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000C\006\000\000\000\000\361\377\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\274\006\000\000\000\000\361\377\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\320\006\000\000\000\000\361\377\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\344\006\000\000\000\000\361\377\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000`\b\000\000\000\002\b\000@=\000\000\000\000\000\000\000\000\000\000\000\000\000\000\370\006\000\000\022\003\007\000\000 \000\000\000\000\000\000x\001\000\000\000\000\000\0004\007\000\000\021\003\006\000\000\017\000\000\000\000\000\000@\000\000\000\000\000\000\000s\007\000\000\022\003\007\000\000&\000\000\000\000\000\000@\007\000\000\000\000\000\000\332\007\000\000\021\003\006\000@\017\000\000\000\000\000\000@\000\000\000\000\000\000\000D\b\000\000\021\000\n\000\260M\000\000\000\000\000\000\001\000\000\000\000\000\000\000\000.note\000.dynsym\000.gnu.hash\000.hash\000.dynstr\000.rodata\000.text\000.dynamic\000.relro_padding\000.bss\000.AMDGPU.csdata\000.AMDGPU.gpr_maximums\000.comment\000.symtab\000.shstrtab\000.strtab\000\000_Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b.num_vgpr\000_Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b.num_agpr\000_Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b.numbered_sgpr\000_Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b.private_seg_size\000_Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b.uses_vcc\000_Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b.uses_flat_scratch\000_Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b.has_dyn_sized_stack\000_Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b.has_recursion\000_Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b.has_indirect_call\000_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i.num_vgpr\000_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i.num_agpr\000_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i.numbered_sgpr\000_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i.private_seg_size\000_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i.uses_vcc\000_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i.uses_flat_scratch\000_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i.has_dyn_sized_stack\000_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i.has_recursion\000_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i.has_indirect_call\000amdgpu.max_num_vgpr\000amdgpu.max_num_agpr\000amdgpu.max_num_sgpr\000_Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b\000_Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b.kd\000_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i\000_Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i.kd\000__hip_cuid_f59befd3832c6d3e\000_DYNAMIC\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\001\000\000\000\007\000\000\000\002\000\000\000\000\000\000\0008\002\000\000\000\000\000\0008\002\000\000\000\000\000\000(\n\000\000\000\000\000\000\000\000\000\000\000\000\000\000\004\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\007\000\000\000\013\000\000\000\002\000\000\000\000\000\000\000`\f\000\000\000\000\000\000`\f\000\000\000\000\000\000\220\000\000\000\000\000\000\000\005\000\000\000\001\000\000\000\b\000\000\000\000\000\000\000\030\000\000\000\000\000\000\000\017\000\000\000\366\377\377o\002\000\000\000\000\000\000\000\360\f\000\000\000\000\000\000\360\f\000\000\000\000\000\0000\000\000\000\000\000\000\000\002\000\000\000\000\000\000\000\b\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\031\000\000\000\005\000\000\000\002\000\000\000\000\000\000\000 \r\000\000\000\000\000\000 \r\000\000\000\000\000\0008\000\000\000\000\000\000\000\002\000\000\000\000\000\000\000\004\000\000\000\000\000\000\000\004\000\000\000\000\000\000\000\037\000\000\000\003\000\000\000\002\000\000\000\000\000\000\000X\r\000\000\000\000\000\000X\r\000\000\000\000\000\000i\001\000\000\000\000\000\000\000\000\000\000\000\000\000\000\001\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000'\000\000\000\001\000\000\000\002\000\000\000\000\000\000\000\000\017\000\000\000\000\000\000\000\017\000\000\000\000\000\000\200\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000@\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000/\000\000\000\001\000\000\000\006\000\000\000\000\000\000\000\000 \000\000\000\000\000\000\000\020\000\000\000\000\000\000@\r\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\001\000\000\000\000\000\000\000\000\000\000\000\000\000\0005\000\000\000\006\000\000\000\003\000\000\000\000\000\000\000@=\000\000\000\000\000\000@\035\000\000\000\000\000\000p\000\000\000\000\000\000\000\005\000\000\000\000\000\000\000\b\000\000\000\000\000\000\000\020\000\000\000\000\000\000\000>\000\000\000\b\000\000\000\003\000\000\000\000\000\000\000\260=\000\000\000\000\000\000\260\035\000\000\000\000\000\000P\002\000\000\000\000\000\000\000\000\000\000\000\000\000\000\001\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000M\000\000\000\b\000\000\000\003\000\000\000\000\000\000\000\260M\000\000\000\000\000\000\260\035\000\000\000\000\000\000\001\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\001\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000R\000\000\000\001\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\260\035\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\001\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000a\000\000\000\001\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\260\035\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\001\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000v\000\000\000\001\000\000\0000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\260\035\000\000\000\000\000\0009\001\000\000\000\000\000\000\000\000\000\000\000\000\000\000\001\000\000\000\000\000\000\000\001\000\000\000\000\000\000\000\177\000\000\000\002\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\360\036\000\000\000\000\000\000\240\002\000\000\000\000\000\000\020\000\000\000\027\000\000\000\b\000\000\000\000\000\000\000\030\000\000\000\000\000\000\000\207\000\000\000\003\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\220!\000\000\000\000\000\000\231\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\001\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\221\000\000\000\003\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000)\"\000\000\000\000\000\000i\b\000\000\000\000\000\000\000\000\000\000\000\000\000\000\001\000\000\000\000\000\000\000\000\000\000\000\000\000\000"
	.size	.L__unnamed_3, 16088

	.type	__hip_fatbin_wrapper,@object    # @__hip_fatbin_wrapper
	.section	.hipFatBinSegment,"a",@progbits
	.p2align	3, 0x0
__hip_fatbin_wrapper:
	.long	1212764230                      # 0x48495046
	.long	1                               # 0x1
	.quad	.L__unnamed_3
	.quad	0
	.size	__hip_fatbin_wrapper, 24

	.type	__hip_gpubin_handle_f59befd3832c6d3e,@object # @__hip_gpubin_handle_f59befd3832c6d3e
	.local	__hip_gpubin_handle_f59befd3832c6d3e
	.comm	__hip_gpubin_handle_f59befd3832c6d3e,8,8
	.section	.init_array,"aw",@init_array
	.p2align	3, 0x0
	.quad	__hip_module_ctor
	.type	__hip_cuid_f59befd3832c6d3e,@object # @__hip_cuid_f59befd3832c6d3e
	.bss
	.globl	__hip_cuid_f59befd3832c6d3e
__hip_cuid_f59befd3832c6d3e:
	.byte	0                               # 0x0
	.size	__hip_cuid_f59befd3832c6d3e, 1

	.type	.Lstr,@object                   # @str
	.section	.rodata.str1.1,"aMS",@progbits,1
.Lstr:
	.asciz	"Start"
	.size	.Lstr, 6

	.type	.Lstr.1,@object                 # @str.1
.Lstr.1:
	.asciz	"BMM result is not correct"
	.size	.Lstr.1, 26

	.ident	"AMD clang version 20.0.0git (https://github.com/RadeonOpenCompute/llvm-project roc-7.0.1 25314 f4087f6b428f0e6f575ebac8a8a724dab123d06e)"
	.section	".note.GNU-stack","",@progbits
	.addrsig
	.addrsig_sym _Z50__device_stub__batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b
	.addrsig_sym __gxx_personality_v0
	.addrsig_sym _Z64__device_stub__batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i
	.addrsig_sym __hip_module_ctor
	.addrsig_sym __hip_module_dtor
	.addrsig_sym _Unwind_Resume
	.addrsig_sym _Z35batched_matrix_multiplication_naiveiiiiPKDF16bS0_PDF16b
	.addrsig_sym _ZTISt13runtime_error
	.addrsig_sym _Z49batched_matrix_multiplication_matrix_core_64x64x4ILj64ELj64ELj8EEvjjjjPKDF16bS1_PDF16b4dim3S3_S3_i
	.addrsig_sym .L__unnamed_3
	.addrsig_sym __hip_fatbin_wrapper
	.addrsig_sym __hip_cuid_f59befd3832c6d3e

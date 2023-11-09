	.file	"yoursort.c"
	.text
	.globl	insertion_sort
	.type	insertion_sort, @function
insertion_sort:
.LFB26:
	.cfi_startproc
	movq	%rsi, %r9
	jmp	.L2
.L5:
	movq	%rcx, 8(%rdi,%rax,8)
	subq	$1, %rax
.L3:
	cmpq	%rsi, %rax
	jl	.L4
	movq	(%rdi,%rax,8), %rcx
	cmpq	%r8, %rcx
	jg	.L5
.L4:
	movq	%r8, 8(%rdi,%rax,8)
	addq	$1, %r9
.L2:
	cmpq	%rdx, %r9
	jg	.L7
	movq	(%rdi,%r9,8), %r8
	leaq	-1(%r9), %rax
	jmp	.L3
.L7:
	rep ret
	.cfi_endproc
.LFE26:
	.size	insertion_sort, .-insertion_sort
	.globl	your_sort
	.type	your_sort, @function
your_sort:
.LFB27:
	.cfi_startproc
	movq	%rdx, %rax
	subq	%rsi, %rax
	cmpq	%rsi, %rdx
	jle	.L15
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
	movq	%rsi, %r12
	movq	%rdi, %rbp
	cmpq	$10, %rax
	jg	.L10
	call	insertion_sort
.L8:
	popq	%rbx
	.cfi_remember_state
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
.L10:
	.cfi_restore_state
	leaq	(%rdx,%rsi), %rax
	sarq	%rax
	movq	(%rdi,%rax,8), %r9
	leaq	-1(%rsi), %rax
	leaq	1(%rdx), %rbx
	jmp	.L11
.L12:
	addq	$1, %rax
	leaq	0(%rbp,%rax,8), %rsi
	movq	(%rsi), %rdi
	cmpq	%r9, %rdi
	jl	.L12
.L13:
	subq	$1, %rbx
	leaq	0(%rbp,%rbx,8), %rcx
	movq	(%rcx), %r8
	cmpq	%r9, %r8
	jg	.L13
	movq	%r8, (%rsi)
	movq	%rdi, (%rcx)
.L11:
	cmpq	%rbx, %rax
	jl	.L12
	leaq	1(%rbx), %rsi
	movq	%rbp, %rdi
	call	your_sort
	movq	%rbx, %rdx
	movq	%r12, %rsi
	movq	%rbp, %rdi
	call	your_sort
	jmp	.L8
.L15:
	.cfi_def_cfa_offset 8
	.cfi_restore 3
	.cfi_restore 6
	.cfi_restore 12
	rep ret
	.cfi_endproc
.LFE27:
	.size	your_sort, .-your_sort
	.globl	run
	.type	run, @function
run:
.LFB28:
	.cfi_startproc
	pushq	%r12
	.cfi_def_cfa_offset 16
	.cfi_offset 12, -16
	pushq	%rbp
	.cfi_def_cfa_offset 24
	.cfi_offset 6, -24
	pushq	%rbx
	.cfi_def_cfa_offset 32
	.cfi_offset 3, -32
#APP
# 6 "x86prime_lib.h" 1
	in (0),%rcx
# 0 "" 2
#NO_APP
	movq	%rcx, %r12
	andl	$1, %r12d
	andl	$2, %ecx
#APP
# 6 "x86prime_lib.h" 1
	in (0),%rdx
# 0 "" 2
#NO_APP
	movq	%rdx, %rbx
	leaq	0(,%rdx,8), %r8
	leaq	allocator_base(%rip), %rax
	addq	%r8, %rax
	movq	%rax, cur_allocator(%rip)
	movl	$0, %eax
	jmp	.L19
.L20:
	leaq	allocator_base(%rip), %rsi
	leaq	(%rsi,%rax,8), %rsi
#APP
# 12 "x86prime_lib.h" 1
	in (1),%rdi
# 0 "" 2
#NO_APP
	movq	%rdi, (%rsi)
	addq	$1, %rax
.L19:
	cmpq	%rbx, %rax
	jl	.L20
	testq	%rcx, %rcx
	je	.L21
	movq	cur_allocator(%rip), %rbp
	addq	%rbp, %r8
	movq	%r8, cur_allocator(%rip)
	movl	$0, %eax
	jmp	.L22
.L23:
	leaq	0(%rbp,%rax,8), %rcx
#APP
# 6 "x86prime_lib.h" 1
	in (0),%rsi
# 0 "" 2
#NO_APP
	movq	%rsi, (%rcx)
	addq	$1, %rax
.L22:
	cmpq	%rax, %rbx
	jg	.L23
.L24:
	subq	$1, %rdx
	movl	$0, %esi
	movq	%rbp, %rdi
	call	your_sort
	testq	%r12, %r12
	je	.L18
	movl	$0, %eax
	jmp	.L27
.L21:
	movq	cur_allocator(%rip), %rbp
	addq	%rbp, %r8
	movq	%r8, cur_allocator(%rip)
	jmp	.L25
.L26:
	leaq	0(%rbp,%rcx,8), %rax
#APP
# 12 "x86prime_lib.h" 1
	in (1),%rsi
# 0 "" 2
#NO_APP
	movq	%rsi, (%rax)
	addq	$1, %rcx
.L25:
	cmpq	%rcx, %rbx
	jg	.L26
	jmp	.L24
.L29:
	movq	0(%rbp,%rax,8), %rdx
#APP
# 17 "x86prime_lib.h" 1
	out %rdx,(0)
# 0 "" 2
#NO_APP
	addq	$1, %rax
.L27:
	cmpq	%rax, %rbx
	jg	.L29
.L18:
	movq	%rbp, %rax
	popq	%rbx
	.cfi_def_cfa_offset 24
	popq	%rbp
	.cfi_def_cfa_offset 16
	popq	%r12
	.cfi_def_cfa_offset 8
	ret
	.cfi_endproc
.LFE28:
	.size	run, .-run
	.comm	allocator_base,8,8
	.comm	cur_allocator,8,8
	.ident	"GCC: (Ubuntu 7.3.0-27ubuntu1~18.04) 7.3.0"
	.section	.note.GNU-stack,"",@progbits

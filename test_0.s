	.file	"test.cpp"
# GNU C++17 (Ubuntu 11.3.0-1ubuntu1~22.04) version 11.3.0 (x86_64-linux-gnu)
#	compiled by GNU C version 11.3.0, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.1, isl version isl-0.24-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -mtune=generic -march=x86-64 -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection
	.text
	.section	.rodata
.LC0:
	.string	"Slim shady"
	.align 8
.LC1:
	.string	"My name id %s, %d%d%d%d%d%d%d%d"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	endbr64	
	pushq	%rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp	#,
	.cfi_def_cfa_register 6
	subq	$16, %rsp	#,
# test.cpp:7:     const char * line = "Slim shady";
	leaq	.LC0(%rip), %rax	#, tmp84
	movq	%rax, -8(%rbp)	# tmp84, line
# test.cpp:8:     int year = 1999;
	movl	$1999, -12(%rbp)	#, year
# test.cpp:10:     printf("My name id %s, %d%d%d%d%d%d%d%d", line, year, year, year, year, year, year, year, year);
	movl	-12(%rbp), %r8d	# year, tmp85
	movl	-12(%rbp), %edi	# year, tmp86
	movl	-12(%rbp), %ecx	# year, tmp87
	movl	-12(%rbp), %edx	# year, tmp88
	movq	-8(%rbp), %rax	# line, tmp89
	movl	-12(%rbp), %esi	# year, tmp90
	pushq	%rsi	# tmp90
	movl	-12(%rbp), %esi	# year, tmp91
	pushq	%rsi	# tmp91
	movl	-12(%rbp), %esi	# year, tmp92
	pushq	%rsi	# tmp92
	movl	-12(%rbp), %esi	# year, tmp93
	pushq	%rsi	# tmp93
	movl	%r8d, %r9d	# tmp85,
	movl	%edi, %r8d	# tmp86,
	movq	%rax, %rsi	# tmp89,
	leaq	.LC1(%rip), %rax	#, tmp94
	movq	%rax, %rdi	# tmp94,
	movl	$0, %eax	#,
	call	printf@PLT	#
	addq	$32, %rsp	#,
# test.cpp:11: }
	movl	$0, %eax	#, _5
	leave	
	.cfi_def_cfa 7, 8
	ret	
	.cfi_endproc
.LFE0:
	.size	main, .-main
	.ident	"GCC: (Ubuntu 11.3.0-1ubuntu1~22.04) 11.3.0"
	.section	.note.GNU-stack,"",@progbits
	.section	.note.gnu.property,"a"
	.align 8
	.long	1f - 0f
	.long	4f - 1f
	.long	5
0:
	.string	"GNU"
1:
	.align 8
	.long	0xc0000002
	.long	3f - 2f
2:
	.long	0x3
3:
	.align 8
4:

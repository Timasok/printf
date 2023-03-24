	.file	"test.cpp"
	.intel_syntax noprefix
# GNU C++17 (Ubuntu 11.3.0-1ubuntu1~22.04) version 11.3.0 (x86_64-linux-gnu)
#	compiled by GNU C version 11.3.0, GMP version 6.2.1, MPFR version 4.1.0, MPC version 1.2.1, isl version isl-0.24-GMP

# GGC heuristics: --param ggc-min-expand=100 --param ggc-min-heapsize=131072
# options passed: -masm=intel -mtune=generic -march=x86-64 -fasynchronous-unwind-tables -fstack-protector-strong -fstack-clash-protection -fcf-protection
	.text
	.section	.rodata
.LC0:
	.string	"Slim shady"
.LC1:
	.string	"My name is %s, its %d"
.LC2:
	.string	"Otoydi!"
	.text
	.globl	main
	.type	main, @function
main:
.LFB0:
	.cfi_startproc
	endbr64	
	push	rbp	#
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	mov	rbp, rsp	#,
	.cfi_def_cfa_register 6
	sub	rsp, 16	#,
# test.cpp:7:     const char * line = "Slim shady";
	lea	rax, .LC0[rip]	# tmp84,
	mov	QWORD PTR -8[rbp], rax	# line, tmp84
# test.cpp:8:     int year = 1999;
	mov	DWORD PTR -12[rbp], 1999	# year,
# test.cpp:11:     printf("My name is %s, its %d", line, year);
	mov	edx, DWORD PTR -12[rbp]	# tmp85, year
	mov	rax, QWORD PTR -8[rbp]	# tmp86, line
	mov	rsi, rax	#, tmp86
	lea	rax, .LC1[rip]	# tmp87,
	mov	rdi, rax	#, tmp87
	mov	eax, 0	#,
	call	printf@PLT	#
# test.cpp:13:     puts("Otoydi!");
	lea	rax, .LC2[rip]	# tmp88,
	mov	rdi, rax	#, tmp88
	call	puts@PLT	#
# test.cpp:15: }
	mov	eax, 0	# _6,
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

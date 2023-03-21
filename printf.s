section .text

global _start

_start:     
            mov rax, 0x01
            mov rdi, 1
            mov rsi, Msg
            mov rdx, MsgLen
            syscall
            
            mov rax, 0x3C      ; exit64 (rdi)
            xor rdi, rdi
            syscall

Msg:        db "__Hllwrld", 0x0a
MsgLen      equ $ - Msg
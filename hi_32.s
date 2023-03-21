section .code

global _start

_start:     
            mov eax, 0x04
            mov ebx, 1
            mov ecx, Msg
            mov edx,MsgLen
            int 0x80

            mov eax, 0x01
            xor ebx, ebx
            int 0x80

Msg:        db "__Hllwrld", 0x0a
MsgLen      equ $ - Msg
Octal:
                                             ; fish argument
;================================================
            inc rcx                         ; inc current
            mov rax, rcx                    ; save current
oct_stk:   
            add rsp, 8
            loop oct_stk
            mov rcx, rax                    ; revive current
            mov rax, [rsp]                   ; save argument in rax
            mov rsp, rbp
;================================================

            mov r8, 0FFFFh
            push r8
            mov r8, rdx                 ; r8 = rdx

            mov r9, 10d             ; add value that we are going to delete

oct_first:  cmp rax, 0
            je oct_end_first

            xor rdx, rdx
            div r9

            push rdx

            jmp oct_first

oct_end_first:
oct_second:
            pop rax

            cmp rax, 0FFFFh          ; check if poison
            je oct_end_second

            add rax, '0'
            mov byte [rsi+r8], al   ; send to buffer
            inc r8

            jmp oct_second
oct_end_second:

            mov rdx, r8             ; revive rdx   

            inc rbx
            jmp next
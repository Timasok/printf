Hex:
                                             ; fish argument
;================================================
            inc rcx                         ; inc current
            mov rax, rcx                    ; save current
hex_stk:   
            add rsp, 8
            loop hex_stk
            mov rcx, rax                    ; revive current
            mov rax, [rsp]                   ; save argument in rax
            mov rsp, rbp
;================================================

            mov r8, 0FFFFh
            push r8
            mov r8, rdx                 ; r8 = rdx

            mov r9, 16d             ; add value that we are going to delete

hex_first:  cmp rax, 0
            je hex_end_first

            xor rdx, rdx
            div r9

            push rdx

            jmp hex_first

hex_end_first:
hex_second:
            pop rax

            cmp rax, 0FFFFh          ; check if poison
            je hex_end_second

            cmp rax, 000ah
            jb hex_digit
            jmp hex_symbol

hex_digit:  add rax, 48d
            jmp hex_print
hex_symbol:
            add rax, 55d
            jmp hex_print

hex_print:   
            mov byte [rsi+r8], al   ; send to buffer
            inc r8

            jmp hex_second
hex_end_second:

            mov rdx, r8             ; revive rdx   

            inc rbx
            jmp next
Hex:                                          ; fish argument
;================================================
            inc rcx                         ; inc current
            mov rax, rcx                    ; save current
hex_stk:   
            add rsp, 8
            loop hex_stk
            mov rcx, rax                      ; revive current
            mov rax, [rsp]                    ; save argument in rax
            mov rsp, rbp
;================================================

            mov r9, rdx
            mov r8, rcx

            mov rcx, 4

hex_next:   
            push rcx
            sub rcx, 1

            push rax
            mov rdx, rax

            mov rax, 4
            mul rcx
            mov rcx, rax

            pop rdx
            push rdx

            shr rdx, cl
            and dx, 000Fh

            cmp dx, 000ah
            jb hex_digit
            jmp hex_symbol

hex_digit:  add rdx, 48d
            jmp hex_finish
hex_symbol:
            add rdx, 55d
            jmp hex_finish

hex_finish:   
            xor rax, rax
            add rax, rdx                           
;===
            mov byte [rsi+r9], al   ; send to buffer
            inc r9

            pop rax
            pop rcx
            loop hex_next

            mov rcx, r8                    ; revive current
            mov rdx, r9

            inc rbx
            jmp next
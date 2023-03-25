String:
                                             ; fish argument
;================================================
            inc rcx                         ; inc current
            mov rax, rcx                    ; save current
str_stk:   
            add rsp, 8
            loop str_stk
            mov rcx, rax                    ; revive current
            mov r9, [rsp]                   ; save argument in rax
            mov rsp, rbp
;================================================ 

            xor r8, r8
            xor rax, rax
str_next:
            mov byte al,[r9+r8]          ; get from format
            inc r8

            cmp byte al, term
            je str_finish

            mov byte [rsi+rdx], al         ; send to buffer
            inc rdx

            jmp str_next
str_finish:

            inc rbx
            jmp next
;------------------------------------------------
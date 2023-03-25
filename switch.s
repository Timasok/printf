section .text

;------------------------------------------------
;This function handles following %-s:
; %b - binary
; %d - decimal
; %o - ox
; %x - hex
; %c - char
; %s - string
;Entry:     
;Exit:      rdx = buffer_length
;Expects:   
;Destroys:  
;------------------------------------------------
SwitchArg:

            ; cmp rsp, rbp
            ; je error! : too many arguments!

            mov byte al, [rdi + rbx] 
            jmp [jmp_tab_formats + rax*8]

            ; inc rbx
            ; jmp next

;------------------------------------------------

;------------------------------------------------
Decimal:
            mov rax, [rsp]                   ; save argument in rax
            dec rcx
                                            ; prologue
;================================================
stk_prev:   sub rsp, 8
            cmp rsp, rbp
            jne stk_prev
;================================================

            mov r8, 0FFFFh
            push r8
            mov r8, rdx                 ; r8 = rdx

            mov rcx, 10d             ; add value that we are going to delete

dec_first:  cmp r8, 0
            je dec_end_first

            xor dx, dx
            div rcx

            push rdx

            jmp dec_first

dec_end_first:
dec_second:
            mov rdx, r8              ; revive rdx   
            pop rax

            cmp rax, 0FFFFh          ; check if poison
            je dec_end_second

            mov byte [rsi+rdx], al          ; send to buffer
            inc rdx

            jmp dec_second
dec_end_second:

                                            ; epilogue
;================================================
            mov rax, rcx
stk_next:   add rsp, 8
            cmp rsp, rbp
            loop stk_next
            mov rcx, rax
;================================================

            inc rbx
            jmp next
;------------------------------------------------

;------------------------------------------------
Binary:
;------------------------------------------------

;------------------------------------------------
Octal:
;------------------------------------------------

;------------------------------------------------
String:
;------------------------------------------------

;------------------------------------------------
Hex:
;------------------------------------------------

;------------------------------------------------
Char:
;------------------------------------------------

; ;------------------------------------------------
; ReviveStack:

; stk_prev:       sub rsp, 8
;                 cmp rsp, rbp
;                 jne stk_prev

; ;------------------------------------------------

; ;------------------------------------------------
; KillStack:
;                 mov rax, rcx
; stk_next:       add rsp, 8
;                 cmp rsp, rbp
;                 loop stk_next

;                 mov rcx, rax
; ;------------------------------------------------


section .data

; bin     equ 'b'
; char    equ 'c'
; decimal equ 'd'
; oct     equ 'o'                     ; termination symbol
; string  equ 's'
; hex     equ 'x'                     ; specificator symbol

section .rodata                     ; read only data

jmp_tab_formats:

times       98 dq 0                 ; (ascii code of b) * 8
dq          Binary
dq          Char
dq          Decimal
times       11 dq 0                 ; ('o' - 'd') * 8
dq          Octal
times       4  dq 0                 ; ('s' - 'o') * 8
dq          String
times       5  dq 0                 ; ('x' - 's') * 8
dq          Hex
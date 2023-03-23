section .text
; global _start
; _start:     
;             call TimPrint          
;             mov rax, 0x3C      ; exit64 (rdi)
;             xor rdi, rdi
;             syscall

global TimPrint
;------------------------------------------------
TimPrint:   
            pop r15                 ; save ret addr

            push r10 
            push r11
            call ConvertP           ; make all parameteres stay in stack
            pop r11 
            pop r10

            ; push rbp
            ; mov rbp, rsp

            ; ; push r9
            ; ; push r8
            ; ; push cx            
            ; ; push rdx
            ; ; push rsi
            ; ; push rdi

            ; ; sub rsp,                ; shift stackpointer down

            ; pop rbp

            push r15
            ret
;------------------------------------------------

;------------------------------------------------
; Push remainder of params from registers
;-----------------------------------------------
ConvertP:
            pop r11                 ; save retaddr
            
            push r10 
            push r11
            call CalcP
            pop r11 
            pop r10

            jmp [jmp_tab_params + rax*8]

zero_params:
            jmp finish_1

one__param:
            push rsi
            jmp finish_1

two_params:
            push rdx
            push rsi
            jmp finish_1

three_params:
            push rcx
            push rdx
            push rsi
            jmp finish_1

four_params:
            push r8
            push rcx
            push rdx 
            push rsi
            jmp finish_1

five_params:
            push r9
            push r8
            push rcx
            push rdx 
            push rsi
            jmp finish_1
	
finish_1:   push r11                ; revive retaddr
            ret
;------------------------------------------------

;------------------------------------------------
; Function that calculates number of params in print
;   returns value from 1 to 5
;------------------------------------------------
CalcP:
            ; mov r10, rdi           ; use r10 as a ptr to string
            mov rax, 0             ; use rax as a counter
            xor r10, r10

calcp_next: 
            cmp byte [rdi+r10*1] , 0
            je finish

            cmp byte [rdi+r10*1], '%'
            je percent

            inc r10
            jmp calcp_next

percent:    
            inc r10
            cmp byte [rdi+r10*1], '%'    ; check for second '%'
            je calcp_next
            inc rax                ; increament counter
            cmp rax, 5
            jae finish
            jmp calcp_next

finish:
            ret 
;------------------------------------------------

section .data

chunksize equ 8
format:     db "My name id %s, %d"

section .rodata                     ; read only data

jmp_tab_params:
dq          zero_params
dq          one__param
dq          two_params
dq          three_params
dq          four_params
dq          five_params
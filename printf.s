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

            call ConvertP           ; put params to stack
                                    ; number_of_params->rax

            push rbp                ; prologue
            mov rbp, rsp

            ; mov rcx, rax          ; set counter!

            ; mov rbx, 8            ; jump to the start of parameters in stack
            ; imul rbx
            ; add rsp, rax            ; point rsp to first parameter

            jmp FormBuffer
end_form_buf:    

display_buffer:
            mov rax, 0x01
            mov rdi, 1              ; stdout 
            mov rsi, Print_buf
            ; mov rdx, MsgLen
            syscall

            pop rbp                 ; epilogue
            
            push r15
            ret
;------------------------------------------------

;------------------------------------------------
;Function that saves every symbol to Print_buf
;Entry:     
;Exit:      rdx = buffer_length
;Expects:   
;Destroys:  
;------------------------------------------------
FormBuffer:

            mov rdx, 10
; next_param:                         ; while(rsp!=rbp){pop rax; switch rax}
;             sub rsp, 8            
;             cmp rsp, rbp
;             jne next_param

            jmp end_form_buf
;------------------------------------------------


;------------------------------------------------
; Push remainder of params from registers
;-----------------------------------------------
ConvertP:
            pop r14                 ; save retaddr
            
            call CalcP              ; -> rax = number of params
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
	
finish_1:   
            push r14                ; revive retaddr
            ret
;------------------------------------------------

;------------------------------------------------
; Function that calculates number of params in print
;   returns value from 1 to 5
;------------------------------------------------
CalcP:
            push rbx                    ; use as a relative to rdi mem_shift
            mov rax, 0                  ; use rax as a counter
            mov rbx, 0 

calcp_next: 
            cmp byte [rdi+rbx*1] , 0
            je finish

            cmp byte [rdi+rbx*1], '%'
            je percent

            inc rbx
            jmp calcp_next

percent:    
            inc rbx
            cmp byte [rdi+rbx*1], '%'   ; check for second '%'
            je calcp_next
            inc rax                     ; increament counter
            cmp rax, 5
            jae finish
            jmp calcp_next

finish:     
            pop rbx
            ret 
;------------------------------------------------

section .data

chunksize equ 8
spec      equ '%'

Print_buf:  db "Fly with me"
Funk:       db 4000 dup (0)         ; buffer for printed line

section .rodata                     ; read only data

jmp_tab_params:
dq          zero_params
dq          one__param
dq          two_params
dq          three_params
dq          four_params
dq          five_params
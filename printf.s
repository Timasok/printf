; %include "switch.s"
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

            xor rdx, rdx            ; rdx = 0
            mov r14, rax            ; set number of total 
            mov rcx, 0              ; set number of used arguments

            jmp FormBuffer           ;returns rsi = Print_buf; rdx = buffer_length
end_form_buf:    

display_buffer:
            mov rax, 0x01
            mov rdi, 1              ; stdout 

            syscall

            pop rbp                 ; epilogue

            mov rax, r14
            mov r8, 8               ; jump to the start of parameters in stack
            imul r8
            add rsp, rax            ; point rsp to first parameter
            
            push r15
            ret
;------------------------------------------------

;------------------------------------------------
;Function that saves every symbol to Print_buf
;Entry:     
;Exit:
;Expects:   
;Destroys:  
;------------------------------------------------
FormBuffer:

; next_param:                         ; while(rsp!=rbp){pop rax; switch rax}
;             sub rsp, 8            
;             cmp rsp, rbp
;             jne next_param
                                      ; rcx stands for remainding arguments
            xor rbx, rbx              ; set initial shift in format buffer
            mov rsi, Print_buf        ; set symbol start

next:      jmp CheckSymbol

put_sym:
           jmp SendSymbol

put_spec:
           jmp HandleSpec 

form_buf_finish:

            jmp end_form_buf
;------------------------------------------------

;------------------------------------------------
;Function that checks symbol
;Entry:     
;Exit:      rdx = buffer_length
;Expects:   
;Destroys:  
;------------------------------------------------
CheckSymbol:

            cmp byte [rdi+rbx*1], term     ;TODO do we need to incerement here?
            je form_buf_finish

            cmp byte [rdi+rbx*1], spec
            je put_spec

            jmp put_sym
;------------------------------------------------

;------------------------------------------------
;Sends symbol to Print_buf
;------------------------------------------------
SendSymbol:
            mov byte al,[rdi+rbx]          ; get from format
            inc rbx

            mov byte [rsi+rdx], al          ; send to buffer
            inc rdx

            jmp next
;------------------------------------------------

;------------------------------------------------
;Sends byte from al to Print_buf
;------------------------------------------------
DispSymbol:
            mov byte [rsi+rdx], al          ; send to buffer
            inc rdx

            jmp next
;------------------------------------------------

;------------------------------------------------
;Handles % logic
;------------------------------------------------
HandleSpec:
            inc rbx
            
            ; cmp byte [rdi+rbx*1], term     ;error wrong format
            ; je Error

            cmp byte [rdi+rbx*1], spec
            je disp_percent

            jmp SwitchArg                   ; handle argument

disp_percent:
            mov al, spec
            inc rbx
            jmp DispSymbol
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

            cmp byte [rdi+rbx*1], spec
            je percent

            inc rbx
            jmp calcp_next

percent:    
            inc rbx
            cmp byte [rdi+rbx*1], spec  ; check for second '%'
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
spec      equ '%'                   ; specificator symbol
term      equ 0                     ; termination symbol

Print_buf:  db 1000 dup (0)         ; buffer for printed line

section .rodata                     ; read only data

jmp_tab_params:
dq          zero_params
dq          one__param
dq          two_params
dq          three_params
dq          four_params
dq          five_params

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
            xor rax, rax
            mov byte al, [rdi + rbx] 
            jmp [jmp_tab_formats + rax*8]

            ; inc rbx
            ; jmp next

;------------------------------------------------

;------------------------------------------------
Decimal:
                                             ; fish argument
;================================================
            inc rcx                         ; inc current
            mov rax, rcx                    ; save current
dec_stk:   
            add rsp, 8
            loop dec_stk
            mov rcx, rax                    ; revive current
            mov rax, [rsp]                   ; save argument in rax
            mov rsp, rbp
;================================================

            mov r8, 0FFFFh
            push r8
            mov r8, rdx                 ; r8 = rdx

            mov r9, 10d             ; add value that we are going to delete

dec_first:  cmp rax, 0
            je dec_end_first

            xor rdx, rdx
            div r9

            push rdx

            jmp dec_first

dec_end_first:
dec_second:
            pop rax

            cmp rax, 0FFFFh          ; check if poison
            je dec_end_second

            add rax, '0'
            mov byte [rsi+r8], al   ; send to buffer
            inc r8

            jmp dec_second
dec_end_second:

            mov rdx, r8             ; revive rdx   

            inc rbx
            jmp next
;------------------------------------------------

;------------------------------------------------
Binary:
                                             ; fish argument
;================================================
            inc rcx                         ; inc current
            mov rax, rcx                    ; save current
bin_stk:   
            add rsp, 8
            loop bin_stk
            mov rcx, rax                    ; revive current
            mov rax, [rsp]                   ; save argument in rax
            mov rsp, rbp
;================================================

            mov r8, rcx
            mov rcx, 15

bin_next:   
            push rax
            shr rax, cl
            and ax, 0001h
            add ax, 0030h

            mov byte [rsi+rdx], al   ; send to buffer
            inc rdx

            pop rax
            loop bin_next

            and ax, 0001h
            add ax, 0030h

            mov byte [rsi+rdx], al   ; send to buffer
            inc rdx

            mov rcx, r8                    ; revive current

            inc rbx
            jmp next
;------------------------------------------------

;------------------------------------------------
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

            mov r9, 8d             ; add value that we are going to delete

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
;------------------------------------------------

;------------------------------------------------
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
;------------------------------------------------

;------------------------------------------------
Char:
                                             ; fish argument
;================================================
            inc rcx                         ; inc current
            mov rax, rcx                    ; save current
chr_stk:   
            add rsp, 8
            loop chr_stk
            mov rcx, rax                    ; revive current
            mov rax, [rsp]                   ; save argument in rax
            mov rsp, rbp
;================================================

            mov byte [rsi+rdx], al   ; send to buffer
            inc rdx

            inc rbx
            jmp next
;------------------------------------------------

section .rodata                     ; read only data

jmp_tab_formats:

times       98 dq 0                 ; (ascii code of b) * 8
dq          Binary
dq          Char
dq          Decimal
times       10 dq 0                 ; ('o' - 'd') * 8
dq          Octal
times       3  dq 0                 ; ('s' - 'o') * 8
dq          String
times       4  dq 0                 ; ('x' - 's') * 8
dq          Hex
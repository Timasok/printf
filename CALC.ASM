;------------------------------------------------
;Write number in binary
;------------------------------------------------
;Entry:     AX - number
;           DH - x left top coordinate(0-80)
;           DL - y left top coordinate(0-25)
;Exit:      Nothing
;Expects:   ES = 0b800h
;Destroys:  BX, CX
;------------------------------------------------
Write_bin       proc

                push ax                         ; revive cords values
                call Get_Vid_Mem
                pop ax

                mov cl, 15                  ; set counter
                
@@Next:         push ax
                
                shr ax, cl
                and ax, 0001h
                add ax, 00a30h              ; set green ascii code of '0'

                mov word ptr es:[bx], ax
                add bx, 2

                pop ax
                loop @@Next 

                and ax, 0001h
                add ax, 00a30h              ; set green ascii code of '0'

                mov word ptr es:[bx], ax
                add bx, 2

                xor bx, bx

                ret
                endp
;------------------------------------------------

;------------------------------------------------
;Write number in hex
;------------------------------------------------
;Entry:     AX - number
;           DH - x left top coordinate(0-80)
;           DL - y left top coordinate(0-25)
;Exit:      Nothing
;Expects:   ES = 0b800h
;Destroys:  
;------------------------------------------------
Write_hex       proc

                push bx cx dx

                push ax                         ; revive cords values
                call Get_Vid_Mem
                pop ax

                mov cx, 4                       ; set counter
@@Next:         
                push cx                         ; save counter
                sub cx, 1
                
                push ax                         ; save number 
                mov dx, ax

                mov ax, 4
                mul cx                          ; ax = (cx - 1) * 4 
                mov cx, ax                      ; (ax -> cx and use as a shift)

                pop dx                          ; revive number
                push dx

                shr dx, cl
                and dx, 000Fh                   ; dx = number(current translated half-byte)

                cmp dx, 000ah 
                jb @@Digit
                jmp @@Symbol

@@Digit:        add dx, 48d
                jmp @@Finish_him
@@Symbol:
                add dx, 55d
                jmp @@Finish_him

@@Finish_him:   
                xor ax, ax
                add ax, dx              
                mov ah, 0ah                     ; set color

                mov word ptr es:[bx], ax
                add bx, 2

                pop ax
                pop cx
                loop @@Next
                
                xor bx, bx

                pop dx cx bx

                ret 
                endp
;------------------------------------------------

;------------------------------------------------
;Write number in decimal
;------------------------------------------------
;Entry:     AX - number
;           DH - x left top coordinate(0-80)
;           DL - y left top coordinate(0-25)
;Exit:      Nothing
;Expects:   ES = 0b800h
;Destroys:  CX, DX
;------------------------------------------------
Write_dec       proc

                push ax                         ; revive cords values
                call Get_Vid_Mem
                pop ax

                push ax
                mov cx, 0FFFFh          ; add poison to stack's bottom
                push cx

                mov cx, 10d             ; add value that we are going to delete

@@First:        cmp ax, 0
                je @@End_first

                xor dx, dx
                div cx

                push dx

                jmp @@First

@@End_first:    
@@Second:       
                pop dx

                cmp dx, 0FFFFh          ; check if poison
                je @@End_second

                add dx, 00a30h              ; set green ascii code of '0'
                mov word ptr es:[bx], dx
                add bx, 2

                jmp @@Second
@@End_second:

                pop ax
                xor bx, bx

                ret
                endp
;------------------------------------------------

;------------------------------------------------
;Form arithm results from 2 cmd args
;------------------------------------------------
;Entry:     p2 - op1
;           p1 - op2
;Exit:      
;           p6 - op1
;           p5 - op2           
;           p4 - op1+op2
;           p3 - op1-op2
;           p2 - op1*op2
;           p1 - op1/op2(нацело)
;Expects:   None                    
;           write line address(only decimal numbers) and push them to stack
;Destroys:  SI
;------------------------------------------------
Form_arithm     proc
                
                mov si, sp                      ; si = sp
                mov dx, [si]                    ; dx = retaddr
                sub sp, 8                       ; get additional space for 2 parameters

                mov si, sp                      ; si = sp
                mov word ptr [si], dx

                push bp
                mov bp, sp

                mov bx, [bp+14]                 ; get first  operand
                mov cx, [bp+12]                 ; get second opearand

                mov ax, bx
                add ax, cx                      ; ax = op1 + op2

                mov word ptr [bp+10], ax

                mov ax, bx
                sub ax, cx                      ; ax = op1 - op2

                mov word ptr [bp+8], ax

                mov ax, bx
                mul cx                          ; ax = op1 * op2

                mov word ptr [bp+6], ax

                xor dx, dx
                mov ax, bx
                div cx                          ; ax = op1 / op2

                mov word ptr [bp+4], ax

                pop bp
                
                ret
                endp
;------------------------------------------------


;------------------------------------------------
;Print number from cmd args in different numeral systems
;------------------------------------------------
;Entry:     AX - number
;           DH - x0 coordinate(0-80)
;           DL - y0 coordinate(0-25)
;           CX - ptr to string, header
;Exit:      None
;Expects:   ES = 0b800h
;           DRAW, READ, WRITE modules should be included
;           Cmd line has 2 arguments!(add assert maybe)
;Destroys:  AX, BX, CX, DX
;------------------------------------------------
Decimal         db 0ffh, ' Dec', 00dh     ;
Hex             db 0ffh, ' Hex', 00dh     ;
Bin             db 0ffh, ' Bin', 00dh     ;

Print_num       proc                

                push dx

                push cx
                call Write_string
                xor cx, cx

                pop dx
                push dx

                add dx, 0102h                   ; shift dec string start
                push offset Decimal             ; write "DEC"
                call Write_string

                add dx, 0400h                   ; shift dec number start
                call Write_dec  

                pop dx
                push dx

                add dx, 0103h                   ; shift hex string start
                push offset Hex                 ; writr "HEX"
                call Write_string

                add dx, 0400h                   ; shift hex number start
                call Write_hex

                pop dx
                push dx

                add dx, 0104h                   ; shift bin string start
                push offset Bin                 ; write "BIN"
                call Write_string

                add dx, 0400h                   ; shift bin number start
                call Write_bin

                xor cx, cx
;=======================krgbiRGB
                mov bh, 00001100b               ; set frame color
                mov ah, 22d                     ; frame width
                mov al, 5d                      ; frame height

                pop dx    
                add dx, 0001h                   ; shift frame down a little              

                call drawFrame

                ret
                endp
;------------------------------------------------

;------------------------------------------------
;Print arithm of two numbers in the center
;------------------------------------------------
;Entry:     
;           p6 - op1
;           p5 - op2   
;           p4 - op1+op2
;           p3 - op1-op2
;           p2 - op1*op2
;           p1 - op1/op2(нацело)
;Exit:      None
;Expects:   ES = 0b800h
;           DRAW, READ, WRITE modules should be included
;           Cmd line has 2 arguments!(add assert maybe)
;Destroys:  AX, BX, CX, DX
;------------------------------------------------
Done            db 0ffh, '            a'  , 00dh
Dtwo            db 0ffh, '            b'  , 00dh
Dadd            db 0ffh, '           a+b', 00dh
Dsub            db 0ffh, '           a-b', 00dh
Dmul            db 0ffh, '           a*b', 00dh
Ddiv            db 0ffh, '           a/b', 00dh

Print_arithm    proc
                push bp
                mov bp, sp

                mov dx, 0706h
                mov ax, [bp+14]             ; print a
                mov cx, offset Done
                call Print_num

                mov dx, 1d06h
                mov ax, [bp+12]             ; print b
                mov cx, offset Dtwo
                call Print_num

                mov dx, 3306h
                mov ax, [bp+10]             ; print a+b
                mov cx, offset Dadd
                call Print_num

                mov dx, 070ch
                mov ax, [bp+8]              ; print a-b
                mov cx, offset Dsub
                call Print_num

                mov dx, 1d0ch
                mov ax, [bp+6]              ; print a*b
                mov cx, offset Dmul
                call Print_num

                mov dx, 330ch
                mov ax, [bp+4]              ; print a/b
                mov cx, offset Ddiv
                call Print_num

                pop bp
                retn 12
                endp
;------------------------------------------------
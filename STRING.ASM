INCLUDE DEF_STR.ASM

;------------------------------------------------
CHECK_DF        macro
                nop
                push ax
                lahf                        ; save flag reg to ax
                and ax, 0000010000000000b   ; get 10th byte aka DF
                cmp ax, 0
                pop ax
                nop
                endm
;------------------------------------------------

;------------------------------------------------
;Checks for \0
;------------------------------------------------
;Entry:     p1 - ptr
;Exit:      BX = 1 if == '\0' - changes
;           else don't change BX
;Expects:   
;Destroys:  BX
;------------------------------------------------
Check_NULL      proc
                push bp
                mov bp, sp

                push ax
                push si
                mov si, [bp+4]

                mov al, [si]
                cmp al, NULL
                je @@Equal
                jmp @@Not_equal

@@Equal:        mov bx, 1h
                jmp @@Finish

@@Not_equal:    jmp @@Finish

@@Finish:       pop si
                pop ax

                pop bp
                retn 2
                endp
;------------------------------------------------

;------------------------------------------------
; lodsw - reads one word of the string written in SI
;------------------------------------------------
;Entry:     SI - line start
;Exit:      AX - 2 bytes of the string
;           SI += 2
;Expects:   
;Destroys:  SI, AX
;------------------------------------------------
My_lodsw        proc
                mov al, [si]
                CHECK_DF
                
                je @@Inc                    ; dec 2
                sub si, 2

                jmp @@End                   ; inc 2
@@Inc:          add si, 2
@@End:          ret
                endp
;------------------------------------------------

;------------------------------------------------
; lodsb - reads one byte of the string written in SI
;------------------------------------------------
;Entry:     SI - line start
;Exit:      AL - 1 byte of the string
;           SI += 1
;Expects:   
;Destroys:  SI, AL
;------------------------------------------------
My_lodsb        proc
                mov al, [si]
                CHECK_DF
                
                je @@Inc                    ; dec
                dec si

                jmp @@End                   ; inc
@@Inc:          inc si
@@End:          ret
                endp
;------------------------------------------------

;------------------------------------------------
; stosb - write given byte in the following address
;------------------------------------------------
;Entry:     AL - one char
;Exit:      None
;Expects:   ES, DI are set  
;Destroys:  DI
;------------------------------------------------
My_stosb        proc
                mov byte ptr es:[di], al
                CHECK_DF
                
                je @@Inc                    ; dec
                dec di

                jmp @@End                   ; inc
@@Inc:          inc di
@@End:          ret
                endp
;------------------------------------------------

;------------------------------------------------
; stosw - write given word in the following address
;------------------------------------------------
;Entry:     AX - two chars
;Exit:      None
;Expects:   ES, DI are set  
;Destroys:  DI
;------------------------------------------------
My_stosw        proc
                mov word ptr es:[di], ax
                CHECK_DF
                
                je @@Inc                    ; dec 2
                sub di, 2

                jmp @@End                   ; inc 2
@@Inc:          add di, 2
@@End:          ret
                endp
;------------------------------------------------

;------------------------------------------------
; cmpsb - compares bytes
;------------------------------------------------
;Entry:         
;Exit:      None
;Expects:   ES, DI
;           DS, SI
;Destroys:  AX, DI, SI
;------------------------------------------------
My_cmpsb        proc
                mov al, es:[di]
                mov ah, ds:[si]

                CHECK_DF
                
                je @@Inc                    ; dec
                dec si
                dec di

                jmp @@End                   ; inc
@@Inc:          inc si
                inc di

@@End:          cmp al, ah
                ret
                endp
;------------------------------------------------

;------------------------------------------------
; cmpsw
;------------------------------------------------
;Entry:         
;Exit:      None
;Expects:   ES, DI
;           DS, SI
;Destroys:  AX, BX, DI, SI
;------------------------------------------------
My_cmpsw        proc
                mov ax, es:[di]
                mov bx, ds:[si]

                CHECK_DF
                
                je @@Inc                    ; dec
                sub si, 2
                sub di, 2

                jmp @@End                   ; inc
@@Inc:          add si, 2
                add di, 2

@@End:          cmp ax, bx
                ret
                endp
;------------------------------------------------

;------------------------------------------------
; movsb - moves byte from es:di to ds:si 
;------------------------------------------------
;Entry:     DI, SI
;Exit:      None
;Expects:   
;Destroys: DI, SI
;------------------------------------------------
My_movsb        proc
                push ax
                mov al, [si]
                mov byte ptr es:[di], al

                CHECK_DF
                
                je @@Inc                    ; dec
                dec si
                dec di

                jmp @@End                   ; inc
@@Inc:          inc si
                inc di

@@End:          
                pop ax
                ret
                endp
;------------------------------------------------

;------------------------------------------------
; movsw - moves word from ds:si to es:di
;------------------------------------------------
;Entry:     DI, SI
;Exit:      None
;Expects:   
;Destroys:  DI, SI
;------------------------------------------------
Movsw_reverse   proc
                push ax
                mov ax, es:[di]
                mov word ptr [si], ax

                ; CHECK_DF
                
                ; je @@Inc                    ; dec
                ; sub si, 2
                ; sub di, 2

;                 jmp @@End                   ; inc
@@Inc:          add si, 2
                add di, 2

@@End:          pop ax
                ret
                endp
;------------------------------------------------

;------------------------------------------------
; strlen - counts number of symbols until termination symbol
;------------------------------------------------
;Entry:     p1 - ptr to string in mem    
;Exit:      BX - string length 
;Expects:   
;Destroys:  AX, BX
;------------------------------------------------
strlen          proc
                push bp
                mov bp, sp
                
                push si
                mov si, [bp+4]
                mov ah, NULL                 ; set termination symbol
                
                xor bx, bx                  ; bx = 0

@@Next:         lodsb
                inc bx
                cmp al, ah
                
                jne @@Next

                dec bx
                pop si

                pop bp
                retn 2
                endp
;------------------------------------------------

;------------------------------------------------
; memset
;------------------------------------------------
;Entry:     p3 - void* dest
;           p2 - int ch
;           p1 - size_t count
;Exit:      DI - void *dest
;Expects:   
;Destroys:  ES, DI, AL, CX
;------------------------------------------------
memset          proc
                push bp
                mov bp, sp

                push ds
                pop es

                mov cx, [bp+4]              ; cx = count
                mov al, [bp+6]              ; al = ch
                mov di, [bp+8]              ; di = dest

@@Next:         stosb
                loop @@Next

                mov di, [bp+8]              ; di = dest
                
                pop bp
                retn 6
                endp
;------------------------------------------------


;------------------------------------------------
; memchr - find char in given arr
;------------------------------------------------
;Entry:     p3 - void* dest
;           p2 - int ch
;           p1 - size_t count
;Exit:      SI - void* of given char
;Expects:   
;Destroys:  AX, CX, SI
;------------------------------------------------
memchr          proc
                push bp
                mov bp, sp

                mov cx, [bp+4]              ; cx = count
                mov ah, [bp+6]              ; ah = ch
                mov si, [bp+8]              ; di = dest

@@Next:         lodsb
                cmp ah, al
                je @@End

                loop @@Next
                mov si, 0h

@@End:          dec si
                pop bp
                retn 6
                endp
;------------------------------------------------

;------------------------------------------------
; strchr - find char in given null terminated str
;------------------------------------------------
;Entry:     p2 - void* dest
;           p1 - int ch
;Exit:      SI - void* of given char
;Expects:   DS - is set
;Destroys:  AX, CX, BX, SI
;------------------------------------------------
strchr          proc
                push bp
                mov bp, sp

                xor bx, bx                  ; use as transfer for si

                mov cl, NULL                ; set null terminated byte

                mov ah, [bp+4]              ; ah = ch
                mov si, [bp+6]              ; di = dest

@@Next:         lodsb
                cmp al, cl                  ; if (line[i] == '\0')
                je @@Line_end               ;        break;

                cmp ah, al                  ; if (line[i] == ch)
                je @@Finish                 ;        break;

                jmp @@Next

@@Line_end:     cmp ah, al                  ; if (ch != '\0')
                jne @@End                   ;       res == null

@@Finish:       mov bx, si
                dec bx

@@End:          mov si, bx
                pop bp
                retn 4
                endp
;------------------------------------------------

;------------------------------------------------
; memcpy - writes p1 symbols
;------------------------------------------------
;Entry:     p3  - dest ptr
;           p2  - src  ptr
;           p1  - max number of characters
;Exit:      None
;Expects:   
;Destroys:  SI, ES, DI, CX
;------------------------------------------------
; memcpy          proc
;                 push bp
;                 mov bp, sp
                
;                 push ds
;                 pop es

;                 mov di, [bp+8]                  ; set dest ptr
;                 mov si, [bp+6]                  ; set src  ptr

;                 mov cx, [bp+4]                  ; set cx

;                 rep movsb 

;                 pop bp
;                 retn 6
;                 endp
;------------------------------------------------

;------------------------------------------------
; Memcpy - writes p1 symbols
;------------------------------------------------
;Entry:     si - address of src copying
;           bx - segment of dst copying
;           di - address of dst copying
;           cx - number of copying buf
;Exit:      None
;Expects:   
;Destroys:  SI, ES, DI, CX
;------------------------------------------------
MemCpy          proc
                push es ds si di

                mov ds, ax
                mov es, bx
                cld		                ; DF = 0 <-- setting increasing mode
                rep movsb               ; while (cx--) {es:[di++] = ds:[si++]}

                pop di si ds es
                ret
                endp
;------------------------------------------------

;------------------------------------------------
; strcpy - writes strlen+1 of src to dest
;------------------------------------------------
;Entry:     p2  - dest ptr
;           p1  - src  ptr
;Exit:      None
;Expects:   
;Destroys:  SI, ES, DI, CX, BX
;------------------------------------------------
strcpy          proc
                push bp
                mov bp, sp
                
                push ds
                pop es

                mov di, [bp+6]                  ; set dest ptr
                mov si, [bp+4]                  ; set src  ptr

                push si
                call strlen
                mov cx, bx
                inc cx                          ; count src length

                rep movsb 

                pop bp
                retn 4
                endp
;------------------------------------------------

;------------------------------------------------
; strncpy - like memcpy, but 
;------------------------------------------------
;Entry:     p3  - dest ptr
;           p2  - src  ptr
;           p1  - max number of characters
;Exit:      None
;Expects:   
;Destroys:  SI, ES, DI, CX
;------------------------------------------------
strncpy         proc
                push bp
                mov bp, sp
                
                push ds
                pop es

                mov di, [bp+8]                  ; set dest ptr
                mov si, [bp+6]                  ; set src  ptr

                mov cx, [bp+4]                  ; set cx

                push si
                call strlen
                inc bx                          ; bx = strlen+1

                cmp cx, bx
                ja @@Draw_at_the_end
                jmp @@Normal

@@Draw_at_the_end:
                push cx
                push bx

                mov cx, bx                      ; write main part
                rep movsb

                pop bx
                pop cx

                sub cx, bx                      
                push di                         ; dest
                mov bx, NULL                    
                push bx                         ; symbol
                push cx                         ; count
                call memset                     ; write nulls
                
                jmp @@Finish                

@@Normal:       rep movsb 

@@Finish:       pop bp
                retn 6
                endp
;------------------------------------------------

;------------------------------------------------
; memcmp
;------------------------------------------------
;Entry:     p3  - lhs second object to compare
;           p2  - rhs first object to compare
;           p1  - count number of bytes to examine
;Exit:      AX  - signed value that stands for cmp result
;Expects:   
;Destroys: 
;------------------------------------------------
memcmp          proc
                push bp
                mov bp, sp

                push ds
                pop es

                mov si, [bp+8]                  ; lhs set dest ptr
                mov di, [bp+6]                  ; src set src  ptr
                mov cx, [bp+4]

                repe cmpsb 
                lahf                            ; save flags to ax

                cmp cx, 0
                je @@Zero

                and ax, 0000000010000000b       ; get 7th byte aka ZF
                cmp ax, 0
                je @@Positive
                jmp @@Negative                  ; get flags and get the value

@@Positive:     mov ax, 1h
                jmp @@End

@@Negative:     mov ax, 0FFFFh
                jmp @@End

@@Zero:         mov ax, 0
                jmp @@End

@@End:          pop bp
                retn 6
                endp
;------------------------------------------------

;------------------------------------------------
; strcmp
;------------------------------------------------
;Entry:     p2  - lhs second object to compare
;           p1  - rhs first object to compare
;Exit:      AX  - signed value that stands for cmp result
;Expects:   
;Destroys: 
;------------------------------------------------
strcmp          proc
                push bp
                mov bp, sp

                push ds
                pop es

                mov si, [bp+6]                  ; lhs set dest ptr
                mov di, [bp+4]                  ; src set src  ptr
                ; mov cx, [bp+4]

@@Next:
                cmpsb 
                lahf                            ; save flags to ax

                xor bx, bx                      ; set bx = 0 to check for '\0' again

                mov cx, si
                dec cx
                push cx
                call Check_NULL                 ; check lhs for '\0'

                mov cx, di
                dec cx
                push cx
                call Check_NULL                 ; check rhs for '\0'

                cmp bx, 0                       ; if (lhs[i]!= '\0' && rhs[i]!= '\0')
                je @@Next

                mov cl, 6                       
                call Check_flags
                cmp ch, 0h                      ; check ZF zero flag
                
                jne @@Zero

                mov cl, 7                       
                call Check_flags
                cmp ch, 0h                      ; check SF sign flag

                je @@Positive
                jmp @@Negative                  ; get flags and get the value

@@Positive:     mov ax, 1
                jmp @@End

@@Negative:     mov ax, 0FFFFh
                jmp @@End

@@Zero:         mov ax, 0
                jmp @@End

@@End:          pop bp
                retn 4
                endp
;------------------------------------------------

;------------------------------------------------
;------------------------------------------------
;Entry:     
;Exit:      None
;Expects:   
;Destroys: 
;------------------------------------------------
; My_        
;                 proc
;                 push bp
;                 mov bp, sp
;                 pop bp
;                 ret
;                 endp
;------------------------------------------------
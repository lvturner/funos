    BITS 16
start: 
    mov ax, 07C0h  ; Set up 4K stack after this boot loader
    add ax, 288    ; (4096 + 512) / 16 bytes per para
    mov ss, ax
    mov sp, 4096
  
    mov ax, 07C0h
    mov ds, ax

    call change_bg_color

    mov si, text_string ; Put string position into SI 
    call print_string   ; Call string printing routine
    
    jmp $ ; infinite loop

    text_string db 'Welcome to FunOS', 0

change_bg_color:
    mov bl, 4 
    mov ah, 0Bh
    int 10h
    ret

print_string:
    mov ah, 0Eh

.repeat 
    lodsb
    cmp al, 0
    je .done
    int 10h
    jmp .repeat

.done:
    ret
    
    times 510-($-$$) db 0
    dw 0xAA55

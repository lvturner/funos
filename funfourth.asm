    BITS 16
start: 
    mov ax, 07C0h  ; Set up 4K stack after this boot loader
    add ax, 288    ; (4096 + 512) / 16 bytes per para
    mov ss, ax
    mov sp, 4096
  
    mov ax, 07C0h
    mov ds, ax

    call set_text_mode
    call box_cursor
    call change_bg_color
    call clear_screen

    mov bh, 0
    mov dh, 2 
    mov dl, 5 
    call move_cursor

    mov si, text_string_one ; Put string position into SI 
    call print_string   ; Call string printing routine
    
    mov dh, 3 
    mov dl, 5 
    call move_cursor

    mov si, text_string_two
    call print_string

    mov dh, 4
    mov dl, 5
    call move_cursor

    mov si, text_string_one
    call print_string

    mov dh, 0x17
    mov dl, 0
    call move_cursor

    mov si, prompt_string
    call print_string

    call get_input
    
    jmp $ ; infinite loop

    text_string_one db   '                  ' , 0
    text_string_two db   ' Welcome to FunOS ' , 0
    prompt_string db     '[FunOS]:/>', 0

get_input:
    mov ah, 0
    int 16h
    mov ah, 0Eh
    int 10h
    jmp get_input
    

set_text_mode:
    mov al, 03h
    mov ah, 0
    int 10h
    ret

change_bg_color:
    mov bl, 4 
    mov ah, 0Bh
    int 10h
    ret

box_cursor:
    mov ch, 0
    mov cl, 7
    mov ah, 1
    int 10h
    ret

move_cursor:
    mov ah, 02
    int 10h
    ret

clear_screen:     ; The bios probably supports this, but, whatever it's fun!
    mov bh, 0
    mov dh, 0
    mov dl, 0 
    call move_cursor
    mov ah, 0Eh
    mov bx, 0
    
.repeat_cls
    mov al, '#'
    cmp bx, 0x6E0
    je .done_cls
    inc bx
    int 10h
    jmp .repeat_cls

.done_cls
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

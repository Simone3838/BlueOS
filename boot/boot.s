; boot/boot.s
BITS 16
org 0x7c00

start:
    ; Set up stack
    cli
    xor ax, ax
    mov ds, ax
    mov ss, ax
    mov sp, 0x7c00
    sti

    ; Load the kernel
    mov si, boot_msg
    call print_string

    ; Load kernel to 0x1000
    mov bx, 0x1000
    mov dh, 1

load_kernel:
    mov ah, 0x02
    mov al, 1
    mov ch, 0
    mov cl, 2
    mov dl, 0
    int 0x13
    jc load_kernel

    ; Jump to kernel
    jmp 0x1000:0x0000

print_string:
    mov ah, 0x0e
.print_next_char:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .print_next_char
.done:
    ret

boot_msg db 'Loading BlueOS...', 0

times 510-($-$$) db 0
dw 0xaa55

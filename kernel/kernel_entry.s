; kernel/kernel_entry.s
[BITS 32]
[extern kernel_main]

section .text
global start
start:
    ; Set up 32-bit protected mode
    cli
    cld
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Set up the stack
    mov ss, ax
    mov esp, 0x9fbff

    ; Call the kernel main function
    call kernel_main

hang:
    hlt
    jmp hang

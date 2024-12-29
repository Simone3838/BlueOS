# Makefile

ISO = BlueOS.iso
BOOT = boot/boot.s
KERNEL_C = kernel/kernel.c
KERNEL_ASM = kernel/kernel_entry.s
KERNEL_BIN = kernel.bin

CC = i686-elf-gcc
LD = i686-elf-ld
AS = nasm

CFLAGS = -ffreestanding -O2 -Wall -Wextra
LDFLAGS = -nostdlib -Ttext 0x1000
ASFLAGS = -f elf

all: $(ISO)

$(ISO): boot/boot.bin kernel.bin
    mkdir -p isodir/boot/grub
    cp boot/boot.bin isodir/boot/
    cp kernel.bin isodir/boot/
    echo 'set timeout=0' > isodir/boot/grub/grub.cfg
    echo 'set default=0' >> isodir/boot/grub/grub.cfg
    echo 'menuentry "BlueOS" {' >> isodir/boot/grub/grub.cfg
    echo '  multiboot /boot/kernel.bin' >> isodir/boot/grub/grub.cfg
    echo '}' >> isodir/boot/grub/grub.cfg
    grub-mkrescue -o $(ISO) isodir

boot/boot.bin: $(BOOT)
    $(AS) $(BOOT) -o boot/boot.bin

kernel.bin: $(KERNEL_C) $(KERNEL_ASM)
    $(AS) $(ASFLAGS) $(KERNEL_ASM) -o kernel_entry.o
    $(CC) $(CFLAGS) -c $(KERNEL_C) -o kernel.o
    $(LD) $(LDFLAGS) kernel_entry.o kernel.o -o kernel.bin

clean:
    rm -rf *.o *.bin isodir $(ISO)

.PHONY: all clean

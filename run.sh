#!/bin/bash
set -xue

#QUEMU file path
QEMU=qemu-system-riscv32

#GCC COMPILER AND FLAGS
CC=clang
CFLAGS="-O2 -g3 -Wall -Wextra --target=riscv32-unknown-elf -fuse-ld=lld -fno-stack-protector -ffreestanding -nostdlib"

# Build the kernel
$CC $CFLAGS -Wl,-Tkernel.ld -Wl,-Map=kernel.map -o kernel.elf \
    kernel.c

#Start QUEMU
$QEMU -machine virt -bios default -nographic -serial mon:stdio --no-reboot

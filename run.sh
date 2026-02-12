#!/bin/bash
set -xue

#QUEMU file path
QEMU=qemu-system-riscv32

#Start QUEMU
$QEMU -machine virt -bios default -nographic -serial mon:stdio --no-reboot

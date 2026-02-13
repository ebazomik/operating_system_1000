/* 
 * RISC-V KERNEL LINKER SCRIPT
 * Platform: QEMU virt (OpenSBI loads kernel at 0x80200000)
 * 
 * Defines memory layout for bare metal kernel.
 * Without this: wrong addresses → no boot, no stack, garbage .bss
 * 
 * Symbols used by boot.S:
 *   __bss, __bss_end    → zero out .bss section
 *   __stack_top         → initialize stack pointer
 */

ENTRY(boot)													/* Entry point boot in .text.boot */

SECTIONS {

	. = 0x80200000										/* Load address, openSBI jump here */ 

	.text:{
		KEEP(*(.text.boot));						/* boot.s: first instructions (must be at 0x80200000) */
		*(.text .text.*);								/* Other code: main.c, ecc */
	}

	.rodata: ALIGN(4) {								/* Read-only data (strings, const, ecc) */
		*(.rodata .rodata.*);						/* ALIGN(4) Move cursor to next address divisible by 4 */
	}

	.data: ALIGN(4) {									/* Initialize data (int n = 42;) */
		*(.data .data.*);
	}

	.bss: ALIGN(4) {									/* Not initialized data (int n;), zero filled ad boot */
		__bss = .;											/* Start of bss */
		*(.bss .bss.* .sbss .sbss.*);
		__bss_end = .;									/* End of bss */
	}

	. = ALIGN(4);											/* Align stack to 4 bytes */
	. += 128 * 1024;									/* Set 128kb for stack */
	__stack_top = .;									/* Stack top, stack grow down */
}

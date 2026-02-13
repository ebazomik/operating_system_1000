typedef unsigned char uint8_t;
typedef unsigned char uint32_t;
typedef uint32_t size_t;

// Import labels from linker.
// Magic trick for mantain the adress of labels is define 
// arrays with [] brackets.
// When we use this syntax char __bss[], the __bss is already the address!
extern char __bss[], __bss_end[], __stack_top[];

// Simple implementation of memset.
// Set every __bss bytes to zero, in kernel_main use
// size_t cast for convert address in numbers and calculate the dimension
// of __bss section.
// __bss_end - __bss
void *memset(void *buf, char c, size_t n){
	unit8_t *p = (uint8_t *)buf;
	while(n--){
		*p = c;
		*p++;
	}
	return buf;
}

// Kernel main loop, after memset
void kernel_main(void){
	memset(__bss, 0, (size_t) __bss_end - (size_t) __bss);

	while(1){}
}

// Add boot in special section called .text.boot defined inside linker.
// And prevent compliler to create prologue and epilogue, we set the stack.
__attribute__((section(".text.boot")));
__attribute__((naked));

void boot(void){
	// (__stack_top) value defined in linker => passed throught C and land in asm inline
	// for set sp register (stack pointer).
	// Then jump (without return) in kernel_main function.
	__asm__ __volatile__(
				"mv sp, %[stack_top]\n"
				"j kernel_main\n"
				:
				: [stack_top] "r" (__stack_top)
			);
}

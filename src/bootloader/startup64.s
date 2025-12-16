.section .text
.global _start
_start:
    /* Vector table emulation - QEMU jumps here from 0x0 */
    ldr x30, =stack_top
    mov sp, x30
    bl kernel_main 
    b .

.section .bss
    .space 0x1000  /* 4kB stack */
stack_top:

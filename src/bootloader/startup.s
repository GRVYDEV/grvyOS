.section .text
.global _start
_start:
    /* Vector table emulation - QEMU jumps here from 0x0 */
    ldr sp, =stack_top
    bl zig_entry
    b .

.section .bss
    .space 0x1000  /* 4kB stack */
stack_top:

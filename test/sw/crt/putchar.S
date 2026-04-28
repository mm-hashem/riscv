.globl putchar
.extern _mmio_print
.text
.align 2
putchar:
    la t0, _mmio_print
    sb a0, 0(t0)
    ret
.end
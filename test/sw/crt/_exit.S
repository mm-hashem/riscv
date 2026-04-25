.text
.globl _exit
.extern _mmio_tohost
.align 2
_exit:
    la t0, _mmio_tohost
    sw a0, 0(t0)
.end
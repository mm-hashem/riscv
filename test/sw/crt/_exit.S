#include "test_headers.h"

.text
.globl _exit
.extern _mmio_tohost
.align 2
_exit:
    la t0, _mmio_tohost
    ST_INS a0, 0(t0)
.end
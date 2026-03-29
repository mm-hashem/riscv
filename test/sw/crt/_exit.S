#include "test_headers.h"

.section .text._exit
.globl _exit
.align 2
_exit:
    mv t0, zero
    la t0, _tohost
    ST_INS a0, 0(t0)
.end
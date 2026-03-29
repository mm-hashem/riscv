#include "test_headers.h"

.section .text._start
.globl _start
.globl __global_pointer$
.globl _stack_top
.align 2
_start:
    .option push
    .option norelax
    la gp, __global_pointer$
    .option pop

    la sp, _stack_top
    
    addi sp, sp, -8
    ST_INS ra, 0(sp)

    call main

    LD_INS ra, 0(sp);
    addi sp, sp, -8;
    
    call _exit
.end
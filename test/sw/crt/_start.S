#include "test_headers.h"

.section .text._start
.globl _start
.globl __global_pointer$
.globl _stack_top
.align 2
_start:
    .option push
    .option norelax
    la gp, __global_pointer$;
    .option pop

    la sp, _stack_top;
    
    call main;
    
    call _exit;
.end
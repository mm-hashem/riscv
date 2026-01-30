# Fixed-point format: Q3.28, 1 sign bit, 3 integer bits, 28 fraction bits
# Hex values are generated using MATLAB with Fixed-Point Designer Toolbox

.equ _PI,    0x3243f6a8 # pi
.equ _2PI,   0x6487ed51 # 2pi
.equ _PI_2,  0x1921fb54 # pi/2
.equ _nPI_2, 0xe6de04ac # -pi/2 change to pi/2
.equ _3PI_2, 0x4b65f1fc # 3pi/2
.equ N,      16
.equ K,      0x09b74eda

.data
.align 2
atan: .word 0x0c90fdaa, 0x076b19c1, 0x03eb6ebf, 0x01fd5ba9, 0x00ffaadd, 0x007ff556, 0x003ffeaa, 0x001fffd5, 0x000ffffa, 0x0007ffff, 0x0003ffff, 0x0001ffff, 0x0000ffff, 0x00007fff, 0x00003fff, 0x00001fff

.globl main
.text
    # a0 input angle & angle accumulator
    # t0 loading variable & cos old value
    # t1 loop counter, i
    # a3 loop limit
    # t4 x cos
    # t5 y sin
    # t6 lut address

cordic:
    li t0, K
    li t1, 0
    li a3, N
    li t4, K
    li t5, 0
    la t6, atan

.loop:
    beq t1, a3, .return

    sra t3, t5, t1
    sra t2, t0, t1
    lw  a4, 0(t6)

    bgez a0, .calc
    neg t3, t3
    neg t2, t2
    neg a4, a4

.calc:
    sub t4, t4, t3
    add t5, t5, t2
    sub a0, a0, a4

    mv   t0, t4
    addi t1, t1, 1
    addi t6, t6, 4
    j .loop

.return:
    mv a0, t4
    mv a1, t5
    ret
    
.section .text.start
main:
    li   a0, 0x0c90fdaa
    call cordic
    ecall
.end

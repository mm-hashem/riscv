# testing Zba extension
.text
.section .text.main
.align 2
.globl main
main:
	li a0, 0x0123456789ABCDEF
	li a1, 0xFEDCBA9876543210

	sh1add a2, a0, a1
	sh2add a3, a0, a1
	sh3add a4, a0, a1

	add.uw    a5, a0, a1
	sh1add.uw a6, a0, a1
	sh2add.uw a7, a0, a1
	sh3add.uw a2, a0, a1

	slli.uw a3, a0, 5

	li a5, 2040
	li a4, 1
	sw a4, 0(a5)
.end

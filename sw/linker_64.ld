OUTPUT_FORMAT("elf64-littleriscv", "elf64-littleriscv", "elf64-littleriscv")
OUTPUT_ARCH(riscv)
ENTRY(main)

MEMORY
{
    IMEM (rx) : ORIGIN = 0x00000000, LENGTH = 1K
    DMEM (wx) : ORIGIN = 0x00000400, LENGTH = 1K
}

SECTIONS
{
    .text : {
        *(.text.main)
        *(.text*)
        
    } > IMEM

    .data : {
        *(.section .rodata)
        KEEP(*(.data*))        
    } > DMEM
}
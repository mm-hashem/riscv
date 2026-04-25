OUTPUT_FORMAT("elf64-littleriscv", "elf64-littleriscv", "elf64-littleriscv")
OUTPUT_ARCH(riscv)
ENTRY(_start)

/*  Note:
    The design is modified Harvard architecture.
    Data, including read-only data, and instructions
    are in different memories, but with unified, linear flat address space.
*/

MEMORY
{
    IMEM (rx) : ORIGIN = 0x00000000, LENGTH = 9K
    DMEM (rw) : ORIGIN = 0x00002400, LENGTH = 2K
}

SECTIONS
{
    .text : {
        . = ALIGN(4);
        *(.text._start)
        *(.text*)
    } > IMEM

    ASSERT(SIZEOF(.text) <= LENGTH(IMEM), "IMEM overflow")

    .rodata : {
        . = ALIGN(8); /**/
        *(.rodata*)
        . = ALIGN(8); /**/
    } > DMEM

    .data : {
        . = ALIGN(8); /**/
        _sdata = .;
        *(.data*)
        . = ALIGN(8); /**/
    } > DMEM

    __global_pointer$ = ALIGN((_sdata + _edata) / 2, 16);

    .bss : {
        . = ALIGN(8); /**/
        *(.bss*)
        . = ALIGN(8); /**/
        *(COMMON)
        . = ALIGN(8); /**/
        _edata = .;
    } > DMEM

    .stack : {
        . = ALIGN(16);
        . += 0x00000400;
        _stack_top = ALIGN(., 16);
    } > DMEM

    ASSERT(_edata < ORIGIN(DMEM) + 0x00000400, "BSS overflow into stack")

    /***** MMIO Section *****/

    . = ORIGIN(DMEM) + LENGTH(DMEM);
    _smmio = .;

    _mmio_tohost = _smmio;
    . += 8; /**/

    _mmio_print = .;
    . += 8; /**/

    _emmio = .;
}
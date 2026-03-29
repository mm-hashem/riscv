OUTPUT_FORMAT("elf64-littleriscv", "elf64-littleriscv", "elf64-littleriscv")
OUTPUT_ARCH(riscv)
ENTRY(_start)

/*  Note:
    The design is pure Harvard Architecture.
    Data, including read-only data, and instructions
    are in different memories.
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
        *(.text._exit)
        *(.text.main)
        *(.text*)
    } > IMEM

    ASSERT(SIZEOF(.text) <= LENGTH(IMEM), "IMEM overflow")

    .rodata : {
        . = ALIGN(8); /**/
        *(.rodata*)
    } > DMEM

    .data : {
        . = ALIGN(8); /**/
        _data_start = .;
        *(.data*)
    } > DMEM

    __global_pointer$ = ALIGN((_data_start + _data_end) / 2, 16);

    .bss : {
        . = ALIGN(8); /**/
        *(.bss*)
        *(COMMON)
        _data_end = .;
    } > DMEM

    . = ALIGN(16);
    _stack_top = ORIGIN(DMEM) + LENGTH(DMEM);

    ASSERT(_data_end < ORIGIN(DMEM) + 0x00000400, "BSS overflow into stack")

    _tohost = _stack_top;
    . = _stack_top + 8;
}
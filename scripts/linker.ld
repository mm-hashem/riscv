ENTRY(main)

MEMORY
{
    IMEM (rx) : ORIGIN = 0x00000000, LENGTH = 1K
    DMEM (wx) : ORIGIN = 0x00000500, LENGTH = 1K
}

SECTIONS
{
    .text : {
        *(.text.start)
        *(.text*)
    } > IMEM

    .data : {
        *(.data*)
    } > DMEM

    .bss : {
        *(.bss*)
        *(COMMON)
    } > DMEM
}
#ifndef TEST_HEADERS_H
#define TEST_HEADERS_H

#if XLEN == 64
    #define LD_INS ld
    #define ST_INS sd
    #define ALIGNB 3
    #define MWORD dword
#else
    #define LD_INS lw
    #define ST_INS sw
    #define ALIGNB 2
    #define MWORD word
#endif

// Store ra and sp register in the .data section for riscv-tests
#define STORE_RA_DATA \
    .data;               \
    .align ALIGNB;       \
    RRA: .MWORD 0;       \
    .previous;           \
    la x31, RRA;         \
    ST_INS ra, 0(x31);

// Load ra and sp register from the .data section for riscv-tests
#define LOAD_RA_DATA \
    la x31, RRA;        \
    LD_INS ra, 0(x31);

#endif // TEST_HEADERS_H
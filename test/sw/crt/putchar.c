#include "crt.h"

extern unsigned long _mmio_print;

void putchar(const char c) {
    *(volatile char*)&_mmio_print = c;
}
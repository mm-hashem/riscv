#include "crt.h"

void puts(const char *c) {
    
    if (!c) return;

    while(*c != 0) {
        putchar(*c);
        c++;
    }
    
    putchar('\n');
}
#include "crt.h"
#include <stdarg.h>

#define GET_NIBB(n, var) ((var >> (n * 4)) & 0x0F)

#define NIBBS 8

typedef enum : char {
    DEFAULT,
    ZEROPADD
} flag_e;

typedef enum : char {
    LHEX, UHEX
} type_e;
    
void mini_printf(const char *fmt, ...) {
    va_list args;
    va_start(args, fmt);

    if (!fmt) return;

    flag_e flag;
    type_e type;
    
    while (*fmt != 0) {
        if (*fmt == '%') {
            fmt++;

            // Flags processing
            if (*fmt == '0') {
                flag = ZEROPADD;
                fmt++;
            } else
                flag = DEFAULT;

            
            // Types processing
            if (*fmt == 'x')
                type = LHEX;
            else if (*fmt == 'X')
                type = UHEX;
            else break;
            
            int i = NIBBS - 1;
            int var = va_arg(args, int);
            bool firstNum = false;
            unsigned char char_pr;

/*             if (var == 0) {
                putchar('0');
                fmt++;
                continue;
            } */

            while (i >= 0) {
                unsigned char nibble = GET_NIBB(i, var);
                
                i--;
                
                if (nibble != 0) firstNum = true;
                
                if (!(flag == ZEROPADD) && !firstNum) continue;
                
                if (type == LHEX) {
                    if (nibble < 10) char_pr = nibble + '0';
                    else             char_pr = nibble + 87;
                } else if (type == UHEX) {
                    if (nibble < 10) char_pr = nibble + '0';
                    else             char_pr = nibble + 55;
                }
                
                // Send to MMIO
                putchar(char_pr);
            }

        } else
            putchar(*fmt);

        fmt++;
    }

    va_end(args);
}
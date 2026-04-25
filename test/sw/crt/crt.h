#ifndef CRT_H
#define CRT_H

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wbuiltin-declaration-mismatch"

void putchar     (const char  c);
void puts        (const char *c);
void mini_printf (const char *fmt, ...);

#pragma GCC diagnostic pop

#endif
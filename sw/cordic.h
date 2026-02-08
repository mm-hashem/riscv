#ifndef CORDIC_H
#define CORDIC_H

// Fixed-point format: Q3.28, 1 sign bit, 3 integer bits, 28 fraction bits
// Hex values are generated using MATLAB with Fixed-Point Designer Toolbox
#define _PI    0x3243f6a8
#define _PI_2  (_PI >> 1)
#define _PI_4  (_PI >> 2)
#define _2PI   (_PI << 1)
#define _3PI_2 (3*_PI_2)
#define N      16         // Number of itereations and LUT values
#define K      0x09b74eda // The cosines multiplication constant
#define TOHOST 0x000007F8

void cordic(int32_t angle, int32_t* arr);
void main(void) __attribute__((section(".text.main")));

#endif // CORDIC_H
#ifndef CORDIC_H
#define CORDIC_H

// Fixed-point format: Q3.28, 1 sign bit, 3 integer bits, 28 fraction bits
// Hex values are generated using MATLAB with Fixed-Point Designer Toolbox
#define _PI    0x3243f6a8
#define _PI_2  (_PI >> 1)
#define _PI_4  (_PI >> 2)
#define _2PI   (_PI << 1)
#define _3PI_2 (3*_PI_2)
#define N      16                 // Number of itereations and LUT values
#define K      0x0000000009b74eda // The cosines multiplication constant

void cordic(long angle, long* arr);

#endif // CORDIC_H
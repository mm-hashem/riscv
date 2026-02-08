#include <stdint.h>
#include "cordic.h"

// Fixed-point format: Q3.28, 1 sign bit, 3 integer bits, 28 fraction bits
// Values are generated using MATLAB with Fixed-Point Designer Toolbox
static const int32_t atan_lut[] = {0x0c90fdaa, 0x076b19c1, 0x03eb6ebf, 0x01fd5ba9, 0x00ffaadd, 0x007ff556, 0x003ffeaa, 0x001fffd5, 0x000ffffa, 0x0007ffff, 0x0003ffff, 0x0001ffff, 0x0000ffff, 0x00007fff, 0x00003fff, 0x00001fff};

/*
    Input angle in Q3.28 format,
    angle range: [-2*PI, 2*PI]
    Output arr[0] = cos(angle) in Q3.28 format
           arr[1] = sin(angle) in Q3.28 format
*/
void cordic(int32_t angle, int32_t* arr) {
    uint32_t i;
    int32_t dir = 1;
    int32_t sign_cos = 1;
    int32_t x_cos_old = K;
    int32_t x_cos = K;
    int32_t y_sin = 0;

    // Normalizing angle to range [-PI/2, 2PI]
    if (angle < -_PI_2) angle += _2PI;

    // Normalizing angle to CORDIC range [-PI/2, PI/2]
    if (angle > _3PI_2) angle -= _2PI;
    else if (angle > _PI_2) {
        angle = _PI - angle;
        sign_cos = -1;
    }
    
    for (i = 0; i < N; i++) {
        dir = angle < 0 ? -1 : 0;

        x_cos  = x_cos - (((y_sin     >> i) ^ dir) - dir);
        y_sin  = y_sin + (((x_cos_old >> i) ^ dir) - dir);
        angle -=          ((atan_lut[i]     ^ dir) - dir);

        x_cos_old = x_cos;
    }

    arr[0] = (x_cos ^ sign_cos) - sign_cos;
    arr[1] = y_sin;
}

void main(void) {
    int32_t arr[2];

    /* This function tests multiple arithmetic, memory, and branching operations. */
    cordic(0x0c90fdaa, arr); // test for 45 degree. result should be approx. 0b505ab6

    /* Zba Test */
    asm volatile ("li a0, 0x0123456789ABCDEF");
	asm volatile ("li a1, 0xFEDCBA9876543210");

	asm volatile ("sh1add a2, a0, a1");
	asm volatile ("sh2add a3, a0, a1");
	asm volatile ("sh3add a4, a0, a1");

	asm volatile ("add.uw    a5, a0, a1");
	asm volatile ("sh1add.uw a6, a0, a1");
	asm volatile ("sh2add.uw a7, a0, a1");
	asm volatile ("sh3add.uw a2, a0, a1");
    
	asm volatile ("slli.uw a3, a0, 5");

    /* Terminate simulation */
    *(volatile uint32_t*)TOHOST = 1;
}
#include "cordic.h"

// Fixed-point format: Q3.28, 1 sign bit, 3 integer bits, 28 fraction bits
// Values are generated using MATLAB with Fixed-Point Designer Toolbox
static const int atan_lut[] = {
    0x0c90fdaa, 0x076b19c1, 0x03eb6ebf, 0x01fd5ba9,
    0x00ffaadd, 0x007ff556, 0x003ffeaa, 0x001fffd5,
    0x000ffffa, 0x0007ffff, 0x0003ffff, 0x0001ffff,
    0x0000ffff, 0x00007fff, 0x00003fff, 0x00001fff
};

/*
    Input angle in Q3.28 format,
    angle range: [-2*PI, 2*PI]
    Output arr[0] = cos(angle) in Q3.28 format
           arr[1] = sin(angle) in Q3.28 format
*/
void cordic(int angle, int* arr) {
    int i,
        dir       = 1,
        sign_cos  = 1,
        x_cos_old = K,
        x_cos     = K,
        y_sin     = 0;

    // Normalizing angle to range [-PI/2, 2PI]
    if (angle < -_PI_2) angle += _2PI;

    // Normalizing angle to CORDIC range [-PI/2, PI/2]
    if (angle > _3PI_2)
        angle -= _2PI;
    else if (angle > _PI_2) {
        angle    = _PI - angle;
        sign_cos = -1;
    }
    
    for (i = 0; i < N; i++) {
        dir = angle < 0 ? -1 : 0;
        
        x_cos  = x_cos - (((y_sin     >> i) ^ dir) - dir);
        y_sin  = y_sin + (((x_cos_old >> i) ^ dir) - dir);
        angle -=          ((atan_lut[i]     ^ dir) - dir);
        
/*      dir = angle < 0 ? -1 : 1;

        x_cos  = x_cos - dir * (y_sin     >> i);
        y_sin  = y_sin + dir * (x_cos_old >> i);
        angle -=         dir * atan_lut[i]; */

        x_cos_old = x_cos;
    }

    arr[0] = (x_cos ^ sign_cos) - sign_cos;
    arr[1] = y_sin;
}

int main(void) {
    int arr[2];

    /* This function tests multiple arithmetic, memory, and branching operations. */
    cordic(0x0c90fdaa, arr); // test 45*. result should be approx. 0b505ab6
    return -1;
}
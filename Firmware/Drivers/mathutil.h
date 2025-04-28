#ifndef MATHUTIL_H
#define MATHUTIL_H

#include <stdint.h>

int16_t floatToFixed(float a, int precision);
float fixedToFloat(int32_t a, int precision);
void printDouble(double a);

#endif

#include "mathutil.h"

int16_t floatToFixed(float a, int precision) {
    return (int16_t)(a * (1 << precision));
}

float fixedToFloat(int32_t a, int precision) {
    return ((float)a) / (1 << precision);
}

void printDouble(double a) {
// Credit : To-do, off some xilinx forum
    long int fix_part = (long int) a;
    long int frac_part = (long int) (a*1000.0 - fix_part*1000);
    long int dif = (long int) (1000.0-frac_part);
    xil_printf("%d.", fix_part);

    if(dif>900) {
        xil_printf("0");
    }

    xil_printf("%d\r\n", frac_part);
}
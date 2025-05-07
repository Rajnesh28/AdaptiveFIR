#include "FIR.h"
#include "mathutil.h"
#include "xil_printf.h"
#include <stdio.h>

int main() {
    FIR_SetTapCount(7);
    FIR_SetCoefficientWriteEnable();

    float a;
    int16_t a_10;

    for (int i = 0; i < 7; i++) {
        a = 0.7f - 0.1f * i;
        a_10 = floatToFixed(a, 10); // Use Q6.10
        FIR_SendCoefficientData((u32)a_10);
    }

    FIR_ClearCoefficientWriteEnable();

    FIR_StartCompute();


    for (int i = 0; i < 7; i++) {
        a = 0.7f - 0.1f * i;
        a_10 = floatToFixed(a, 10); // Use Q6.10
    	FIR_SendInputData((u32)a_10);
        u32 raw = FIR_ReadOutputData();
        float out = fixedToFloat((int32_t)raw, 20);  // Assuming Q12.20 output format
        printf("Index %d : Raw = %ld | Float = %.5f\r\n", i, raw, out);
    }

    return 0;
}

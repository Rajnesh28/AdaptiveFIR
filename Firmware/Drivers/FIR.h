#ifndef FIR_H
#define FIR_H

#include "xil_types.h"

#define FAILURE                 0
#define SUCCESS                 1

#define FIR_BASE_ADDRESS        0x40000000U
#define CONTROL_REG_OFFSET      0x00U
#define STATUS_REG_OFFSET       0x04U
#define TAP_COUNT_REG_OFFSET    0x08U
#define COEFF_REG_OFFSET        0x0CU
#define INPUT_REG_OFFSET        0x10U
#define OUTPUT_REG_OFFSET       0x14U

#define CTRL_COMPUTE            0x01U
#define CTRL_COEFF_WREN         0x02U

u32 FIR_SetCoefficientWriteEnable(void);
u32 FIR_ClearCoefficientWriteEnable(void);
u32 FIR_StartCompute(void);
u32 FIR_StopCompute(void);
u32 FIR_SetTapCount(u32 tap_count);
void FIR_SendCoefficientData(u32 coefficient_data);
void FIR_SendInputData(u32 input_data);
u32  FIR_ReadOutputData(void);

#endif // FIR_H

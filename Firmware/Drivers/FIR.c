#include "FIR.h"

static inline volatile u32* FIR_Reg(u32 offset) {
    return (volatile u32*)(FIR_BASE_ADDRESS + offset);
}

u32 FIR_SetCoefficientWriteEnable(void) {
    *FIR_Reg(CONTROL_REG_OFFSET) |= CTRL_COEFF_WREN;
    return ((*FIR_Reg(CONTROL_REG_OFFSET) & CTRL_COEFF_WREN) != 0) ? SUCCESS : FAILURE;
}

u32 FIR_ClearCoefficientWriteEnable(void) {
    *FIR_Reg(CONTROL_REG_OFFSET) &= ~CTRL_COEFF_WREN;
    return ((*FIR_Reg(CONTROL_REG_OFFSET) & CTRL_COEFF_WREN) == 0) ? SUCCESS : FAILURE;
}

u32 FIR_StartCompute(void) {
    *FIR_Reg(CONTROL_REG_OFFSET) |= CTRL_COMPUTE;
    return ((*FIR_Reg(CONTROL_REG_OFFSET) & CTRL_COMPUTE) != 0) ? SUCCESS : FAILURE;
}

u32 FIR_StopCompute(void) {
    *FIR_Reg(CONTROL_REG_OFFSET) &= ~CTRL_COMPUTE;
    return ((*FIR_Reg(CONTROL_REG_OFFSET) & CTRL_COMPUTE) == 0) ? SUCCESS : FAILURE;
}

u32 FIR_SetTapCount(u32 tap_count) {
    *FIR_Reg(TAP_COUNT_REG_OFFSET) = tap_count;
    return (*FIR_Reg(TAP_COUNT_REG_OFFSET) == tap_count) ? SUCCESS : FAILURE;
}

void FIR_SendCoefficientData(u32 coefficient_data) {
    *FIR_Reg(COEFF_REG_OFFSET) = coefficient_data;
}

void FIR_SendInputData(u32 input_data) {
    *FIR_Reg(INPUT_REG_OFFSET) = input_data;
}

u32 FIR_ReadOutputData(void) {
    return *FIR_Reg(OUTPUT_REG_OFFSET);
}

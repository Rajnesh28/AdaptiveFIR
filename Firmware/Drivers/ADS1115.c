#include "ADS1115.h"

u32 get_config_register(XIicPs* iicPs) {
	u8 tx[1];
    u8 rx[2];
    u32 status;

    tx[0] = {CONFIG_REG_ADDR}

    status = XIicPs_MasterSendPolled(iicPs, tx, 1, IIC_DEVICE_ID);
    if (status == SEND_FAILURE) {
        xil_printf("Failed to point to config register!\r\n");
        return -1;
    }

    status = XIicPs_MasterRecvPolled(iicPs, rx, 2, IIC_DEVICE_ID);
    if (status == RECV_FAILURE) {
        xil_printf("Failed to read config register!\r\n");
        return -1;
    }

    u32 ret = (rx[0] << 8) | rx[1];
    return ret;
}

void set_config_register(XIicPs* iicPs, u32 config) {
	u8 tx_address[1];
    u8 tx_config[2];
    u8 tx_config[0] = config & 0x0000FF00;
    u8 tx_config[1] = config & 0x000000FF;
    u32 status;

    tx_address[0] = {CONFIG_REG_ADDR}

    status = XIicPs_MasterSendPolled(iicPs, tx_address, 1, IIC_DEVICE_ID);
    if (status == SEND_FAILURE) {
        xil_printf("Failed to point to config register!\r\n");
        return -1;
    }

    status = XIicPs_MasterSendPolled(iicPs, tx_config, 2, IIC_DEVICE_ID);
    if (status == SEND_FAILURE) {
        xil_printf("Failed to set config register!\r\n");
        return -1;
    }

    return;
}

u32 get_operational_status(XIicPs* iicPs) {
}
void set_operational_status(XIicPs* iicPs, u32 config) {

};

u32 get_mux_config(XIicPs* iicPs) {
    u32 ret = get_config_register(iicPs);
    return ((ret & MUX_CONFIG_MASK) >> MUX_CONFIG_SHIFT);
}

void set_mux_config(XIicPs* iicPs, u32 config) {
    set_config_register()
};

u32 get_pga_config(XIicPs* iicPs) {
    u32 ret = get_config_register(iicPs);
    return ((ret & PROGRAMMABLE_GAIN_MASK) >> PROGRAMMABLE_GAIN_SHIFT);
}

void set_pga_config(XIicPs* iicPs, u32 config);

u32 get_device_operating_mode(XIicPs* iicPs) {
    u32 ret = get_config_register(iicPs);
    return ((ret & DEVICE_OPERATING_MODE_MASK) >> DEVICE_OPERATING_MODE_SHIFT);
}

void set_device_operating_mode(XIicPs* iicPs, u32 config);

u32 get_data_rate(XIicPs* iicPs) {
    u32 ret = get_config_register(iicPs);
    return ((ret & DATA_RATE_MASK) >> DATA_RATE_SHIFT);
}

void set_data_rate(XIicPs* iicPs, u32 config);

u32 get_comparator_mode(XIicPs* iicPs) {
    u32 ret = get_config_register(iicPs);
    return ((ret & COMP_MODE_MASK) >> COMP_MODE_SHIFT);
}

void set_comparator_mode(XIicPs* iicPs, u32 config);

u32 get_comparator_polarity(XIicPs* iicPs) {
    u32 ret = get_config_register(iicPs);
    return ((ret & COMP_POL_MASK) >> COMP_POL_SHIFT);
}
void set_comparator_polarity(XIicPs* iicPs, u32 config);

u32 get_comparator_latch(XIicPs* iicPs) {
    u32 ret = get_config_register(iicPs);
    return ((ret & COMP_LAT_MASK) >> COMP_LAT_SHIFT);
}
void set_comparator_latch(XIicPs* iicPs, u32 config);

u32 get_comparator_queue(XIicPs* iicPs) {
    u32 ret = get_config_register(iicPs);
    return ((ret & COMP_QUE_MASK) >> COMP_QUE_SHIFT);
}

void set_comparator_queue(XIicPs* iicPs, u32 config) {

}

s16 read_conversion_data() {
	u32 status;
	u8 tx1[1] = {CONVERSION_REG_ADDR};
	status = XIicPs_MasterSendPolled(&iic, tx1, 1, IIC_DEVICE_ID);
    if (status != XST_SUCCESS) {
        xil_printf("Failed to point to conversion register!\r\n");
        return;
    }

    // Read 2 bytes from conversion register
    u8 rx[2] = {0};
    status = XIicPs_MasterRecvPolled(&iic, rx, 2, IIC_DEVICE_ID);
    if (status != XST_SUCCESS) {
        xil_printf("Failed to read conversion result!\r\n");
        return;
    }

    s16 adc_raw = ((s16)rx[0] << 8) | rx[1];

    return adc_raw;
}


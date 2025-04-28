// Reference Documentation: 
// https://www.ti.com/lit/ds/symlink/ads1115.pdf


#ifndef
#define ADS1115_H

#include "xiicps.h"
//https://xilinx.github.io/embeddedsw.github.io/iicps/doc/html/api/xiicps_8h.html

#include "xparameters.h"
#include "xil_printf.h"
#include "platform.h"
#include <unistd.h>
#include "xil_types.h"

#define SEND_FAILURE             0x00
#define RECV_FAILURE             0x00

#define SEND_SUCCESS             0x01
#define RECV_SUCCESS             0x01

#define IIC_DEVICE_ID       	 XPAR_XIICPS_0_DEVICE_ID
#define ADS1115_7BIT_ADDR   	 0x48

#define CONVERSION_REG_ADDR   	 0x00U
#define CONFIG_REG_ADDR       	 0x01U
#define LOW_THRESH_REG_ADDR   	 0x10U
#define HIGH_THRESH_REG_ADDR  	 0x10U

#define MUX_CONFIG_MASK		  	 0x7000
#define MUX_CONFIG_SHIFT 	   	 12

#define MUX_AINP_AIN0_AINN_AIN1  0b000
#define MUX_AINP_AIN0_AINN_AIN3  0b001
#define MUX_AINP_AIN1_AINN_AIN3  0b010
#define MUX_AINP_AIN2_AINN_AIN3  0b011
#define MUX_AINP_AIN0_AINN_GND   0b100
#define MUX_AINP_AIN1_AINN_GND	 0b101
#define MUX_AINP_AIN2_AINN_GND	 0b110
#define MUX_AINP_AIN3_AINN_GND	 0b111

#define PROGRAMMABLE_GAIN_MASK   0x0C00
#define PROGRAMMABLE_GAIN_SHIFT  9

#define PGA_6144				 0b000
#define PGA_4096				 0b001
#define PGA_2048				 0b010
#define PGA_1024				 0b011
#define PGA_0512				 0b100
#define PGA_0256				 0b101

#define DEVICE_OPERATING_MODE_MASK	 0x100
#define	DEVICE_OPERATING_MODE_SHIFT  8

#define DATA_RATE_MASK		     0xF0
#define DATA_RATE_SHIFT			 5

#define DATA_RATE_8SPS			 0b000
#define DATA_RATE_16SPS			 0b001
#define DATA_RATE_32SPS			 0b010
#define DATA_RATE_64SPS			 0b011
#define DATA_RATE_128SPS		 0b100
#define DATA_RATE_250SPS		 0b101
#define DATA_RATE_475SPS	 	 0b110
#define DATA_RATE_860SPS	 	 0b111

#define COMP_MODE_MASK		     0x10
#define COMP_MODE_SHIFT			 4

#define COMP_MODE_TRADITIONAL	 0b0
#define COMP_MODE_WINDOW		 0b1

#define	COMP_POL_MASK			 0x8
#define COMP_POL_SHIFT			 3

#define COMP_POL_ACTIVE_LOW		 0b0
#define COMP_POL_ACTIVE_HIGH	 0b1

#define	COMP_LAT_MASK			 0x4
#define COMP_LAT_SHIFT			 2

#define COMP_LAT_LATCHING		 0b0
#define COMP_LAT_NONLATCHING	 0b1

#define	COMP_QUE_MASK			 0x3
#define COMP_QUE_SHIFT			 0

#define COMP_QUE_ASSERT_ONE_CONV 	0b00
#define COMP_QUE_ASSERT_TWO_CONV  	0b01
#define COMP_QUE_ASSERT_FOUR_CONV   0b10
#define COMP_QUE_DISABLE_COMPARATOR 0b11

// PGA = ±2.048V (May be modified)
#define FULL_SCALE_VOLTAGE 2.04
#define MAX_ADC_VALUE      32768.0

u32 get_config_register(XIicPs* iicPs);
void set_config_register(XIicPs* iicPs, u32 config);

u32 get_operational_status(XIicPs* iicPs);
void set_operational_status(XIicPs* iicPs, u32 config);

u32 get_mux_config(XIicPs* iicPs);
void set_mux_config(XIicPs* iicPs, u32 config);

u32 get_pga_config(XIicPs* iicPs);
void set_pga_config(XIicPs* iicPs, u32 config);

u32 get_device_operating_mode(XIicPs* iicPs);
void set_device_operating_mode(XIicPs* iicPs, u32 config);

u32 get_data_rate(XIicPs* iicPs);
void set_data_rate(XIicPs* iicPs, u32 config);

u32 get_comparator_mode(XIicPs* iicPs);
void set_comparator_mode(XIicPs* iicPs, u32 config);

u32 get_comparator_polarity(XIicPs* iicPs);
void set_comparator_polarity(XIicPs* iicPs, u32 config);

u32 get_comparator_latch(XIicPs* iicPs);
void set_comparator_latch(XIicPs* iicPs, u32 config);

u32 get_comparator_queue(XIicPs* iicPs);
void set_comparator_queue(XIicPs* iicPs, u32 config);

s16 read_conversion_single_data();

s16 read_conversion_continuous_data();

#endif //ADS1115_H

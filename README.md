# AdaptiveFIR

AdaptiveFIR is a runtime-reconfigurable Finite Impulse Response (FIR) filter IP core designed for digital signal processing applications. The design is implemented in SystemVerilog and exposes a simple AXI4-Lite interface for software-driven control and data interaction.

This repository provides:

- A parameterized FIR filter core

- Software drivers (in C) for interfacing with the hardware

- Example firmware to demonstrate use-cases

- Math utilities for converting between floating-point and fixed-point formats

- Preliminary (unfinished) drivers for integrating streaming ADC data on the ADS1115 (aka, one I happen to own)

## Key Features

- **Runtime Configurable Coefficients:** Load different filter taps at runtime, enabling adaptive or application-specific filtering without needing to reprogram the FPGA.

- **Parallelized MAC Design:** The filter supports configurable latency to balance performance and resource usage.

    - Latency = 1: Fully Parallel, Single-cycle output, ~22% DSP utilization.

    - Latency > 1: Pipelined-parallel hybrid design (see `FIR_datapath.sv`). Reduced DSP usage to ~5% with LATENCY parameter set between 3 to 5. 
    
- **AXI4-Lite Control Interface:** Simple memory-mapped interface for low-overhead control and monitoring from software.

- **Fixed-Point DSP Ready:** Optimized for fixed-point input and coefficient formats (e.g., Q6.10 → Q12.20 arithmetic).

## AXI4-Lite Memory Map

| Address Offset | Register Name   | Description                                                     |
| -------------- | --------------- | --------------------------------------------------------------- |
| `0x00`         | **Control**     | Bit 0: `compute` enable, Bit 1: `coefficient load` enable       |
| `0x04`         | **Status**      | Indicates `idle`, `busy`, or `ready` status of the compute unit |
| `0x08`         | **Coefficient** | Write one coefficient at a time (tap index managed internally)  |
| `0x0C`         | **Input**       | Write each new input sample to this register                    |
| `0x10`         | **Output**      | Read the most recent filtered output                            |


`Hardware/Design`: SystemVerilog source files for the FIR core

`Firmware/Drivers`: C firmware drivers for software interaction (tested on Zedboard)

`Firmware/Examples`: Example software application demonstrating coefficient loading, data input, and output reading

`Hardware/Verification`: Verification testbench, TO-DO: Add assertions, and AXI-Read function

## To - Do
- Debug pipeline-parallel option to ensure output arrives at the exact number of clock cycles configured.
- Improve testbench to include assertions, AXI-read function, and more rigorous testing overall.
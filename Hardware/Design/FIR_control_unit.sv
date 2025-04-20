module FIR_control_unit #(
    parameter integer MAX_TAPS = 16
) (
    input logic clk,
    input logic rstn,

    input logic [31 : 0] control_reg,

    // Monitor AXI AW channel
    input logic S_AXI_AWREADY,
    input logic S_AXI_AWVALID,
    input logic [31 : 0] S_AXI_AWADDR,

    // Monitor AXI W channel
    input logic S_AXI_WREADY,
    input logic S_AXI_WVALID,
    input logic [31 : 0] S_AXI_WDATA,

    output logic coeff_data_valid,
    output logic [31 : 0] coeff_data

);

logic coeff_data_wren;
assign coeff_data_wren = control_reg[1];

assign coeff_data_valid  = (S_AXI_AWREADY && S_AXI_AWVALID && coeff_data_wren && 
                            (S_AXI_AWADDR == 0)) ? 1 : 0;

assign coeff_data        = (S_AXI_WREADY  && S_AXI_WVALID) ? S_AXI_WDATA : 0;




endmodule

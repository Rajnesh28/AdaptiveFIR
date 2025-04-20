`timescale 1 ns / 1 ps

module FIR_top #
(
	parameter integer C_MAX_TAPS			= 16,
	parameter integer C_S00_AXI_DATA_WIDTH	= 32,
	parameter integer C_S00_AXI_ADDR_WIDTH	= 32
)
(
	input wire  s00_axi_aclk,
	input wire  s00_axi_aresetn,
	input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
	input wire [2 : 0] s00_axi_awprot,
	input wire  s00_axi_awvalid,
	output wire  s00_axi_awready,
	input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
	input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
	input wire  s00_axi_wvalid,
	output wire  s00_axi_wready,
	output wire [1 : 0] s00_axi_bresp,
	output wire  s00_axi_bvalid,
	input wire  s00_axi_bready,
	input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
	input wire [2 : 0] s00_axi_arprot,
	input wire  s00_axi_arvalid,
	output wire  s00_axi_arready,
	output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
	output wire [1 : 0] s00_axi_rresp,
	output wire  s00_axi_rvalid,
	input wire  s00_axi_rready
);
    
// Instantiation of Axi-Lite Slave Bus Interface
FIR_axi # ( 
	.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
	.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
) FIR_axi_inst (
	.S_AXI_ACLK(s00_axi_aclk),
	.S_AXI_ARESETN(s00_axi_aresetn),
	.S_AXI_AWADDR(s00_axi_awaddr),
	.S_AXI_AWPROT(s00_axi_awprot),
	.S_AXI_AWVALID(s00_axi_awvalid),
	.S_AXI_AWREADY(s00_axi_awready),
	.S_AXI_WDATA(s00_axi_wdata),
	.S_AXI_WSTRB(s00_axi_wstrb),
	.S_AXI_WVALID(s00_axi_wvalid),
	.S_AXI_WREADY(s00_axi_wready),
	.S_AXI_BRESP(s00_axi_bresp),
	.S_AXI_BVALID(s00_axi_bvalid),
	.S_AXI_BREADY(s00_axi_bready),
	.S_AXI_ARADDR(s00_axi_araddr),
	.S_AXI_ARPROT(s00_axi_arprot),
	.S_AXI_ARVALID(s00_axi_arvalid),
	.S_AXI_ARREADY(s00_axi_arready),
	.S_AXI_RDATA(s00_axi_rdata),
	.S_AXI_RRESP(s00_axi_rresp),
	.S_AXI_RVALID(s00_axi_rvalid),
	.S_AXI_RREADY(s00_axi_rready)
);

// Instantiation of Finite Impulse Response Control Unit
FIR_control_unit FIR_control_unit_inst (
    .clk(s00_axi_aclk),
    .rstn(s00_axi_aresetn),
    .S_AXI_AWREADY(s00_axi_awready),
    .S_AXI_AWVALID(s00_axi_awvalid),
    .S_AXI_AWADDR(s00_axi_awaddr),
    .S_AXI_WREADY(s00_axi_wready),
    .S_AXI_WVALID(s00_axi_wvalid),
    .S_AXI_WDATA(s00_axi_wdata),
	.control_reg(control_reg),
	.coeff_data_valid(coeff_data_valid),
	.coeff_data(coeff_data)
);

// Instantiation of Finite Impulse Response Datapath
FIR_datapath #(.MAX_TAPS(16)) 
    FIR_datapath_inst (
    .clk(s00_axi_aclk),
    .rstn(s00_axi_aresetn),
    .tap_count(tap_count_reg),
    .input_data_valid(1'b0), 
    .input_data(16'sd0), 
    .coeff_data_valid(coeff_data_valid),
    .coeff_data(coeff_data),
    .compute(1'b0),
    .output_data(), 
    .output_data_valid(), 
    .error()
);


endmodule

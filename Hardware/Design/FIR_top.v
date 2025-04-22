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
    
   // Between FIR AXI and Control Unit
   wire [C_S00_AXI_ADDR_WIDTH-1 : 0] control_axi;
   wire [C_S00_AXI_ADDR_WIDTH-1 : 0] tap_count_axi;
   wire [C_S00_AXI_ADDR_WIDTH-1 : 0] coeff_axi;
   wire [C_S00_AXI_ADDR_WIDTH-1 : 0] x_axi;
   wire [C_S00_AXI_ADDR_WIDTH-1 : 0] status_axi;
   wire [C_S00_AXI_ADDR_WIDTH-1 : 0] y_axi;

   // Between FIR Control Unit and Datapath
   wire [C_S00_AXI_ADDR_WIDTH-1 : 0] tap_count;
   wire [C_S00_AXI_ADDR_WIDTH-1 : 0] coeff_data;
   wire [C_S00_AXI_ADDR_WIDTH-1 : 0] x_data;
   wire [C_S00_AXI_ADDR_WIDTH-1 : 0] output_data;

   wire x_data_valid;
   wire coeff_data_valid;
   wire compute;
   wire output_data_valid;
   wire coefficient_loading_complete;
   
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
	.S_AXI_RREADY(s00_axi_rready),
    .control_axi(control_axi),
    .tap_count_axi(tap_count_axi),
    .coeff_axi(coeff_axi),
    .x_axi(x_axi),
    .status_axi(status_axi),
    .y_axi(y_axi)

);

// Instantiation of Finite Impulse Response Control Unit
FIR_control_unit FIR_control_unit_inst (
   .clk(s00_axi_aclk),
   .rstn(s00_axi_aresetn),
   .control_axi(control_axi),
   .tap_count_axi(tap_count_axi),
   .coeff_axi(coeff_axi),
   .x_axi(x_axi),
   .status_axi(status_axi),
   .y_axi(y_axi),
   .S_AXI_AWREADY(s00_axi_awready),
   .S_AXI_AWVALID(s00_axi_awvalid),
   .S_AXI_AWADDR(s00_axi_awaddr),
   .tap_count(tap_count),
   .x_data(x_data),
   .x_data_valid(x_data_valid),
   .coeff_data_valid(coeff_data_valid),
   .coeff_data(coeff_data),
   .compute(compute),
   .coefficient_loading_complete(coefficient_loading_complete),
   .output_data_valid(output_data_valid),
   .output_data(output_data) 
);

// Instantiation of Finite Impulse Response Datapath
FIR_datapath #(.MAX_TAPS(C_MAX_TAPS)) 
    FIR_datapath_inst (
    .clk(s00_axi_aclk),
    .rstn(s00_axi_aresetn),
    .tap_count(tap_count),
    .input_data_valid(x_data_valid),
    .input_data(x_data),
    .coeff_data_valid(coeff_data_valid),
    .coeff_data(coeff_data),
    .compute(compute),
    .output_data(output_data),
    .output_data_valid(output_data_valid),
    .coefficient_loading_complete(coefficient_loading_complete) 
);


endmodule

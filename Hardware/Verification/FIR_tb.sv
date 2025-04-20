`timescale 1ns / 1ps


module FIR_top_tb;

    parameter integer C_MAX_TAPS			= 16;
    parameter integer C_S00_AXI_DATA_WIDTH	= 32;
    parameter integer C_S00_AXI_ADDR_WIDTH	= 32;
    logic  s00_axi_aclk;
    logic  s00_axi_aresetn;
    logic [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr;
    logic [2 : 0] s00_axi_awprot;
    logic  s00_axi_awvalid;
    logic  s00_axi_awready;
    logic [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata;
    logic [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb;
    logic  s00_axi_wvalid;
    logic  s00_axi_wready;
    logic [1 : 0] s00_axi_bresp;
    logic  s00_axi_bvalid;
    logic  s00_axi_bready;
    logic [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr;
    logic [2 : 0] s00_axi_arprot;
    logic  s00_axi_arvalid;
    logic  s00_axi_arready;
    logic [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata;
    logic [1 : 0] s00_axi_rresp;
    logic  s00_axi_rvalid;
    logic  s00_axi_rready;
    
    
    FIR_top # (
        .C_MAX_TAPS(C_MAX_TAPS),
        .C_S00_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
        .C_S00_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
    ) DUT (
   	.s00_axi_aclk(s00_axi_aclk),
	.s00_axi_aresetn(s00_axi_aresetn),
	.s00_axi_awaddr(s00_axi_awaddr),
	.s00_axi_awprot(s00_axi_awprot),
	.s00_axi_awvalid(s00_axi_awvalid),
	.s00_axi_awready(s00_axi_awready),
	.s00_axi_wdata(s00_axi_wdata),
	.s00_axi_wstrb(s00_axi_wstrb),
	.s00_axi_wvalid(s00_axi_wvalid),
	.s00_axi_wready(s00_axi_wready),
	.s00_axi_bresp(s00_axi_bresp),
	.s00_axi_bvalid(s00_axi_bvalid),
	.s00_axi_bready(s00_axi_bready),
	.s00_axi_araddr(s00_axi_araddr),
	.s00_axi_arprot(s00_axi_arprot),
	.s00_axi_arvalid(s00_axi_arvalid),
	.s00_axi_arready(s00_axi_arready),
	.s00_axi_rdata(s00_axi_rdata),
	.s00_axi_rresp(s00_axi_rresp),
	.s00_axi_rvalid(s00_axi_rvalid),
	.s00_axi_rready(s00_axi_rready)     
    );
    
    always #5 s00_axi_aclk = ~s00_axi_aclk;
    
    initial begin
        s00_axi_aclk = 0;
        s00_axi_aresetn = 0;
    
        #20;
        s00_axi_aresetn = 1;
    
        #20;
        
        AXI_WRITE_DATA(32'h0000_0000, 32'h00000001);
        AXI_WRITE_DATA(32'h0000_0004, 'sd85);
        AXI_WRITE_DATA(32'h0000_0000, 32'hABCD1234);
        AXI_WRITE_DATA(32'h0000_0000, 32'hABCD1234);
        AXI_WRITE_DATA(32'h0000_0000, 32'hABCD1234);
        AXI_WRITE_DATA(32'h0000_0000, 32'hABCD1234);
        AXI_WRITE_DATA(32'h0000_0000, 32'hABCD1234);

        #50 $finish;
    end

    
    
task automatic AXI_WRITE_DATA(input [31:0] address, input [31:0] data);
begin
    s00_axi_awaddr  = address;
    s00_axi_awvalid = 1;
    s00_axi_wvalid  = 1;
    s00_axi_wdata   = data;
    s00_axi_wstrb   = 4'b1111;
    s00_axi_bready  = 1;

    wait (s00_axi_awready && s00_axi_wready);

    @(posedge s00_axi_aclk);

    s00_axi_awvalid = 0;
    s00_axi_wvalid  = 0;

    wait (s00_axi_bvalid);
    if (s00_axi_bresp != 2'b00)
        $error("AXI WRITE ERROR: bresp = %0b", s00_axi_bresp);

    s00_axi_bready = 0;
end
endtask


endmodule

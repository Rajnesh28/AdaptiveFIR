module FIR_top_tb();


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
        s00_axi_aclk = 1; 
        s00_axi_aresetn = 0;
        s00_axi_awaddr  = 32'h0;
        s00_axi_awprot  = 3'b0;
        s00_axi_awvalid = 0;
        s00_axi_wdata   = 32'h0;
        s00_axi_wstrb   = 4'b0;
        s00_axi_wvalid  = 0;
        s00_axi_bready  = 0;
        s00_axi_araddr  = 32'h0;
        s00_axi_arprot  = 3'b0;
        s00_axi_arvalid = 0;
        s00_axi_rready  = 0;
    
        #20
        
        s00_axi_aresetn = 1; 

        #20
        
        // SET THE TAP COUNT
        AXI_WRITE_DATA(32'h0000_0008, 32'h0000_0008);
        
        // SET THE COEFFICIENT LOAD ENABLE BIT IN THE CONTROL REGISTER
        AXI_WRITE_DATA(32'h0000_0000, 32'h0000_0002);
        
       // SEND COEFFICIENT DATA 
        AXI_WRITE_DATA(32'h0000_000C, $urandom_range(0, 25));
        AXI_WRITE_DATA(32'h0000_000C, $urandom_range(0, 25));
        AXI_WRITE_DATA(32'h0000_000C, $urandom_range(0, 25));
        AXI_WRITE_DATA(32'h0000_000C, $urandom_range(0, 25));
        AXI_WRITE_DATA(32'h0000_000C, $urandom_range(0, 25));
        AXI_WRITE_DATA(32'h0000_000C, $urandom_range(0, 25));
        AXI_WRITE_DATA(32'h0000_000C, $urandom_range(0, 25));

        // SET THE COMPUTE BIT IN THE CONTROL REGISTER
        AXI_WRITE_DATA(32'h0000_0000, 32'h0000_0001);
        
        // SEND INPUT DATA
        AXI_WRITE_DATA(32'h0000_0010, $urandom_range(0, 25));
        AXI_WRITE_DATA(32'h0000_0010, $urandom_range(0, 25));
        AXI_WRITE_DATA(32'h0000_0010, $urandom_range(0, 25));
        AXI_WRITE_DATA(32'h0000_0010, $urandom_range(0, 25));
        AXI_WRITE_DATA(32'h0000_0010, $urandom_range(0, 25));
        AXI_WRITE_DATA(32'h0000_0010, $urandom_range(0, 25));
        AXI_WRITE_DATA(32'h0000_0010, $urandom_range(0, 25));
        AXI_WRITE_DATA(32'h0000_0010, $urandom_range(0, 25));
        AXI_WRITE_DATA(32'h0000_0010, $urandom_range(0, 25));
        AXI_WRITE_DATA(32'h0000_0010, $urandom_range(0, 25));

    
    $finish;
    end
    
    task automatic AXI_WRITE_DATA;
    input [31:0] address;
    input [31:0] data;
    begin
        
        s00_axi_awaddr  = address;
        s00_axi_awvalid = 1;
        s00_axi_wvalid  = 1;
        s00_axi_wdata   = data;
        s00_axi_wstrb   = 4'b1111;
    
        wait (s00_axi_awready && s00_axi_wready);
        
        @(posedge s00_axi_aclk) #1;
        
        wait(s00_axi_bvalid);
        s00_axi_bready = 1;
        
        @(posedge s00_axi_aclk) #1;
        
        s00_axi_awvalid = 0;
        s00_axi_wvalid  = 0;
        s00_axi_wstrb   = 4'b0000;
        
    end
    endtask
        
      
endmodule
module FIR_tb();


    parameter int MAX_TAPS = 16;
    
    // === Clock & Reset ===
    logic clk;
    logic rstn;

    // === AXI Inputs (to toggle manually) ===
    logic [31:0] control_axi;
    logic [31:0] status_axi;
    logic [31:0] tap_count_axi;
    logic [31:0] coeff_axi;
    logic [31:0] x_axi;
    logic [31:0] y_axi;
    logic        S_AXI_AWREADY;
    logic        S_AXI_AWVALID;
    logic [31:0] S_AXI_AWADDR;

    // === Internal Control <-> Datapath signals ===
    logic [31:0] tap_count;
    logic                                 x_data_valid;
    logic signed [31:0]                   x_data;
    logic                                 coeff_data_valid;
    logic signed [31:0]                   coeff_data;
    logic                                 compute;
    logic                                 coefficient_loading_complete;
    logic                                 output_data_valid;
    logic        [31:0]                   output_data;

    // === Instantiate FIR Control Unit ===
    FIR_control_unit #(
        .MAX_TAPS(MAX_TAPS)
    ) control_inst (
        .clk(clk),
        .rstn(rstn),

        .control_axi(control_axi),
        .status_axi(status_axi),
        .tap_count_axi(tap_count_axi),
        .coeff_axi(coeff_axi),
        .x_axi(x_axi),
        .y_axi(y_axi),

        .S_AXI_AWREADY(S_AXI_AWREADY),
        .S_AXI_AWVALID(S_AXI_AWVALID),
        .S_AXI_AWADDR(S_AXI_AWADDR),

        .tap_count(tap_count),
        .x_data_valid(x_data_valid),
        .x_data(x_data),
        .coeff_data_valid(coeff_data_valid),
        .coeff_data(coeff_data),
        .compute(compute),

        .coefficient_loading_complete(coefficient_loading_complete),
        .output_data_valid(output_data_valid),
        .output_data(output_data)
    );

    // === Instantiate FIR Datapath ===
    FIR_datapath #(
        .MAX_TAPS(MAX_TAPS)
    ) datapath_inst (
        .clk(clk),
        .rstn(rstn),

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

    always #5 clk = ~clk;

initial begin
    clk  = 1;
    rstn = 0;
    control_axi = 0;
    status_axi = 0;
    tap_count_axi = 0;
    coeff_axi = 0;
    x_axi = 0;
    y_axi = 0;
    S_AXI_AWREADY = 0;
    S_AXI_AWVALID = 0;
    S_AXI_AWADDR = 0;

    #10
    rstn = 1;

    // === TAP COUNT WRITE (AWADDR == 0x08) ===
    #10 begin
        S_AXI_AWREADY = 1;
        S_AXI_AWVALID = 1;
        S_AXI_AWADDR  = 32'h08;
    end

    #10 begin
        tap_count_axi = 8;
        S_AXI_AWREADY = 0;
        S_AXI_AWVALID = 0;
        S_AXI_AWADDR  = 0;
    end

    // === CONTROL REGISTER WRITE (AWADDR == 0x00) ===
    #10 begin
        S_AXI_AWREADY = 1;
        S_AXI_AWVALID = 1;
        S_AXI_AWADDR  = 32'h00;
    end

    #10 begin
        control_axi = 32'h2;
        S_AXI_AWREADY = 0;
        S_AXI_AWVALID = 0;
        S_AXI_AWADDR  = 0;
    end

    // === COEFFICIENTS WRITE (AWADDR == 0x0C) ===
    #10 begin
        S_AXI_AWREADY = 1;
        S_AXI_AWVALID = 1;
        S_AXI_AWADDR  = 32'h0C;
    end

    #10 coeff_axi = $urandom_range(0, 25);
    #10 coeff_axi = $urandom_range(0, 25);
    #10 coeff_axi = $urandom_range(0, 25);
    #10 coeff_axi = $urandom_range(0, 25);
    #10 coeff_axi = $urandom_range(0, 25);
    #10 coeff_axi = $urandom_range(0, 25);
    #10 coeff_axi = $urandom_range(0, 25);
    
    #10 begin
        S_AXI_AWREADY = 0;
        S_AXI_AWVALID = 0;
        S_AXI_AWADDR  = 32'h00;
    end
    
    
    // === Enable Compute (AWADDR == 0x10) ===
    #10 begin
        control_axi = 32'h1;
        S_AXI_AWREADY = 1;
        S_AXI_AWVALID = 1;
        S_AXI_AWADDR  = 32'h00;
    end
    
    // === INPUTS WRITE (AWADDR == 0x10) ===
    #10 begin
        S_AXI_AWREADY = 1;
        S_AXI_AWVALID = 1;
        S_AXI_AWADDR  = 32'h10;
     end
            
    #10 x_axi = $urandom_range(0, 25);
    #10 x_axi = $urandom_range(0, 25);
    #10 x_axi = $urandom_range(0, 25);
    #10 x_axi = $urandom_range(0, 25);
    #10 x_axi = $urandom_range(0, 25);
    #10 x_axi = $urandom_range(0, 25);
    #10 x_axi = $urandom_range(0, 25);
    #10 x_axi = $urandom_range(0, 25);
    #10 x_axi = $urandom_range(0, 25);
    #10 x_axi = $urandom_range(0, 25);

            
    $finish;
end
endmodule
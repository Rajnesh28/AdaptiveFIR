module FIR_control_unit #(
    parameter integer MAX_TAPS = 16
) (
    input  logic clk,
    input  logic rstn,

    // Continuous wires from AXI MMIO registers
    input  logic [31:0] control_axi,
    input  logic [31:0] tap_count_axi,
    input  logic [31:0] coeff_axi,
    input  logic [31:0] x_axi,
    output logic [31:0] status_axi,
    output logic [31:0] y_axi,

    // Monitor AXI Address Write Channel
    input  logic        S_AXI_AWREADY,
    input  logic        S_AXI_AWVALID,
    input  logic [31:0] S_AXI_AWADDR,

    // To datapath
    output logic [31:0] tap_count,
    output logic [31:0] x_data,
    output logic        x_data_valid,
    output logic        coeff_data_valid,
    output logic [31:0] coeff_data,
    output logic        compute,

    // From datapath
    input  logic        coefficient_loading_complete,
    input  logic        output_data_valid,
    input  logic [31:0] output_data
);
    // State machine
    typedef enum logic [2:0] {
        IDLE,
        LOAD_COEFF,
        WAIT_FOR_INPUT,
        PROCESSING,
        DONE
    } state_t;

    state_t curr_state, next_state;
    
    logic tap_count_write_valid;
    logic coefficient_write_valid;
    logic input_write_valid;
    
    logic x_data_valid;
    assign x_data_valid            = input_write_valid;

    logic coeff_data_wren;
    assign coeff_data_wren = control_axi[1];

    assign status_axi = {29'd0, (curr_state == DONE), (curr_state == PROCESSING), (curr_state == IDLE)};

    // Continuous assignment, control unit acts as mediator.
    // Provides everything datapath needs.
    // Datapath is decoupled from AXI interface
    assign coeff_data   = coeff_axi;
    assign x_data       = x_axi;
    assign tap_count    = tap_count_axi;

    assign compute      = control_axi[0];
    assign y_axi        = output_data;

    always @(posedge clk) begin
        if (~rstn) begin
            tap_count_write_valid   <= 1'b0;
            coefficient_write_valid <= 1'b0;
            input_write_valid       <= 1'b0;
        end else begin
            tap_count_write_valid   <= ((S_AXI_AWVALID & S_AXI_AWREADY) && (S_AXI_AWADDR == 32'h08));
            coefficient_write_valid <= (S_AXI_AWVALID && S_AXI_AWREADY && (S_AXI_AWADDR == 32'h0C));
            input_write_valid       <= (S_AXI_AWVALID && S_AXI_AWREADY && (S_AXI_AWADDR == 32'h10));
        end
   end
    
    assign coeff_data_valid = coefficient_write_valid & coeff_data_wren;
    always_ff @(posedge clk) begin
        if (!rstn) begin
            curr_state <= IDLE;
        end else begin
            curr_state <= next_state;
        end
    end

    always_comb begin

        case (curr_state)
            IDLE:           next_state = (tap_count_write_valid) ? LOAD_COEFF : IDLE;

            LOAD_COEFF:     next_state = (coefficient_loading_complete) ? WAIT_FOR_INPUT : LOAD_COEFF;

            WAIT_FOR_INPUT: next_state = (input_write_valid) ? PROCESSING : WAIT_FOR_INPUT;

            PROCESSING:     next_state = (output_data_valid) ? DONE : PROCESSING;

            DONE:           next_state = (~compute) ? IDLE : DONE;

            default: next_state = IDLE;
        endcase
    end


endmodule

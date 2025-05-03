module FIR_datapath #(
    parameter integer MAX_TAPS = 16,
    parameter integer LATENCY = 3 // 1 implies fully parallel
) (
    input logic clk,
    input logic rstn,

    // From control unit
    input logic unsigned [31 : 0] tap_count,
    input logic input_data_valid,
    input logic signed [31:0] input_data,
    input logic coeff_data_valid,
    input logic signed [31:0] coeff_data,
    input logic compute,

    // To control unit
    output logic signed [31:0] output_data,
    output logic output_data_valid,
    output logic coefficient_loading_complete
);

localparam integer PARALLEL_UNITS = $ceil((MAX_TAPS + LATENCY - 1)/LATENCY);

logic [$clog2(MAX_TAPS) - 1 : 0] input_wr_ptr;
logic [$clog2(MAX_TAPS) - 1 : 0] coeff_wr_ptr;
logic                            valid;
logic                            compute_active;
logic        [31 : 0 ]           cycle_count;
         
logic signed [31 : 0] coeff_data_array [MAX_TAPS - 1 : 0];
logic signed [31 : 0] input_data_array [MAX_TAPS - 1 : 0];

always_ff @(posedge clk) begin
    if (~rstn) begin
        input_wr_ptr <= '{default: 0};
        valid <= 0;
    end else if (input_data_valid) begin
        input_wr_ptr <= ((input_wr_ptr == tap_count - 1) || (input_wr_ptr == MAX_TAPS - 1)) ? 0 : input_wr_ptr + 1;
        valid <= (input_wr_ptr == tap_count - 1 ) ? 1 : valid;
    end
end

always_ff @(posedge clk) begin
    if (~rstn) begin
        coeff_wr_ptr <= '{default: 0};
        coefficient_loading_complete <= 1'b0;
    end else if (coeff_data_valid) begin
        coeff_wr_ptr <= ((coeff_wr_ptr == tap_count - 1) || (coeff_wr_ptr == MAX_TAPS - 1)) ? coeff_wr_ptr : coeff_wr_ptr + 1;
        coefficient_loading_complete <= ((coeff_wr_ptr == tap_count - 2) || (coeff_wr_ptr == MAX_TAPS - 2));
    end
end

logic signed [31 : 0] acc_intermediate;

always_ff @(posedge clk) begin
    logic signed [31 : 0] acc;
   
    if (~rstn) begin
        output_data_valid <= 0;
        output_data       <= 32'sd0;
        compute_active    <= 1'b0;
        cycle_count       <= 1'b0;
        acc_intermediate  <= 0;
        
    end else if (compute && input_data_valid && ~compute_active) begin
        compute_active    <= 1'b1;
        cycle_count       <= 0;
        acc_intermediate  <= 0;
    end else if (compute_active) begin
        integer i;
        acc    = 0;
        for (i = 0; i < PARALLEL_UNITS; i = i + 1) begin
            integer tap_index = cycle_count * PARALLEL_UNITS + i;
            if (tap_index < tap_count) begin
                integer read_index = input_wr_ptr - tap_index - 1;
                if (read_index < 0) read_index = read_index + tap_count;

                acc += coeff_data_array[tap_index] * input_data_array[read_index];
            end

        end
        acc_intermediate <= acc + acc_intermediate;
                
        cycle_count <= cycle_count + 1;
        
        if (cycle_count == LATENCY - 1) begin
            output_data         <= acc_intermediate;
            output_data_valid   <= 1;
            compute_active      <= 0;
        end else begin
            cycle_count       <= cycle_count + 1;
            output_data_valid <= 0;
        end
    end else begin
        output_data_valid <= 0;
    end
end

FIR_memory #(.MAX_TAPS(MAX_TAPS)) input_buffer (
    .clk(clk),
    .rstn(rstn),
    .wr_ptr(input_wr_ptr),
    .data_in(input_data),
    .data_valid(input_data_valid),
    .data_out(input_data_array)
);

FIR_memory #(.MAX_TAPS(MAX_TAPS)) coeff_buffer (
    .clk(clk),
    .rstn(rstn),
    .wr_ptr(coeff_wr_ptr),
    .data_in(coeff_data),
    .data_valid(coeff_data_valid),
    .data_out(coeff_data_array)
);

endmodule
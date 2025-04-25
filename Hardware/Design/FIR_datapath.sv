module FIR_datapath #(
    parameter integer MAX_TAPS = 16
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

logic [$clog2(MAX_TAPS) - 1 : 0] input_wr_ptr;
logic [$clog2(MAX_TAPS) - 1 : 0] coeff_wr_ptr;
logic                            valid;

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

always_ff @(posedge clk) begin
    if (~rstn) begin
        output_data_valid <= 0;
        output_data       <= 32'sd0;
    end else if (compute & input_data_valid) begin
        integer i;
        integer read_index;
        logic signed [31:0] acc;
        acc = 0;

        for (i = 0; i < MAX_TAPS; i = i + 1) begin
            if (i < tap_count) begin
                read_index = input_wr_ptr - i - 1;
                if (read_index < 0) begin
                    read_index = read_index + tap_count;
                end
                acc += coeff_data_array[i] * input_data_array[read_index];
            end
        end

        output_data       <= acc;
        output_data_valid <= valid;
    end else begin
        output_data       <= output_data;
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
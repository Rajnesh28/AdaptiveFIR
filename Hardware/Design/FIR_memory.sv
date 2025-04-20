module FIR_memory #(
    parameter integer MAX_TAPS = 16
) (
    input  logic clk,
    input  logic rstn,

    input  logic [$clog2(MAX_TAPS)-1:0] wr_ptr,
    input  logic signed [15:0] data_in,
    input  logic data_valid,

    output logic signed [15:0] data_out [MAX_TAPS-1:0]
);

    logic signed [15:0] memory_array [MAX_TAPS-1:0];

    always_ff @(posedge clk) begin
        integer i;

        if (~rstn) begin
            for (i = 0; i < MAX_TAPS; i++) begin
                memory_array[i] <= 16'sd0;
            end
        end
        else if (data_valid) begin
            memory_array[wr_ptr] <= data_in;
        end
    end

    genvar j;
    generate
        for (j = 0; j < MAX_TAPS; j++) begin
            assign data_out[j] = memory_array[j];
        end
    endgenerate

endmodule

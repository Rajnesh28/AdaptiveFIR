package fir_pkg;

  // === Parameters ===
  parameter int MAX_TAPS           = 16;
  parameter int AXI_DATA_WIDTH     = 32;
  parameter int AXI_ADDR_WIDTH     = 32;

  // === AXI Memory-Mapped IO Addresses (in bytes) ===
  parameter int HW_CONTROL_REG_BASEADDRESS      = 32'h00;
  parameter int HW_STATUS_REG_BASEADDRESS       = 32'h04;
  parameter int HW_TAP_COUNT_REG_BASEADDRESS    = 32'h08;
  parameter int HW_COEFF_DATA_REG_BASEADDRESS   = 32'h0C;
  parameter int HW_INPUT_DATA_REG_BASEADDRESS   = 32'h10;
  parameter int HW_OUTPUT_DATA_REG_BASEADDRESS  = 32'h14;

  // === Utility Function ===
  // Returns ceiling of log2 of input depth (used for address/data sizing)
  function automatic int clogb2(input int depth);
    int temp;
    begin
      clogb2 = 0;
      temp   = depth - 1;
      while (temp > 0) begin
        clogb2 = clogb2 + 1;
        temp   = temp >> 1;
      end
    end
  endfunction

endpackage

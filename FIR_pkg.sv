package fir_pkg;

  parameter int NB_BYTE = 4;
  parameter int RAM_WIDTH = 8;

  parameter int COEFF_RAM_DEPTH = 8;
  parameter int X_RAM_DEPTH = 8;
  parameter int RAM_DEPTH = 8;
  parameter string RAM_PERFORMANCE = "HIGH_PERFORMANCE";

  parameter int MAX_TAPS = 7;
  parameter int ORDER = MAX_TAPS + 1;
  parameter int NUMBER_OF_DELAYS = MAX_TAPS;

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

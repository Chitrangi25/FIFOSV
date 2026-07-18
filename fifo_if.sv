interface fifo_if (input bit clk);
  logic        rst_n;
  logic        wr;
  logic        rd;
  logic [7:0]  data_in;
  logic [7:0]  data_out;
  logic        fifo_full;
  logic        fifo_empty;
  logic        fifo_threshold;
  logic        fifo_overflow;
  logic        fifo_underflow;
endinterface
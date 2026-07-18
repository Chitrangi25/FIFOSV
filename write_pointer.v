module write_pointer(
  output reg [4:0] wptr,
  output fifo_we,
  input wr, fifo_full, clk, rst_n
);
  assign fifo_we = (~fifo_full) & wr;
 
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) wptr <= 5'b00000;
    else if (fifo_we) wptr <= wptr + 5'b00001;
    else wptr <= wptr;
  end
endmodule
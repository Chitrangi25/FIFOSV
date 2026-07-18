module read_pointer(
  output reg [4:0] rptr,
  output fifo_rd,
  input rd, fifo_empty, clk, rst_n
);
  assign fifo_rd = (~fifo_empty) & rd;
 
  always @(posedge clk or negedge rst_n) begin
    if (~rst_n) rptr <= 5'b00000;
    else if (fifo_rd) rptr <= rptr + 5'b00001;
    else rptr <= rptr;
  end
endmodule
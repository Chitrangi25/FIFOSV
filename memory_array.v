module memory_array(
  output [7:0] data_out,
  input [7:0] data_in,
  input clk, fifo_we,
  input [4:0] wptr, rptr
);
  reg [7:0] data_out2 [15:0];
 
  always @(posedge clk) begin
    if (fifo_we)
      data_out2[wptr[3:0]] <= data_in;
  end
 
  assign data_out = data_out2[rptr[3:0]];
endmodule
`timescale 1ns/1ps


module tb;
  reg clk;
  always #10 clk = ~clk;

  fifo_if _if (clk);

  fifo_mem u0 (
    .data_out       (_if.data_out),
    .fifo_full      (_if.fifo_full),
    .fifo_empty     (_if.fifo_empty),
    .fifo_threshold (_if.fifo_threshold),
    .fifo_overflow  (_if.fifo_overflow),
    .fifo_underflow (_if.fifo_underflow),
    .clk            (clk),
    .rst_n          (_if.rst_n),
    .wr             (_if.wr),
    .rd             (_if.rd),
    .data_in        (_if.data_in)
  );

  initial begin
    test t0;
    clk       <= 0;
    _if.rst_n <= 0;
    _if.wr    <= 0;
    _if.rd    <= 0;
    @(posedge clk);
    @(posedge clk);
    _if.rst_n <= 1;
    t0 = new;
    t0.e0.vif = _if;
    t0.run();
    #5000 $finish;
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb);
  end
endmodule
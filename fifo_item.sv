class fifo_item;
 
  rand bit        wr;
  rand bit        rd;
  rand bit [7:0]  data_in;
 
  bit [7:0]  data_out;
  bit        fifo_full;
  bit        fifo_empty;
  bit        fifo_overflow;
  bit        fifo_underflow;
 
  constraint valid_op   { wr | rd; }
 
  constraint write_only { wr == 1; rd == 0; }
  constraint read_only  { wr == 0; rd == 1; }
  constraint simul_rw   { wr == 1; rd == 1; }
 
  function void print(string tag="");
    $display("T=%0t [%s] wr=%0b rd=%0b data_in=0x%0h data_out=0x%0h full=%0b empty=%0b overflow=%0b underflow=%0b",
             $time, tag, wr, rd, data_in, data_out,
             fifo_full, fifo_empty, fifo_overflow, fifo_underflow);
  endfunction
 
endclass
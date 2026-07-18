class monitor;
  virtual fifo_if  vif;
  mailbox          scb_mbx;

  task run();
    $display("T=%0t [Monitor] starting ...", $time);

    @(posedge vif.clk);
    wait(vif.rst_n === 1);
    @(posedge vif.clk);

    forever begin
      @(posedge vif.clk);

      if (vif.wr || vif.rd) begin
        fifo_item item = new;

        item.wr             = vif.wr;
        item.rd             = vif.rd;
        item.data_in        = vif.data_in;
        item.fifo_full      = vif.fifo_full;
        item.fifo_empty     = vif.fifo_empty;
        item.fifo_overflow  = vif.fifo_overflow;
        item.fifo_underflow = vif.fifo_underflow;

        if (vif.rd && !vif.fifo_empty) begin
          item.data_out = vif.data_out;
        end

        item.print("Monitor");
        scb_mbx.put(item);
      end
    end
  endtask

endclass
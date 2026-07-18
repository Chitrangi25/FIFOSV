class driver;
  virtual fifo_if  vif;
  mailbox          drv_mbx;
  event            drv_done;

  task run();
    $display("T=%0t [Driver] starting ...", $time);

    vif.wr      <= 0;
    vif.rd      <= 0;
    vif.data_in <= 0;

    @(posedge vif.clk);
    wait(vif.rst_n === 1);
    @(posedge vif.clk);

    forever begin
      fifo_item item;
      $display("T=%0t [Driver] waiting for item ...", $time);
      drv_mbx.get(item);
      item.print("Driver");

      vif.wr <= 0;
      vif.rd <= 0;

      if (item.wr && item.rd) begin
        while (vif.fifo_full || vif.fifo_empty) begin
          $display("T=%0t [Driver] waiting for not full/empty for simul ...", $time);
          @(posedge vif.clk);
        end
        vif.wr      <= 1;
        vif.rd      <= 1;
        vif.data_in <= item.data_in;
        @(posedge vif.clk);
        vif.wr <= 0;
        vif.rd <= 0;
      end

      else if (item.wr) begin
        while (vif.fifo_full) begin
          $display("T=%0t [Driver] FIFO full, waiting ...", $time);
          @(posedge vif.clk);
        end
        vif.wr      <= 1;
        vif.data_in <= item.data_in;
        @(posedge vif.clk);
        vif.wr <= 0;
      end

      else if (item.rd) begin
        while (vif.fifo_empty) begin
          $display("T=%0t [Driver] FIFO empty, waiting ...", $time);
          @(posedge vif.clk);
        end
        vif.rd <= 1;
        @(posedge vif.clk);
        vif.rd <= 0;
      end

      @(posedge vif.clk);
      ->drv_done;
    end
  endtask

endclass
class scoreboard;
  mailbox   scb_mbx;
  bit [7:0] ref_queue [$];

  task run();
    forever begin
      fifo_item item;
      scb_mbx.get(item);
      item.print("Scoreboard");

      if (item.wr && !item.rd && !item.fifo_full) begin
        ref_queue.push_back(item.data_in);
        $display("T=%0t [Scoreboard] Write 0x%0h pushed. Queue depth: %0d",
                 $time, item.data_in, ref_queue.size());
      end

      if (item.rd && !item.wr && !item.fifo_empty) begin
        if (ref_queue.size() == 0) begin
          $display("T=%0t [Scoreboard] ERROR! Read but reference queue empty", $time);
        end else begin
          bit [7:0] expected;
          expected = ref_queue.pop_front();
          if (item.data_out === expected)
            $display("T=%0t [Scoreboard] PASS! data_out=0x%0h expected=0x%0h",
                     $time, item.data_out, expected);
          else
            $display("T=%0t [Scoreboard] ERROR! data_out=0x%0h expected=0x%0h",
                     $time, item.data_out, expected);
        end
      end

      if (item.wr && !item.rd && item.fifo_full) begin
        if (item.fifo_overflow)
          $display("T=%0t [Scoreboard] PASS! Overflow correctly flagged", $time);
        else
          $display("T=%0t [Scoreboard] ERROR! Overflow not flagged on write-when-full", $time);
      end

      if (item.rd && !item.wr && item.fifo_empty) begin
        if (item.fifo_underflow)
          $display("T=%0t [Scoreboard] PASS! Underflow correctly flagged", $time);
        else
          $display("T=%0t [Scoreboard] ERROR! Underflow not flagged on read-when-empty", $time);
      end

    end
  endtask

endclass
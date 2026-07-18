class test;
  env     e0;
  mailbox drv_mbx;

  function new();
    drv_mbx = new();
    e0      = new();
  endfunction

  virtual task run();
    e0.d0.drv_mbx = drv_mbx;

    fork
      e0.run();
    join_none

    apply_stim();
  endtask

  virtual task apply_stim();
    fifo_item item;
    $display("T=%0t [Test] Starting stimulus ...", $time);

    $display("T=%0t [Test] SCENARIO 1: Writing 8 items ...", $time);
    repeat(8) begin
      item = new;
      item.write_only.constraint_mode(1);
      item.read_only.constraint_mode(0);
      item.simul_rw.constraint_mode(0);
      item.randomize();
      drv_mbx.put(item);
      @(e0.d0.drv_done);
    end

    $display("T=%0t [Test] SCENARIO 2: Reading 8 items ...", $time);
    repeat(8) begin
      item = new;
      item.write_only.constraint_mode(0);
      item.read_only.constraint_mode(1);
      item.simul_rw.constraint_mode(0);
      item.randomize();
      drv_mbx.put(item);
      @(e0.d0.drv_done); 
    end

    $display("T=%0t [Test] SCENARIO 3: Filling FIFO to full ...", $time);
    repeat(16) begin
      item = new;
      item.write_only.constraint_mode(1);
      item.read_only.constraint_mode(0);
      item.simul_rw.constraint_mode(0);
      item.randomize();
      drv_mbx.put(item);
      @(e0.d0.drv_done);
    end

    $display("T=%0t [Test] SCENARIO 4: Simultaneous read/write ...", $time);
    repeat(4) begin
      item = new;
      item.write_only.constraint_mode(0);
      item.read_only.constraint_mode(0);
      item.simul_rw.constraint_mode(1);
      item.randomize();
      drv_mbx.put(item);
      @(e0.d0.drv_done);
    end

    #200;
    $display("T=%0t [Test] Stimulus done.", $time);
  endtask

endclass
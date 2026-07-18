class env;
 
  driver      d0;
  monitor     m0;
  scoreboard  s0;
  mailbox     scb_mbx;
  virtual fifo_if vif;
 
  function new();
    d0      = new;
    m0      = new;
    s0      = new;
    scb_mbx = new();
  endfunction
 
  virtual task run();
    d0.vif     = vif;
    m0.vif     = vif;
    m0.scb_mbx = scb_mbx;
    s0.scb_mbx = scb_mbx;
 
    fork
      d0.run();
      m0.run();
      s0.run();
    join_any
  endtask
 
endclass
 
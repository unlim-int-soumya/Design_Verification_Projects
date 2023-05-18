class packet_vc extends component_base;

  agent agt;

  function new(string name, component_base parent);
    super.new(name, parent);

    agt = new("agt", this);

    $display("packet_vc created");

  endfunction

  function void configure(virtual port_if vif);
    agt.mon.vif = vif;
    agt.drv.vif = vif;

    agt.ag_seqr.portno = 2;
  endfunction

  task run(int runs);

    fork
      agt.mon.run();
    join_none

    agt.drv.run(runs);

  endtask

endclass
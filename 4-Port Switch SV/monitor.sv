class monitor extends component_base;

  virtual port_if vif;

  packet m_pkt;

  function new(string name, component_base parent);
    super.new(name, parent);    

    $display("monitor created");

  endfunction


  task run();
    forever begin
      vif.collect_packet(m_pkt);
      //m_pkt.print();
      myprint();
      m_pkt.print(BIN);
      $display("\n");
    end
  endtask

  /*
  task run();
    $display("-------Monitor------");
    $display(getname());
    print();
    $display("\n");
  endtask
  */

endclass
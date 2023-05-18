class driver extends component_base;

  sequencer seqr;

  virtual port_if vif;

  packet pkt;


  function new(string name, component_base parent);
    super.new(name, parent);

    seqr = new("seqr", this);

    $display("driver created");

  endfunction

  task run(int runs);

    repeat(runs) begin
      seqr.get_next_item(pkt);
      //pkt.print();
      myprint();
      pkt.print(BIN);
      $display("\n");
      vif.drive_packet(pkt);
    end

  endtask

endclass
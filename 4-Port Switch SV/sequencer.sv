class sequencer extends component_base;

  int portno;

  //packet pkt;
  psingle sing;
  pmulticast mult;
  pbroadcast broad;

  function new(string name, component_base parent);
    super.new(name, parent);

    $display("sequencer created");

  endfunction

  function void get_next_item(output packet pkt);

    //pkt = new();
    randcase
    //1: pkt = new("pkt", portno);
    1: begin
      sing = new("sing", portno);
      sing.randomize();
      pkt = sing;
    end
    1: begin
      mult = new("mult", portno);
      mult.randomize();
      pkt = mult;
    end
    1: begin
      broad = new("broad", portno);
      broad.randomize();
      pkt = broad;
    end
    endcase

    //portno = pkt.randomize();
    
    //portno = pkt.randomize() with {pkt.ptype inside {SINGLE, MULTICAST, BROADCAST};};
    //pkt.randomize() with {pkt.ptype != ANY;};
    //portno = pkt.randomize() with {pkt.ptype inside {SINGLE, MULTICAST, BROADCAST};};

  endfunction


endclass
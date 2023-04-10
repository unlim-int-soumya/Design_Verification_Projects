class dram_seq extends uvm_sequence#(dram_seq_item);
  `uvm_object_utils(dram_seq)
  dram_seq_item pkt;


  function new(string name="dram_seq");
    super.new(name);
  endfunction

  bit data = 1'b1;

  task body();

    pkt=dram_seq_item::type_id::create("pkt");
    repeat(50) begin

      //#5;
      $display("SEQ: time=%0t", $time);

      start_item(pkt);

      assert(pkt.randomize());
      pkt.gwe=1;
      pkt.reg_we = 1;
      $display("Below packet");
      pkt.print();
      $display("SEQ: reg_we=%0b gwe=%0b next_pc=%0d", pkt.reg_we, pkt.gwe, pkt.next_pc);

      //data = ~data;

      pkt.reg_we = data;

      finish_item(pkt);

      `uvm_info("SEQ","SEQUENCE TRANSACTIONS",UVM_NONE);

      #15;

    end

  endtask



endclass

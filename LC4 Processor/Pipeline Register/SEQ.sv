class dram_seq extends uvm_sequence#(dram_seq_item);
  `uvm_object_utils(dram_seq)
  dram_seq_item pkt;


  function new(string name="dram_seq");
    super.new(name);
  endfunction

  

  task body();

    pkt=dram_seq_item::type_id::create("pkt");
    repeat(50) begin

      //#5;
      $display("SEQ: time=%0t", $time);

      start_item(pkt);

      assert(pkt.randomize());
      pkt.gwe=1;

      $display("Below packet");
      pkt.print();
      
      `uvm_info("SEQ", $sformatf("Input item %s",pkt.input2str()), UVM_HIGH)


      finish_item(pkt);

      `uvm_info("SEQ","SEQUENCE TRANSACTIONS",UVM_NONE);

      #15;

    end

  endtask



endclass

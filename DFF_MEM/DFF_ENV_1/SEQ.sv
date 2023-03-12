class dff_seq extends uvm_sequence#(dff_seq_item);

  `uvm_object_utils(dff_seq)

  dff_seq_item pkt;


  function new(string name="dff_seq");
    super.new(name);
  endfunction



  task body();

    pkt=dff_seq_item::type_id::create("pkt");
  
    repeat(10) begin
    
      start_item(pkt);

      assert(pkt.randomize());
      pkt.rw=0;
      pkt.print();
      
      finish_item(pkt);
    
      start_item(pkt);
      pkt.rw=1;
      pkt.print();
      finish_item(pkt);
 
    
      //Reading overwrite
      start_item(pkt);
      pkt.rw=1;
      pkt.print();
      finish_item(pkt);
    
      `uvm_info("SEQ","SEQUENCE TRANSACTIONS",UVM_NONE);
    end
  
  endtask

endclass

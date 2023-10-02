//++++++++++++++++++++++++//
//		 	AXI_SEQ		  //
//++++++++++++++++++++++++//

class axi_seq extends uvm_sequence#(axi_tx);

  `uvm_object_utils(axi_seq)

  function new(string name = "axi_seq");
    super.new(name);
  endfunction

  virtual task body();
    `uvm_info(get_type_name(), "Inside body of axi_seq", UVM_HIGH)
  endtask

    task pre_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
    // in UVM1.2, get starting phase from method
    phase = get_starting_phase();
    `else
    phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.raise_objection(this, get_type_name());
      `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
    end
  endtask : pre_body

  task post_body();
    uvm_phase phase;
    `ifdef UVM_VERSION_1_2
    // in UVM1.2, get starting phase from method
    phase = get_starting_phase();
    `else
    phase = starting_phase;
    `endif
    if (phase != null) begin
      phase.drop_objection(this, get_type_name());
      `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
    end
  endtask : post_body
 
  
endclass


class axi_5_seq extends axi_seq;

  `uvm_object_utils(axi_5_seq)

  function new(string name = "axi_5_seq");
    super.new(name);
  endfunction

  int i;
  axi_tx txQ[$];

  // Sequence body definition
  virtual task body();
    `uvm_info(get_type_name(), "Inside the body", UVM_HIGH)

    // Sends 5 write transactions
    for(i=0; i < 5; i++) begin
      `uvm_create(req);
      assert(req.randomize() with { wr_rd == WRITE; brust_type == INCR;});
      `uvm_send(req);
      txQ[i] = req;
    end
   

    // Sends 5 Read transactions 
    for(i=0; i < 5; i++) begin
      `uvm_create(req);
      assert(req.randomize() with {wr_rd == READ; addr == txQ[i].addr; len == txQ[i].len; brust_size == txQ[i].brust_size; brust_type == txQ[i].brust_type;});
      `uvm_send(req);
    end

  endtask

endclass

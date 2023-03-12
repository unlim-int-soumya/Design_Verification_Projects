class dff_seqr extends uvm_sequencer#(dff_seq_item);


  `uvm_component_utils(dff_seqr)

  function new(string name="dff_seqr",uvm_component parent);
    super.new(name,parent);
  endfunction

endclass

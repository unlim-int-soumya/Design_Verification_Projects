class dff_seq_item extends uvm_sequence_item;
  
  `uvm_object_utils(dff_seq_item)


  rand bit[7:0] data;
  rand bit[5:0] addr;
  bit rw;


  function new(string name="dff_seq_item");
    super.new(name);
  endfunction

endclass

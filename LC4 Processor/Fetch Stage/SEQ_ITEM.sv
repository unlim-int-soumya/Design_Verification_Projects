class dram_seq_item extends uvm_sequence_item;

  `uvm_object_utils(dram_seq_item)

  function new(string name="dram_seq_item");
    super.new(name);
  endfunction

  rand bit [15:0] next_pc;
  bit reg_we, gwe;
  bit [15:0] pc;
  bit [1:0] test_stall_f;

endclass

class transaction extends uvm_sequence_item;

  
  `uvm_object_utils(transaction)
  
  //Inputs
  rand bit [15:0] insn;

  //Outputs
  bit [ 2:0] r1sel;              // rs
  bit        r1re;               // does this instruction read from rs?
  bit [ 2:0] r2sel;              // rt
  bit        r2re;               // does this instruction read from rt?
  bit [ 2:0] wsel;               // rd
  bit        regfile_we;         // does this instruction write to rd?
  bit        nzp_we;             // does this instruction write the NZP bits?
  bit        select_pc_plus_one; // route PC+1 to the ALU instead of rs?
  bit        is_load;            // is this a load instruction?
  bit        is_store;           // is this a store instruction?
  bit        is_branch;          // is this a branch instruction?
  bit        is_control_insn;  

  function new(input string path = "transaction");
    super.new(path);
  endfunction

  /*
  `uvm_object_utils_begin(transaction)
  `uvm_field_int(a, UVM_DEFAULT)
  `uvm_field_int(b, UVM_DEFAULT)
  `uvm_field_int(c, UVM_DEFAULT)
  `uvm_field_int(d, UVM_DEFAULT)
  `uvm_field_int(sel, UVM_DEFAULT)
  `uvm_field_int(y, UVM_DEFAULT)
  `uvm_object_utils_end
*/

endclass

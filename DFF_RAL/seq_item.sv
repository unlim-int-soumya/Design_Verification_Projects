class seq_item extends uvm_sequence_item;
  rand bit [7:0] addr;
  rand bit [7:0] data;
  rand bit rw; // rd_or_wr = 0 (Write)
                     // rd_or_wr = 1 (Read)
  
  function new(string name = "seq_item");
    super.new(name);
  endfunction
  
  `uvm_object_utils_begin(seq_item)
    `uvm_field_int(addr,     UVM_ALL_ON)
    `uvm_field_int(data,     UVM_ALL_ON)
  `uvm_field_int(rw, UVM_ALL_ON)
  `uvm_object_utils_end
  
  constraint addr_c { 0<= addr <= 255;}
  constraint rd_or_wr_c {rw dist {1:=30, 0:=70};} 
endclass


class ip_data extends seq_item;
  
  randc logic [7:0] m_data;
  
  function new(string name="ip_data");
    super.new(name);
  endfunction
  
  `uvm_object_utils_begin(ip_data)
  `uvm_field_int(m_data,     UVM_ALL_ON)
  `uvm_object_utils_end
  
endclass
  




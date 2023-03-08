class base_seq extends uvm_sequence#(seq_item);
  
  seq_item req;
  
  `uvm_object_utils(base_seq)
  
  function new (string name = "base_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_info(get_type_name(), "Base seq: Inside Body", UVM_LOW);
    `uvm_do(req);
  endtask
endclass

class reg_seq extends uvm_sequence#(seq_item);
  seq_item req;
  RegModel_SFR reg_model;
  uvm_status_e   status;
  uvm_reg_data_t read_data;
  `uvm_object_utils(reg_seq)
  
  function new (string name = "reg_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_info(get_type_name(), "Reg seq: Inside Body", UVM_LOW);
    if(!uvm_config_db#(RegModel_SFR) :: get(uvm_root::get(), "", "reg_model", reg_model))
      `uvm_fatal(get_type_name(), "reg_model is not set at top level");
    
  endtask
endclass


class control_seq extends base_seq #(ip_data);
  `uvm_object_utils(control_seq)
  
  function new (string name = "control_seq");
    super.new(name);
  endfunction  

  RegModel_SFR reg_model;
  uvm_status_e   status;
  uvm_reg_data_t read_data;  
  
  ip_data dt;

  
  task body();
    
    integer i;
    
    repeat(50) begin
    
       
      `uvm_info(get_type_name(), "Reg seq: Inside Body", UVM_LOW);
      if(!uvm_config_db#(RegModel_SFR) :: get(uvm_root::get(), "", "reg_model", reg_model))
        `uvm_fatal(get_type_name(), "reg_model is not set at top level");
      
      
      dt = ip_data::type_id::create("dt");
      dt.randomize() with { 32'h00 <= m_data <= 32'hff;}; 
      
      i = $urandom_range(0, 255);
      reg_model.mod_reg.control_reg[i].write(status,dt.m_data);
      reg_model.mod_reg.control_reg[i].read(status, read_data);
      reg_model.mod_reg.control_reg[i].predict(dt.m_data);
      reg_model.mod_reg.control_reg[i].mirror(status, UVM_CHECK);   
      
      #5;
      
    end
  
  endtask
  
endclass


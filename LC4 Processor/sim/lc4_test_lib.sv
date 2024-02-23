class base_test extends uvm_test;

`uvm_component_utils(base_test)

lc4_env lc4;

virtual lc4_interface vif;


function new(string name, uvm_component parent = null);
  super.new(name, parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info(get_type_name(),"Build Phase Executed", UVM_LOW)

  lc4 = lc4_env::type_id::create("lc4", this);

  if(!uvm_config_db #(virtual lc4_interface)::get(this,"", "pif", vif)) begin
    `uvm_error("NOVIF @ BASE_TEST", "vif not set")
  end

endfunction

task run_phase(uvm_phase phase); 
  `uvm_info(get_type_name(),"Run Phase Executed", UVM_LOW)
endtask
  
function void end_of_elaboration_phase(uvm_phase phase);
  uvm_top.print_topology();
endfunction

endclass


class lc4_5_test extends base_test;

`uvm_component_utils(lc4_5_test)

function new(string name = "lc4_5_test", uvm_component parent);
  super.new(name, parent);
endfunction
  
function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  uvm_config_wrapper::set(this, "lc4.agent.sequencer.run_phase", "default_sequence", lc4_5_seq::get_type());
endfunction

endclass

class mixed_test extends base_test;

`uvm_component_utils(mixed_test)

function new(string name = "mixed_test", uvm_component parent);
  super.new(name, parent);
endfunction
  
function void build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
  super.run_phase(phase);
  uvm_config_wrapper::set(this, "lc4.agent.sequencer.run_phase", "default_sequence", mixed_seq::get_type());
endtask


endclass


class cond_loop_test extends base_test;

`uvm_component_utils(cond_loop_test)

function new(string name = "cond_loop_test", uvm_component parent);
  super.new(name, parent);
endfunction
  
function void build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
  super.run_phase(phase);
  uvm_config_wrapper::set(this, "lc4.agent.sequencer.run_phase", "default_sequence", conditional_loop_seq::get_type());
endtask


endclass



class load_store_test extends base_test;

`uvm_component_utils(load_store_test)

function new(string name = "load_store_test", uvm_component parent);
  super.new(name, parent);
endfunction
  
function void build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
  super.run_phase(phase);

  //lc4.agent.driver.set_report_verbosity_level(UVM_HIGH);
  lc4.agent.driver.set_report_verbosity_level(UVM_HIGH);
  lc4.agent.monitor.set_report_verbosity_level(UVM_HIGH);

  //repeat(1) @(posedge vif.clk);
  uvm_config_wrapper::set(this, "lc4.agent.sequencer.run_phase", "default_sequence", load_store_seq::get_type());
endtask


endclass



class store_load_no_depen_test extends base_test;

`uvm_component_utils(store_load_no_depen_test)

function new(string name = "store_load_no_depen_test", uvm_component parent);
  super.new(name, parent);
endfunction
  
function void build_phase(uvm_phase phase);
  super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
  super.run_phase(phase);

  //lc4.agent.driver.set_report_verbosity_level(UVM_HIGH);
  lc4.agent.driver.set_report_verbosity_level(UVM_HIGH);
  lc4.agent.monitor.set_report_verbosity_level(UVM_HIGH);

  //repeat(1) @(posedge vif.clk);
  uvm_config_wrapper::set(this, "lc4.agent.sequencer.run_phase", "default_sequence", store_load_no_depen_seq::get_type());
endtask


endclass

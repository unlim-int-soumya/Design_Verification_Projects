`include "package.sv"
class base_test extends uvm_test;
  env env_o;
  `uvm_component_utils(base_test)
  
  function new(string name = "base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env_o = env::type_id::create("env_o", this);
  endfunction
  
  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    test_imp();
    
     //env_0.reg_model.set_report_verbosity_level (UVM_HIGH);
    
    phase.drop_objection(this);
    `uvm_info(get_type_name, "End of testcase", UVM_LOW);
  endtask
  
  virtual task test_imp();
    base_seq bseq = base_seq::type_id::create("bseq");
        
    repeat(10) begin 
      #5; bseq.start(env_o.agt.seqr);
    end
  endtask
  
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    uvm_top.print_topology();
  endfunction
endclass

class reg_test extends base_test;
  `uvm_component_utils(reg_test)
  
  function new(string name = "reg_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  task test_imp();
    reg_seq rseq = reg_seq::type_id::create("rseq");
    
    control_seq cseq = control_seq::type_id::create("cseq");
    //msk_seq mseq = msk_seq::type_id::create("mseq");
    //debug_seq dseq = debug_seq::type_id::create("dseq");
    
    cseq.start(env_o.agt.seqr);
    //mseq.start(env_o.agt.seqr);
    //dseq.start(env_o.agt.seqr);
    
    //rseq.start(env_o.agt.seqr);
  endtask
endclass
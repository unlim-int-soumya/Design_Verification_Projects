class dff_test extends uvm_test;
  
  `uvm_component_utils(dff_test)

  dff_env env;


  function new(string name="dff_test",uvm_component parent);
		super.new(name,parent);
  endfunction


  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env=dff_env::type_id::create("env",this);
  endfunction

  task run_phase(uvm_phase phase);
    dff_seq seq;
    seq=dff_seq::type_id::create("seq",this);

    phase.raise_objection(this);
    seq.start(env.agent1.seqr);
    #50;
    phase.drop_objection(this);
  endtask

endclass


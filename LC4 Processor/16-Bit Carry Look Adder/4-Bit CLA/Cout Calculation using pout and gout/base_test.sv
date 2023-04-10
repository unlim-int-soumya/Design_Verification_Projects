

`include "env.sv"

class base_test extends uvm_test;

  `uvm_component_utils(base_test)

  function new(string name = "base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  //previously I left writing instantiating sequence item
  gen_item_seq seq;
  env e0;
  virtual des_if vif;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    //Creating the environment
    
    e0=env::type_id::create("e0", this);

    if(!uvm_config_db #(virtual des_if)::get(this, "", "des_if", vif))
      `uvm_fatal("TEST", $sformatf("Couldn't get vif"))

    uvm_config_db #(virtual des_if)::set(this, "e0.a0.*", "des_if", vif); 

    //creating the sequence to be sent to driver
    seq = gen_item_seq::type_id::create("seq", this);
    seq.randomize();
  
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);  //I left writing this
    //apply_reset();
    seq.start(e0.a0.s0);
    #200;
    phase.drop_objection(this);   //Left writing this
  endtask

endclass

class test_1011 extends base_test;

	`uvm_component_utils(test_1011)

	function new(string name = "test_1011", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
      seq.randomize with {num inside {[500:800]};};
	endfunction

endclass


class test_2 extends base_test;

  `uvm_component_utils(test_2)

  function new(string name = "test_2", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
      seq.randomize with {num inside {[200:500]};};
	endfunction

endclass

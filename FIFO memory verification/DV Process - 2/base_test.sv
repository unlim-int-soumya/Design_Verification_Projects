`ifndef LENGTH
 `define LENGTH 4
`endif

`include "env.sv"
//`include "sequence.sv"

class base_test extends uvm_test;
  
	`uvm_component_utils(base_test)

	function new(string name = "base_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	env e0;
	gen_item_seq seq;
	virtual des_if vif;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	
		e0 = env::type_id::create("e0", this);
		
		if(!uvm_config_db #(virtual des_if)::get(this, "", "des_if", vif))
			`uvm_fatal("TEST", $sformatf("Couldn't get vif"))
		uvm_config_db #(virtual des_if)::set(this, "e0.a0.*", "des_if", vif);
      
      	seq = gen_item_seq::type_id::create("seq");
		seq.randomize(); 

      
	endfunction

	virtual task run_phase(uvm_phase phase);
		//super.run_phase(phase);
      	//seq = gen_item_seq::type_id::create("seq");
      phase.raise_objection(this);
		apply_reset();
      //seq.randomize();
		seq.start(e0.a0.s0);
		#200;
		phase.drop_objection(this);
	endtask

	virtual task apply_reset();
		vif.rstn <= 0;
		vif.enq <= 0;
      	vif.deq <= 0;
      	vif.din <= 0;
      repeat(5) @ (posedge vif.clk);
		vif.rstn <= 1;
      repeat(10) @ (posedge vif.clk);
	endtask

endclass


class test_1011 extends base_test;

	`uvm_component_utils(test_1011)

	function new(string name = "test_1011", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		seq.randomize with {num inside {[30:50]};};
	endfunction

endclass

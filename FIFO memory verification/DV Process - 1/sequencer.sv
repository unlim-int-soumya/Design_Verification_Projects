/***********************************************
* sequencer 
***********************************************/
class rst_sequencer extends uvm_sequencer #(rst_transaction);
	`uvm_component_utils(rst_sequencer)
  
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction
endclass : rst_sequencer

class data_sequencer extends uvm_sequencer #(data_transaction);
	`uvm_component_utils(data_sequencer)
  
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction
endclass : data_sequencer
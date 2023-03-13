
/***********************************************
* scoreboard 
***********************************************/
class my_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(my_scoreboard);

  uvm_blocking_get_port #(data_transaction) exp_port;
  uvm_blocking_get_port #(data_transaction) act_port;	
	data_transaction tr_act, tr_exp;
	bit result;
	
	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction	
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		exp_port = new("exp_port", this);
		act_port = new("act_port", this);		
	endfunction
	
	task run_phase(uvm_phase phase);
		forever
		begin
			exp_port.get(tr_exp);
			act_port.get(tr_act);
			result = tr_exp.compare(tr_act);
			if (result)
				$display("Compare SUCCESSFULLY");
			else
            	`uvm_warning("WARNING", "Compare FAILED")
			$display("The expected data is");
			tr_exp.print();
			$display("The actual data is");
			tr_act.print();	
		end
	endtask		
endclass : my_scoreboard

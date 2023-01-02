class scoreboard extends uvm_scoreboard;

  `uvm_component_utils(scoreboard)

  function new(string name = "scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  bit ref_sum;
  bit ref_cout;
  uvm_analysis_imp #(Item, scoreboard) m_analysis_imp;
  virtual des_if vif;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual des_if)::get(this, "", "des_if", vif))
      `uvm_info("SCBD", $sformatf("Couldn't get vif"), UVM_HIGH)

    m_analysis_imp = new("m_analysis_imp", this);
  endfunction

  virtual function void write(Item item);
    
    /*
      ref_cout = 1'b1;
      ref_sum = 1'b1; */
    
	if(!item.rstn) begin
		ref_sum = 0;
      	ref_cout = 0; 
    end else begin
     // ref_cout = 1'b1;
      //ref_sum = 1'b1;
      {ref_cout, ref_sum} = item.a + item.b + item.cin;
	end 

      //Output matching
      if(item.sum!=ref_sum)
        `uvm_error("SCBD", $sformatf("FAIL! SUM not matched item.a=%0b item.b=%0b item.cin=%0b item.rstn=%0b item.sum=%0b ref_sum=%b", item.a, item.b,item.cin,item.rstn, item.sum, ref_sum))
      else
        `uvm_info("SCBD", $sformatf("PASS! SUM matched item.a=%0b item.b=%0b item.cin=%0b item.rstn=%0b item.sum=%0b ref_sum=%b", item.a, item.b,item.cin,item.rstn, item.sum, ref_sum), UVM_HIGH)

      //Output matching
      if(item.cout!=ref_cout)
        `uvm_error("SCBD", $sformatf("FAIL! COUT not matched item.a=%0b item.b=%0b item.cin=%0b item.rstn=%0b item.cout=%0b ref_cout=%b", item.a, item.b,item.cin, item.rstn, item.cout, ref_cout))
      else
        `uvm_info("SCBD", $sformatf("PASS! COUT matched item.a=%0b item.b=%0b item.cin=%0b item.rstn=%0b item.cout=%0b ref_cout=%b", item.a, item.b,item.cin, item.rstn, item.cout, ref_cout), UVM_HIGH)

  endfunction

endclass

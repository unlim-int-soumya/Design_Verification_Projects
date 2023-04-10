class scoreboard extends uvm_scoreboard;

  `uvm_component_utils(scoreboard)

  function new(string name = "scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  bit [15:0] ref_sum;
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
    
    {ref_cout, ref_sum} = item.a + item.b + item.cin;
    
    //Output matching
    if(item.sum!=ref_sum)
      `uvm_error("SCBD", $sformatf("sum FAIL! SUM not matched item.a=%0b item.b=%0b item.cin=%0b item.sum=%0b item.cout=%0b ref_sum=%0b ref_cout=%0b", item.a, item.b, item.cin, item.sum, item.cout, ref_sum, ref_cout))
      else
        `uvm_info("SCBD", $sformatf("sum PASS! SUM matched item.a=%0b item.b=%0b item.cin=%0b item.sum=%0b item.cout=%0b ref_sum=%0b ref_cout=%0b", item.a, item.b, item.cin, item.sum, item.cout, ref_sum, ref_cout), UVM_HIGH)
        
    if(item.cout!=ref_cout)
      `uvm_error("SCBD", $sformatf("cout FAIL! COUT matched item.a=%0b item.b=%0b item.cin=%0b item.sum=%0b item.cout=%0b ref_sum=%0b ref_cout=%0b", item.a, item.b, item.cin, item.sum, item.cout, ref_sum, ref_cout))
      else
        `uvm_info("SCBD", $sformatf("cout PASS! COUT matched item.a=%0b item.b=%0b item.cin=%0b item.sum=%0b item.cout=%0b ref_sum=%0b ref_cout=%0b", item.a, item.b, item.cin, item.sum, item.cout, ref_sum, ref_cout), UVM_HIGH)
        
        endfunction

endclass

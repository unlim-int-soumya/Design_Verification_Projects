class scoreboard extends uvm_scoreboard;

  `uvm_component_utils(scoreboard)

  function new(string name = "scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  bit [2:0] ref_cout;
  bit ref_gout, ref_pout;
  
  uvm_analysis_imp #(Item, scoreboard) m_analysis_imp;
  virtual des_if vif;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual des_if)::get(this, "", "des_if", vif))
      `uvm_info("SCBD", $sformatf("Couldn't get vif"), UVM_HIGH)

    m_analysis_imp = new("m_analysis_imp", this);
  endfunction

  virtual function void write(Item item);
    
    ref_cout[0] = item.gin[0] | (item.pin[0]&item.cin);
    ref_cout[1] = item.gin[1] | (item.pin[1]&ref_cout[0]);
    ref_cout[2] = item.gin[2] | (item.pin[2]&ref_cout[1]);

    if(item.gin >= 4'b1000) begin
      ref_gout = 1'b1;
    end else begin
      if((item.pin >= 4'b1000 && item.gin >= 4'b0100) || (item.pin>=4'b1100 && item.gin >=4'b0010) || (item.pin>=4'b1110 && item.gin >=4'b0001) ) begin
        ref_gout = 1'b1;
      end else begin
		ref_gout = 1'b0;
      end
    end

    ref_pout = & item.pin;
    
    //Output matching
    if(item.cout!=ref_cout)
      `uvm_error("SCBD", $sformatf("cout FAIL! cout not matched gin=%0b	pin=%0b	cin = %0b gout=%0b	pout=%0b cout=%0b ref_cout=%0b ref_gout=%0b ref_pout=%0b", item.gin, item.pin, item.cin, item.gout, item.pout, item.cout, ref_cout, ref_gout, ref_pout))
      else
        `uvm_info("SCBD", $sformatf("cout PASS! cout matched gin=%0b	pin=%0b	cin = %0b gout=%0b	pout=%0b cout=%0b ref_cout=%0b ref_gout=%0b ref_pout=%0b", item.gin, item.pin, item.cin, item.gout, item.pout, item.cout, ref_cout, ref_gout, ref_pout), UVM_HIGH)
        
     //gout matching   
        if(item.gout!=ref_gout)
          `uvm_error("SCBD", $sformatf("gout FAIL! gout not matched gin=%0b	pin=%0b	cin = %0b gout=%0b	pout=%0b cout=%0b ref_cout=%0b ref_gout=%0b ref_pout=%0b", item.gin, item.pin, item.cin, item.gout, item.pout, item.cout, ref_cout, ref_gout, ref_pout))
      else
        `uvm_info("SCBD", $sformatf("gout PASS! gout matched gin=%0b	pin=%0b	cin = %0b gout=%0b	pout=%0b cout=%0b ref_cout=%0b ref_gout=%0b ref_pout=%0b", item.gin, item.pin, item.cin, item.gout, item.pout, item.cout, ref_cout, ref_gout, ref_pout), UVM_HIGH)        
        
        
     //pout matching   
        if(item.pout!=ref_pout)
          `uvm_error("SCBD", $sformatf("pout FAIL! pout not matched gin=%0b	pin=%0b	cin = %0b gout=%0b	pout=%0b cout=%0b ref_cout=%0b ref_gout=%0b ref_pout=%0b", item.gin, item.pin, item.cin, item.gout, item.pout, item.cout, ref_cout, ref_gout, ref_pout))
      else
        `uvm_info("SCBD", $sformatf("pout PASS! pout matched gin=%0b	pin=%0b	cin = %0b gout=%0b	pout=%0b cout=%0b ref_cout=%0b ref_gout=%0b ref_pout=%0b", item.gin, item.pin, item.cin, item.gout, item.pout, item.cout, ref_cout, ref_gout, ref_pout), UVM_HIGH)              
        endfunction

endclass

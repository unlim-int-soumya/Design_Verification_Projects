class traffic_scoreboard extends uvm_scoreboard;
  
    `uvm_component_utils (traffic_scoreboard)

  bit [7:0] result;

    seq_item tr_in;

    RegModel_SFR m_ral_model;

  uvm_analysis_imp #(seq_item, traffic_scoreboard) apb_export;
 
    function new (string name = "traffic_scoreboard", uvm_component parent = null);
      super.new (name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        apb_export = new ("apb_export", this);
    endfunction

  virtual function void write (seq_item t);
        tr_in = seq_item::type_id::create("tr_in", this);
        tr_in.copy(t);

    if (!tr_in.rw) begin
      `uvm_info(get_type_name(), $sformatf("scoreboard running"), UVM_LOW)
      
         
      //result = m_ral_model.mod_reg.control_reg[ir_in.addr].get_mirrored_value();
      
    end
    
                /*
    if (result == tr_in.data) begin          
      `uvm_info("MATCH", $sformatf("[MATCH]"), UVM_LOW)        
    end else begin         
      `uvm_error("REGISTER ERROR:", $sformatf("[MISSMATCH] Expected data value %0h actual %0h", result, tr_in.data))        
    end
    */
          

    endfunction
endclass
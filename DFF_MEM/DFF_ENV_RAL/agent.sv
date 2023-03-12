class agent extends uvm_agent;
  `uvm_component_utils(agent)
  driver drv;
  seqcr seqr;
  
  uvm_analysis_port #(seq_item) ag_ap;
  
  
  
  monitor mon;
  
  function new(string name = "agent", uvm_component parent = null);
    super.new(name, parent);
    ag_ap = new("ag_ap", this);
    
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    if(get_is_active == UVM_ACTIVE) begin 
      drv = driver::type_id::create("drv", this);
      seqr = seqcr::type_id::create("seqr", this);
    end
    
    mon = monitor::type_id::create("mon", this);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    if(get_is_active == UVM_ACTIVE) begin 
      drv.seq_item_port.connect(seqr.seq_item_export);
      
       mon.ap_mon.connect(ag_ap);
      
    end
  endfunction
endclass
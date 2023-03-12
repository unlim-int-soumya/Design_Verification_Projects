class monitor extends uvm_monitor;
  virtual sfr_if vif;
  
  //uvm_analysis_port #(seq_item) item_collect_port;
  uvm_analysis_port #(seq_item) ap_mon;
  
  seq_item m_item;
  
  `uvm_component_utils(monitor)
  
  function new(string name = "monitor", uvm_component parent = null);
    super.new(name, parent);
    //item_collect_port = new("item_collect_port", this);
    
    ap_mon=new("ap_mon",this);
    m_item = new();
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual sfr_if) :: get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "Not set at top level");
  endfunction
  
  task run_phase (uvm_phase phase);

    forever begin
      
      @(posedge vif.clk);
      
      m_item.addr = vif.address_in;
      m_item.rw = vif.rw;
      
      if(vif.rw) begin
        m_item.data = vif.data_out;
      end else begin
        m_item.data = vif.data_in;
      end
      
      
      //@(posedge vif.clk);
      
      ap_mon.write(m_item);
      //item_collect_port.write(m_item);
      
       @(posedge vif.clk);
      
    end

  endtask
endclass
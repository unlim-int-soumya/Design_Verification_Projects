class driver extends uvm_driver#(seq_item);
  virtual sfr_if vif;
  `uvm_component_utils(driver)
  
  //uvm_analysis_port #(seq_item) drv2sb;
  
  function new(string name = "driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual sfr_if) :: get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "Not set at top level");
    
    //drv2sb=new("drv2sb",this);
  endfunction
  
  task run_phase (uvm_phase phase);
    forever begin
      // Driver to the DUT
      seq_item_port.get_next_item(req);
      
      //@(posedge vif.clk);
      //drv2sb.write(req);
      
      //void'(req.randomize());
      // Driving Logic
      //@(posedge vif.clk); //(Due to this loosing sync with scoreboard)
      vif.address_in = req.addr;
      vif.rw <= req.rw;
      
      
      if(!req.rw) begin // Read Operation
       
        req.data = vif.data_out;        
        
        @(posedge vif.clk);
        `uvm_info(get_type_name, $sformatf("\naddr = %0h, data_out = %0h rw=%0b\n", req.addr, req.data, req.rw), UVM_LOW);
        
      end else begin // Write Operation
        
        vif.data_in <= req.data;
        
        @(posedge vif.clk);
 
        `uvm_info(get_type_name, $sformatf("\naddr = %0h, data_in= %0h rw=%0b\n", req.addr, req.data, req.rw), UVM_LOW);
      end
      seq_item_port.item_done();   
      
       //@(posedge vif.clk);
      
    end
  endtask
endclass


class dff_drv extends uvm_driver #(dff_seq_item);

  `uvm_component_utils(dff_drv)
  
  virtual intif inf;
  
  dff_seq_item pkt;
  
  

  function new(string name="dff_drv",uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db #(virtual intif)::get(this,"","inf",inf);
  endfunction


  task run_phase(uvm_phase phase);
    //dram_seq_item pkt;
    //pkt=dram_seq_item::type_id::create("pkt");
    forever begin
      seq_item_port.get_next_item(pkt);
      
      //pkt.en=1;
      
      @(posedge inf.clk);

      inf.rw=pkt.rw;
      inf.address_in=pkt.addr;
      
      
      if(pkt.rw==0) begin
   
        inf.data_in=pkt.data;
        `uvm_info("DRV TRANSACTIONS", $sformatf("inf.data_in=%d,inf.address_in=%d, inf.rw=%b",inf.data_in,inf.address_in,inf.rw) ,UVM_NONE);
        
      end 
     

      @(posedge inf.clk);
      //@(negedge inf.clk);
      
      seq_item_port.item_done();
      
      `uvm_info("DRV","DRV TRANSACTION TO DUT",UVM_NONE);
      #5;
    end
  endtask

endclass

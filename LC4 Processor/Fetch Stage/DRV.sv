class dram_drv extends uvm_driver #(dram_seq_item);

  `uvm_component_utils(dram_drv)
  
  virtual intif inf;
  
  dram_seq_item pkt;
  
  function new(string name="dram_drv",uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db #(virtual intif)::get(this,"","inf",inf);
  endfunction


  task run_phase(uvm_phase phase);

    forever begin
      
      seq_item_port.get_next_item(pkt);
      
      $display("DRV: time=%0t", $time);
     
      #5;
      
      inf.gwe=pkt.gwe;
      inf.reg_we = pkt.reg_we;
      inf.next_pc = pkt.next_pc;
      
      seq_item_port.item_done();
      
      $display("DRV: inf.gwe=%0b inf.reg_we=%0b inf.next_pc=%0b", inf.gwe, inf.reg_we, inf.next_pc);
      
      `uvm_info("DRV","DRV TRANSACTION TO DUT",UVM_NONE);

    end
  endtask

endclass

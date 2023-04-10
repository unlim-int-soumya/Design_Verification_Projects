class dram_mon1 extends uvm_monitor;

  `uvm_component_utils(dram_mon1)

  dram_seq_item pkt;

  virtual intif inf;


  uvm_analysis_port #(dram_seq_item) item_collected_port;

  uvm_analysis_port #(dram_seq_item) custom_ap;


  function new(string name="dram_mon1",uvm_component parent);
    super.new(name,parent);
  endfunction


  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db #(virtual intif) ::get(this,"","inf",inf);
    item_collected_port=new("item_collected_port",this);
    custom_ap = new("analysis_port",this);
  endfunction

  task run_phase(uvm_phase phase);
    pkt=dram_seq_item::type_id::create("pkt");
    forever begin      
      
      //#54;
      
      #7;
      //#60;
      
      
     
      pkt.reg_we <= inf.reg_we;
      pkt.gwe <= inf.gwe;
      pkt.next_pc <= inf.next_pc;
      
      pkt.pc <= inf.pc;
      pkt.test_stall_f <= inf.test_stall_f;
     
      
      $display("MON: time=%0t", $time);
      
      `uvm_info("MON1",$sformatf("PKT: pkt.reg_we=%0b, pkt.gwe=%0b pkt.next_pc=%0d pkt.pc=%0d pkt.test_stall_f=%0b", pkt.reg_we,pkt.gwe,pkt.next_pc, pkt.pc, pkt.test_stall_f),UVM_LOW);
      

      `uvm_info("MON1","MON1 TRANSACTIONS" ,UVM_NONE);
      //end
      `uvm_info("MON","MON TRANSACTIONS",UVM_NONE);
      
      #3;
      
      item_collected_port.write(pkt);
       
      custom_ap.write (pkt);
    end
  endtask
endclass

class dff_mon2 extends uvm_monitor;
  
  `uvm_component_utils(dff_mon2)


  dff_seq_item pkt1;


  virtual intif inf;
  
  bit [7:0] rdata;
  bit m_rw;
  bit [7:0] m_addr;
  logic [7:0] m_data;
  
  uvm_analysis_port #(dff_seq_item)item_collected_port1;

  function new(string name="dff_mon2",uvm_component parent);
    super.new(name,parent);
    item_collected_port1=new("item_collected_port1",this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db #(virtual intif)::get(this,"","inf",inf);
  endfunction

  task run_phase(uvm_phase phase);
    pkt1=dff_seq_item::type_id::create("pkt1", this);
    
    forever begin
      #2;
      @(posedge inf.clk); //begin
      
      //if(inf.rw==1) begin  
      
      pkt1.rw=inf.rw;
        
      pkt1.addr=inf.address_in;  
      pkt1.data = inf.data_out;
      //end
        
          `uvm_info("MON2","MON2 TRANSACTIONS",UVM_NONE)
        $display("pkt1.rw=%0b pkt1.data =%0d pkt1.addr", pkt1.rw, pkt1.data, pkt1.addr);
        //end
      //end
      
      `uvm_info("MON","MON TRANSACTIONS",UVM_NONE)
      
      @(posedge inf.clk)
        
        //if(inf.rw==1) begin
          item_collected_port1.write(pkt1);
        //end
        
      //end
    end
  endtask

endclass

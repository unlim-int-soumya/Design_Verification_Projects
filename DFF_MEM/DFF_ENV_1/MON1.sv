class dff_mon1 extends uvm_monitor;

  `uvm_component_utils(dff_mon1)

  dff_seq_item pkt;

  virtual intif inf;


  uvm_analysis_port #(dff_seq_item) item_collected_port;

  uvm_analysis_port #(dff_seq_item) custom_ap;


  function new(string name="dff_mon1",uvm_component parent);
    super.new(name,parent);
  endfunction


  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db #(virtual intif) ::get(this,"","inf",inf);
    item_collected_port=new("item_collected_port",this);
    custom_ap = new("analysis_port",this);
  endfunction

  task run_phase(uvm_phase phase);
    pkt=dff_seq_item::type_id::create("pkt");
    forever begin
      #5;
      @(posedge inf.clk);
      
      if(inf.rw==0) begin
        
        pkt.rw=inf.rw;
        pkt.data=inf.data_in;
        pkt.addr=inf.address_in;	
        `uvm_info("MON1","MON1 TRANSACTIONS" ,UVM_NONE);
      end
      `uvm_info("MON","MON TRANSACTIONS",UVM_NONE);
      @(posedge inf.clk);
      item_collected_port.write(pkt);
      custom_ap.write (pkt);
    end
  endtask
endclass

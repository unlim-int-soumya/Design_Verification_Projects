class dff_cov #(type T=dff_seq_item) extends uvm_subscriber #(T);
  
  
  `uvm_component_utils(dff_cov)

  //dram_seq_item pkt;
  
  T pkt;

  covergroup CovPort;	//@(posedge intf.clk);
    address : coverpoint pkt.addr {
      bins low    = {[0:100]};
      bins med    = {[100:200]};
      bins high   = {[200:255]};
    }
    
    data : coverpoint  pkt.data {
      bins low    = {[0:50]};
      bins med    = {[51:150]};
      bins high   = {[151:255]};
    }
  endgroup

  function new (string name = "dff_cov", uvm_component parent);
    super.new (name, parent);
    CovPort = new;
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
	  
  virtual function void write (T t);
    `uvm_info("SEQ","SEQUENCE TRANSACTIONS",UVM_NONE);
    pkt = t;
    CovPort.sample();
  endfunction

endclass
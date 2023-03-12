class dff_agent1 extends uvm_agent;

  `uvm_component_utils(dff_agent1)


  dff_seqr seqr;
  dff_drv drv;
  dff_mon1 mon1;

  
  function new(string name="dff_agent1",uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    seqr=dff_seqr::type_id::create("seqr1",this);
    drv=dff_drv::type_id::create("drv",this);
    mon1=dff_mon1::type_id::create("mon1",this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction

endclass


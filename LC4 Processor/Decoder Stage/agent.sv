class agent extends uvm_agent;
  `uvm_component_utils(agent)

  function new(input string inst = "agent", uvm_component parent = null);
    super.new(inst,parent);
  endfunction

  drv d;
  uvm_sequencer#(transaction) seqr;
  mon m;
  ref_model mref;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    d = drv::type_id::create("d",this);
    m = mon::type_id::create("m",this);
    mref = ref_model::type_id::create("mref",this);
    seqr = uvm_sequencer#(transaction)::type_id::create("seqr", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    d.seq_item_port.connect(seqr.seq_item_export);
  endfunction

endclass
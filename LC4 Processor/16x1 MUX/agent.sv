`include "item.sv"
//`include "sequencer.sv"
`include "sequence.sv"
`include "driver.sv"
`include "monitor.sv"

class agent extends uvm_agent;

  `uvm_component_utils(agent)

  function new(string name = "agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  driver d0;
  monitor m0;
  uvm_sequencer #(Item) s0;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    d0 = driver::type_id::create("d0", this);
    m0 = monitor::type_id::create("m0", this);
    s0 = uvm_sequencer #(Item)::type_id::create("s0", this);


  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //s0.seq_item_export.connect(d0.seq_item_port);
    d0.seq_item_port.connect(s0.seq_item_export);
  endfunction

endclass

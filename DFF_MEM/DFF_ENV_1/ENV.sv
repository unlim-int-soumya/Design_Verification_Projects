class  dff_env extends uvm_env;

  `uvm_component_utils(dff_env)

  dff_agent1 agent1;
  dff_agent2 agent2;
  dff_sb sb;
  dff_cov cov;

  function new(string name="dff_env",uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agent1=dff_agent1::type_id::create("agent1",this);
    agent2=dff_agent2::type_id::create("agent2",this);
    sb=dff_sb::type_id::create("sb",this);
    cov = dff_cov#(dff_seq_item)::type_id::create("cov",this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agent1.mon1.item_collected_port.connect(sb.ip_fifo.analysis_export);
    agent1.mon1.custom_ap.connect(cov.analysis_export);
    agent2.mon2.item_collected_port1.connect(sb.op_fifo.analysis_export);
  endfunction

endclass

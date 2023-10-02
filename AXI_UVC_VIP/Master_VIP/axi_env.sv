//++++++++++++++++++++++++//
//		 	AXI_ENV	  //
//++++++++++++++++++++++++//
class axi_env extends uvm_env;

  `uvm_component_utils(axi_env)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  axi_agent agent;
  axi_cov cov;
  axi_scoreboard sbd;

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    agent = axi_agent::type_id::create("agent", this);
    sbd = axi_scoreboard::type_id::create("sbd", this);

    cov = axi_cov::type_id::create("cov",this);

  endfunction


  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    agent.mon.custom_ap.connect(cov.analysis_export);
    agent.mon.custom_ap.connect(sbd.analysis_export);
  endfunction

endclass

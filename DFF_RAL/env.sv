//`include "coverage.sv"

//`include "scoreboard.sv"

class env extends uvm_env;
  `uvm_component_utils(env)
  
  agent agt;
  reg_axi_adapter adapter;
  RegModel_SFR reg_model;  
  my_coverage cov0;
  uvm_reg_predictor #(seq_item) m_apb2reg_predictor;
  
  traffic_scoreboard             m_scoreboard;        // Scoreboard
  
  function new(string name = "env", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    agt = agent::type_id::create("agt", this);
    adapter = reg_axi_adapter::type_id::create("adapter");
    reg_model = RegModel_SFR::type_id::create("reg_model");
    
    m_scoreboard = traffic_scoreboard::type_id::create("jb_fc_sub", this );
    cov0 = my_coverage::type_id::create("cov0",this);
    
    m_apb2reg_predictor = uvm_reg_predictor #(seq_item)::type_id::create("m_apb2reg_predictor", this);
    
    reg_model.build();
    reg_model.reset();
    reg_model.lock_model();
    reg_model.print();
    
    uvm_config_db#(RegModel_SFR)::set(uvm_root::get(), "*", "reg_model", reg_model);
  endfunction
  
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    //agt.mon.item_collect_port.connect(cov0.analysis_export);
    
    
    //agt.drv.drv2sb.connect(sb0.m_analysis_imp);
    
    agt.ag_ap.connect(m_scoreboard.apb_export);
    
    
    
    //agt.mon.ap_mon.connect(m_scoreboard.m_analysis_imp2);
    
    agt.mon.ap_mon.connect(cov0.analysis_export);

    
    m_apb2reg_predictor.map = reg_model.default_map;
    m_apb2reg_predictor.adapter = adapter;
    
    //agt.mon.item_collect_port.connect(m_apb2reg_predictor.bus_in);
    
    
    reg_model.default_map.set_sequencer( .sequencer(agt.seqr), .adapter(adapter) );
    reg_model.default_map.set_base_addr('h0);        
    //regmodel.add_hdl_path("tb_top.DUT");
  endfunction
endclass
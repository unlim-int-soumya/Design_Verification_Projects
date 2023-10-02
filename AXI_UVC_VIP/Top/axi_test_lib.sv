//++++++++++++++++++++++++//
//		 AXI_TEST_LIB	  //
//++++++++++++++++++++++++//

class base_test extends uvm_test;

  `uvm_component_utils(base_test)

  axi_env axi;

  function new(string name, uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    axi = axi_env::type_id::create("axi", this);

    `uvm_info(get_type_name(), "Build Phase Executed", UVM_HIGH)


    // Setting up the sequencer
    //uvm_config_wrapper::set(this, "axi.agent.sqr.run_phase", "default_sequence", axi_5_seq::get_type());

    // Enable transaction recording
    uvm_config_int::set(this, "*", "recording_details", 1);

  endfunction

  function void start_of_simulation_phase(uvm_phase phase);
    `uvm_info(get_type_name(), {"start of simulation for", get_full_name()}, UVM_NONE)
  endfunction

  task run_phase(uvm_phase phase);
    uvm_objection obj = phase.get_objection();
    obj.set_drain_time(this, 200ns);
  endtask: run_phase

  function void end_of_elaboration_phase(uvm_phase phase);
    uvm_top.print_topology();
  endfunction

  function void check_phase(uvm_phase phase);
    check_config_usage();
    $display("TEST: Check phase Executed");
  endfunction

endclass


class axi_5_test extends base_test;

  `uvm_component_utils(axi_5_test)

  function new(string name="axi_5_test", uvm_component parent);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    uvm_config_wrapper::set(this, "axi.agent.sqr.run_phase", "default_sequence", axi_5_seq::get_type());
    
    //yapp_packet::type_id::set_type_override(short_yapp_packet::get_type());

  endfunction
  


endclass

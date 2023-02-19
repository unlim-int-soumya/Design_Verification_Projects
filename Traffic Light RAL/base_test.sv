//`include "bus_pkt.sv"
`include "my_env.sv"
`include "reset_seq.sv"

class base_test extends uvm_test;

	`uvm_component_utils(base_test)

	my_env	m_env;
	reset_seq	m_reset_seq;
	uvm_status_e	status;
  
  virtual bus_if vif;
	
	function new(string name="base_test", uvm_component parent);
		super.new(name, parent);
	endfunction	

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		m_env = my_env::type_id::create("m_env", this);
		m_reset_seq = reset_seq::type_id::create("m_reset_seq", this);
      
        
      if(!uvm_config_db #(virtual bus_if)::get(this, "", "bus_if", vif))
        `uvm_fatal("TEST", $sformatf("Couldn't get vif"))

        uvm_config_db #(virtual bus_if)::set(this, "m_env.m_agent.*", "bus_if", vif);   
      
      
      
      //Past//uvm_config_db #(virtual bus_if)::get(this, "", "bus_if", vif);
      //uvm_config_db #(virtual bus_if)::set(this, "m_env.m_agent.*", "bus_if", vif); 
      
	endfunction

	virtual task reset_phase(uvm_phase phase);
		super.reset_phase(phase);
		phase.raise_objection(this);
		m_reset_seq.start(m_env.m_agent.m_seqr);
		phase.drop_objection(this);
	endtask

endclass


class reg_rw_test extends base_test;

	`uvm_component_utils(reg_rw_test)

	function new(string name="reg_rw_test", uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual task main_phase(uvm_phase phase);
		ral_sys_traffic	m_ral_model;
		uvm_status_e	status;
		int			rdata;
		
		phase.raise_objection(this);

		m_env.m_reg_env.set_report_verbosity_level(UVM_HIGH);

		uvm_config_db #(ral_sys_traffic)::get(null, "uvm_test_top", "m_ral_model", m_ral_model);

		m_ral_model.cfg.timer[1].write(status, 32'hcafe_feed);
		m_ral_model.cfg.timer[1].read(status,rdata);

		m_ral_model.cfg.timer[1].set(32'hface);
		`uvm_info(get_type_name(), $sformatf("desired=0x%0h mirrored=0x%0h", m_ral_model.cfg.timer[1].get(), m_ral_model.cfg.timer[1].get_mirrored_value()), UVM_MEDIUM)

		m_ral_model.cfg.timer[1].predict(32'hcafe_feed);
		m_ral_model.cfg.timer[1].mirror(status, UVM_CHECK);

		m_ral_model.cfg.ctrl.bl_yellow.set(1);
		m_ral_model.cfg.update(status);

		m_ral_model.cfg.stat.write(status, 32'h12345678);
		phase.drop_objection(this);

	endtask

	virtual task shutdown_phase(uvm_phase phase);
		super.shutdown_phase(phase);
		phase.raise_objection(this);
		#100ns;
		phase.drop_objection(this);
	endtask

endclass
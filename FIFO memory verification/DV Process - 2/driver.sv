
class driver extends uvm_driver #(Item);

	`uvm_component_utils(driver)

	function new(string name ="driver", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	virtual des_if vif;		//Virtual Interface for sending data

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if(!uvm_config_db #(virtual des_if)::get(this, "", "des_if", vif))	//Store in Internal DB and retrive by other components later
          `uvm_fatal("DRV", "Could not get vif")
	endfunction

	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
	
		forever begin
			Item m_item;	//Created m_item in sequence, now declaring it
          `uvm_info("DRV", $sformatf("Waiting for sequencer"), UVM_LOW)
          seq_item_port.get_next_item(m_item);
			drive_item(m_item);		//Drive m_item to interface
			seq_item_port.item_done();	//Once driving done, Let sequencer know process is finished
		end

	endtask

	virtual task drive_item(Item m_item);
      @(posedge vif.clk);
			vif.rstn <= m_item.rstn;
      		vif.enq <= m_item.enq;
      		vif.deq <= m_item.deq;
      		vif.din <= m_item.din;
      
	endtask

endclass
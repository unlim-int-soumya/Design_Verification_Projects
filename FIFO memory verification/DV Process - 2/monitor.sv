
class monitor extends uvm_monitor;

	`uvm_component_utils(monitor)

	function new(string name = "monitor", uvm_component parent = null);
      super.new(name, parent);
	endfunction

	uvm_analysis_port #(Item) mon_analysis_port;	//monioor builds a uvm_analysis_port for sending data to scoreboard
	virtual des_if vif;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		
		if(!uvm_config_db #(virtual des_if)::get(this, "","des_if", vif))
		`uvm_info("MON", $sformatf("Could not get the item"), UVM_HIGH)

		mon_analysis_port = new("mon_analysis_port", this);
	endfunction


	virtual task run_phase(uvm_phase phase);
		super.run_phase(phase);
		forever begin
          @(posedge vif.clk);
          if(vif.rstn) begin
				Item item = Item::type_id::create("item");
				item.rstn = vif.rstn;
				item.enq = vif.enq;
            	item.deq = vif.deq;
            	item.din = vif.din;
            	item.dout = vif.dout;
            	item.full = vif.full;
            	item.empty = vif.empty;
				mon_analysis_port.write(item);
            `uvm_info("MON",$sformatf("Saw item %s", item.convert2str()), UVM_LOW)
            end
		end
	endtask


endclass
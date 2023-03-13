

class gen_item_seq extends uvm_sequence;
  `uvm_object_utils(gen_item_seq)

	rand int num;

	function new(string name = "gen_sequence_item");
		super.new(name);
	endfunction

	constraint c1 {soft num inside {[10:50]}; }

	virtual task body();
		for(int i=0; i< num; i++) begin
			Item m_item = Item::type_id::create("m_item");
			start_item(m_item);	// start_item/finish_item is used to send transactions to a driver
			m_item.randomize();	//Randomizing the data
			`uvm_info("SEQ", $sformatf("generate new item: %s", m_item.convert2str()), UVM_HIGH)
			finish_item(m_item);
		end
		`uvm_info("SEQ", $sformatf("Done Generation of %0d item", num), UVM_LOW)
	endtask

endclass
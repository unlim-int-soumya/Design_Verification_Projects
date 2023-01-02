class gen_item_seq extends uvm_sequence #(Item);	

  `uvm_object_utils(gen_item_seq)

  function new(string name = "gen_item_seq");
    super.new(name);
  endfunction

	rand int num;

	constraint c1 {soft num inside {[20:50]};}

	virtual task body();	//We have to write here virtual as well
		for(int i=0; i< num ;i++) begin
			Item item = Item::type_id::create("item");
			start_item(item);
			item.randomize();
          `uvm_info("SEQ", $sformatf("Generating seq: %s", item.convert2str()), UVM_LOW)
			finish_item(item);
		end
      `uvm_info("SEQ", $sformatf("Generating done of %0d", num), UVM_LOW)
	endtask

endclass
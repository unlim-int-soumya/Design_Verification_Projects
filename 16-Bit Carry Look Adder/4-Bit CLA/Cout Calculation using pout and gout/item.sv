
class Item extends uvm_sequence_item;

  `uvm_object_utils(Item)
	
	function new(string name = "Item");
		super.new(name);
	endfunction

  rand bit [3:0] gin, pin;
  rand bit cin;
  bit [3:0] cout;
  bit gout, pout;

	function string convert2str();
      return $sformatf("gin=%0b pin=%0b cin = %0b", gin, pin, cin);
	endfunction

  /*
  constraint c1 { 0 <= sel < 16; soft in inside {[32768:65535]}; rstn dist {0:/10, 1:/90};} */

endclass
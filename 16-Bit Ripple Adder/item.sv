
class Item extends uvm_sequence_item;

  `uvm_object_utils(Item)
	
	function new(string name = "Item");
		super.new(name);
	endfunction

  rand bit [15:0] a, b;
  rand bit cin;
  bit [15:0] sum;
  bit cout;

	function string convert2str();
      return $sformatf("a=%0b b=%0b cin =%0b sum=%0b cout=%0b", a, b, cin, sum, cout);
	endfunction

  /*
  constraint c1 { 0 <= sel < 16; soft in inside {[32768:65535]}; rstn dist {0:/10, 1:/90};} */

endclass
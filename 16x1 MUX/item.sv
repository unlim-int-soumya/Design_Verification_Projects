`ifndef IN_LENGTH
`define IN_LENGTH 16
`endif

`ifndef SEL_LENGTH
`define SEL_LENGTH 4
`endif

class Item extends uvm_sequence_item;

  `uvm_object_utils(Item)
	
	function new(string name = "Item");
		super.new(name);
	endfunction

  rand bit [`SEL_LENGTH-1:0] sel;
  rand bit [`IN_LENGTH-1:0]in;	
  rand bit rstn;
  bit out;		

	function string convert2str();
      return $sformatf("sel=%0b in=%0b rstn =%0b out=%0b", sel, in, rstn, out);
	endfunction

  constraint c1 { 0 <= sel < 16; soft in inside {[32768:65535]}; rstn dist {0:/10, 1:/90};}
  //constraint c1 {a dist {0:/50, 1:/50}; b dist {0:/50, 1:/50}; cin dist {0:/50, 1:/50}; rstn dist {0:/10,1:/90};}

endclass
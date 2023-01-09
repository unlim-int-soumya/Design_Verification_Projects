// Work is to create data packets based on constraint given here. 20% of times 0 and 80% 1.



class Item extends uvm_sequence_item;

	`uvm_object_utils(Item)
  
  /*`uvm_object_utils_begin(Item)
  `uvm_field_int(in,UVM_ALL_ON)
  `uvm_field_int(out,UVM_ALL_ON)
  `uvm_object_utils_end */

  rand bit rstn;
  rand bit enq;
  rand bit deq;
  rand bit [7:0] din;
  bit [7:0] dout;
  bit full;
  bit empty;
	
	function new(string name = "Item");
		super.new(name);
	endfunction

	virtual function string convert2str();
      return $sformatf("rstn = %0b, enq =%0b deq =%0b din =%0b dout =%0b full =%0b empty =%0b", rstn, enq, deq, din, dout, full, empty);
	endfunction

  constraint c1 {rstn dist {0:/10, 1:/90}; enq dist {0:/50, 1:/50}; deq dist {0:/50, 1:/50}; 0 < din < 255; enq != deq; }

endclass
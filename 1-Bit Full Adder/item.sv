class Item extends uvm_sequence_item;

  `uvm_object_utils(Item)
	
	function new(string name = "Item");
		super.new(name);
	endfunction

	rand bit a;
	rand bit b;
	rand bit cin;	
  	rand bit rstn;
	bit sum;	
	bit cout;		

	function string convert2str();
      return $sformatf("a=%0b b=%0b cin=%0b rstn =%0b", a, b, cin, rstn);
      //return $sformatf("a=%0b b=%0b cin=%0b rstn =%0b sum=%0b cout=%0b", a, b, cin, rstn, sum, cout);
	endfunction

  constraint c1 {a dist {0:/50, 1:/50}; b dist {0:/50, 1:/50}; cin dist {0:/50, 1:/50}; rstn dist {0:/10,1:/90};}

endclass
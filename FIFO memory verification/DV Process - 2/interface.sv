interface des_if (input bit clk);
  	
  	//logic clk;
	logic rstn;
	logic enq;
  	logic deq;
  	logic [7:0]din;
  
  	logic [7:0]dout;
	logic full;
  	logic empty;

 
	clocking cb @(posedge clk);
		default input #1step output #3ns;
		output rstn, enq, deq, din;
		input dout, full, empty;
	endclocking

endinterface
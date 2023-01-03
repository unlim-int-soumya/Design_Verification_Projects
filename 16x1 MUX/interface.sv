`ifndef IN_LENGTH
`define IN_LENGTH 16
`endif

`ifndef SEL_LENGTH
`define SEL_LENGTH 4
`endif

//interface des_if();
interface des_if(input bit clk);
  logic [`SEL_LENGTH-1:0] sel; 
  logic [`IN_LENGTH-1:0] in;
  logic rstn;
  logic out;

  
  	clocking cb @(posedge clk);
		default input #1step output #3ns;
		input sel, in, rstn;
		output out;
	endclocking 
  
endinterface

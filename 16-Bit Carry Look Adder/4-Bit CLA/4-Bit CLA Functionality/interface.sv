`ifndef IN_LENGTH
`define IN_LENGTH 16
`endif

`ifndef SEL_LENGTH
`define SEL_LENGTH 4
`endif

//interface des_if();
interface des_if(input bit clk);
  
  logic [3:0] gin, pin;
  logic cin;
  logic [2:0] cout;
  logic gout, pout;

  
  	clocking cb @(posedge clk);
		default input #1step output #3ns;
		input cout, gout, pout;
		output gin, pin, cin;
	endclocking 
  
endinterface

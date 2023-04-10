`ifndef IN_LENGTH
`define IN_LENGTH 16
`endif

`ifndef SEL_LENGTH
`define SEL_LENGTH 4
`endif

//interface des_if();
interface des_if(input bit clk);
  
  logic [15:0] a,b;
  logic cin;
  logic [15:0] sum;
  logic cout;

  
  	clocking cb @(posedge clk);
		default input #1step output #3ns;
		input sum, cout;
		output a, b, cin;
	endclocking 
  
endinterface

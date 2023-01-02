//interface des_if();
interface des_if(input bit clk);
    logic a;
    logic b;
    logic cin;
  	logic rstn;
    logic sum;
    logic cout;

  
  	clocking cb @(posedge clk);
		default input #1step output #3ns;
		input a, b, cin, rstn;
		output sum,cout;
	endclocking 
  
endinterface

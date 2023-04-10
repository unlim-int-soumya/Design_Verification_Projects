import uvm_pkg::*;

`include "uvm_macros.svh"
`include "interface.sv"
`include "base_test.sv"

module testbench;
  
  	reg clk;
	
	always #10 clk = ~clk;
	des_if _if (clk);
  //des_if _if ();

  initial begin
    clk <= 0;
    uvm_config_db #(virtual des_if)::set(null, "uvm_test_top", "des_if", _if);
    run_test("test_2");
  end

  
  gp4 u0 (
    .gin(_if.gin),
    .pin(_if.pin),
    .cin(_if.cin),
    .cout(_if.cout),
    .gout(_if.gout),
    .pout(_if.pout)
  ); 

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end

endmodule

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
    run_test("test_1011");
  end

  
  ripple_carry_16_bit u0 (
    .a(_if.a),
    .b(_if.b),
    .cin(_if.cin),
    .sum(_if.sum),
    .cout(_if.cout)
  ); 

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end

endmodule

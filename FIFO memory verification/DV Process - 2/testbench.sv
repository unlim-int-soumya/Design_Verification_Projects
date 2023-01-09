import uvm_pkg::*;

`include "uvm_macros.svh"
`include "interface.sv"
`include "base_test.sv"

module tb;
	reg clk;
	
	always #10 clk = ~clk;
	des_if _if (clk);

	fifo_memory u0 (
      .clk(clk),
      .rstn(_if.rstn),
      .enq(_if.enq),
      .deq(_if.deq),
      .din(_if.din),
      .dout(_if.dout),
      .full(_if.full),
      .empty(_if.empty)
    );

	initial begin
      clk <= 0;
      uvm_config_db #(virtual des_if)::set(null, "uvm_test_top", "des_if", _if);
      run_test("test_1011");
	end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end

endmodule
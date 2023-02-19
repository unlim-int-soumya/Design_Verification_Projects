`include "uvm_macros.svh"


`include "interface.sv"
//`include "my_pkg.sv"
`include "base_test.sv"


module tb_top;
  import uvm_pkg::*;
  //import tb_pkg::*;  
  
  	reg clk;
	
	always #10 clk = ~clk;
	bus_if _if (clk);
  //des_if _if ();

  initial begin
    clk <= 0;
    uvm_config_db #(virtual bus_if)::set(null, "uvm_test_top", "bus_if", _if);
    
    //Past//uvm_config_db#(virtual bus_if)::set(uvm_root::get(),"*","bus_if",_if);
    run_test("reg_rw_test");
  end

  
  traffic u0 (
    .pclk(_if.pclk),
    .presetn(_if.presetn),
    .paddr(_if.paddr),
    .psel(_if.psel),
    .pwrite(_if.pwrite),
    .pwdata(_if.pwdata),
    .penable(_if.penable),
    .prdata(_if.prdata)
  ); 

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end

endmodule

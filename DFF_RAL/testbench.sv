`include "uvm_macros.svh"
import uvm_pkg::*;

`include "interface.sv"
`include "base_test.sv"

module tb_top;
  bit clk;
  bit reset_n;
  always #2 clk = ~clk;
  
  initial begin
    //clk = 0;
    reset_n = 0;
    #5; 
    reset_n = 1;
  end
  sfr_if vif(clk, reset_n);
  
  dff_with_memory dut (
    .clk(vif.clk),
    .reset(vif.reset_n),
    .rw(vif.rw),
    .address_in(vif.address_in),
    .data_in(vif.data_in),
    .data_out(vif.data_out)
  );
  
  initial begin
    // set interface in config_db
    uvm_config_db#(virtual sfr_if)::set(uvm_root::get(), "*", "vif", vif);
    // Dump waves
    $dumpfile("dump.vcd");
    $dumpvars(); //(0, tb_top);
  end
  initial begin
    run_test("reg_test");
    //#100;
    //$finish;
  end
endmodule
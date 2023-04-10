 import uvm_pkg::*;
`include "uvm_macros.svh"
`include "INTERFACE.sv"
//`include "DESIGN.sv"
//`include "DUT.sv"
`include "SEQ_ITEM.sv"
`include "SEQ.sv"
`include  "SEQR.sv"
`include "DRV.sv"
`include "COV.sv"
`include "MON1.sv"
//s`include "MON2.sv"
`include "AGENT1.sv"
`include "AGENT2.sv"
`include "SB.sv"
`include "ENV.sv"
`include "TEST.sv"

module dram_top();
  
bit clk;

initial begin

    clk=1'b0;
    forever #5 clk=~clk;
  
end


intif inf(clk);
  
 initial begin
   inf.rst = 1'b0;
 end
  
//dff_with_memory dut(inf);
  

  IF dut(
    .clk(inf.clk), //1
    .rst(inf.rst),	//2
    .gwe(inf.gwe), //3
    .reg_we(inf.reg_we),
    .next_pc(inf.next_pc),
    .pc(inf.pc),
    .test_stall_f(inf.test_stall_f)
  );


initial begin
  
  //The man who stand the business enjoyed with his generations
  //uvm_config_db#(virtual intif)::set(this,"*","inf",inf);
  //uvm_config_db#(virtual intif)::set(null,"*","inf",inf);
  uvm_config_db#(virtual intif)::set(uvm_root::get(),"*","inf",inf);
  run_test("dram_test");
end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end
  
endmodule


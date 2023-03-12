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
`include "MON2.sv"
`include "AGENT1.sv"
`include "AGENT2.sv"
`include "SB.sv"
`include "ENV.sv"
`include "TEST.sv"

module dff_top();
  
bit clk;

initial begin

    clk=1'b0;
    forever #5 clk=~clk;
  
end


intif inf(clk);
  
 initial begin
   inf.reset = 1'b1;
 end
  
//dff_with_memory dut(inf);

  dff_with_memory dut(.clk(inf.clk),
                      .reset(inf.reset),
                      .rw(inf.rw),
                      .address_in(inf.address_in),
                      .data_in(inf.data_in),
                      .data_out(inf.data_out)
                     );


initial begin
  
  //The man who stand the business enjoyed with his generations
  //uvm_config_db#(virtual intif)::set(this,"*","inf",inf);
  //uvm_config_db#(virtual intif)::set(null,"*","inf",inf);
  uvm_config_db#(virtual intif)::set(uvm_root::get(),"*","inf",inf);
  run_test("dff_test");
end
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end
  
endmodule


`include "uvm_macros.svh"
`include "package.sv"

import uvm_pkg::*;


module tb;

  mux_if mif();

  //mux dut (.a(mif.a), .b(mif.b), .c(mif.c), .d(mif.d), .sel(mif.sel),
           //.y(mif.y));

  lc4_decoder dut(
    .insn(mif.insn),               // instruction
    .r1sel(mif.r1sel),              // rs
    .r1re(mif.r1re),               // does this instruction read from rs?
    .r2sel(mif.r2sel),              // rt
    .r2re(mif.r2re),               // does this instruction read from rt?
    .wsel(mif.wsel),               // rd
    .regfile_we(mif.regfile_we),         // does this instruction write to rd?
    .nzp_we(mif.nzp_we),             // does this instruction write the NZP bits?
    .select_pc_plus_one(mif.select_pc_plus_one), // route PC+1 to the ALU instead of rs?
    .is_load(mif.is_load),            // is this a load instruction?
    .is_store(mif.is_store),           // is this a store instruction?
    .is_branch(mif.is_branch),          // is this a branch instruction?
    .is_control_insn(mif.is_control_insn)  
  );


  initial
    begin
      uvm_config_db #(virtual mux_if)::set(null, "*", "mif", mif);
      run_test("test");
    end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars;
  end
endmodule
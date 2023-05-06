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


  p_reg dut(
    .clk(clk),
    .gwe(inf.gwe),
    .rst(inf.rst),

    //from fetch stage
    .o_cur_pc_plus_one_i(inf.o_cur_pc_plus_one_i),
    .i_cur_insn_i(inf.i_cur_insn_i),

    //decode stage
    .r1sel_i(inf.r1sel_i),
    .r1re_i(inf.r1re_i),
    .r2sel_i(inf.r2sel_i),
    .r2re_i(inf.r2re_i),
    .wsel_i(inf.wsel_i),
    .regfile_we_i(inf.regfile_we_i),
    .nzp_we_i(inf.nzp_we_i),
    .select_pc_plus_one_i(inf.select_pc_plus_one_i),
    .is_load_i(inf.is_load_i),
    .is_store_i(inf.is_store_i),
    .is_branch_i(inf.is_branch_i),
    .is_control_insn_i(inf.is_control_insn_i),

    .o_rs_data_i(inf.o_rs_data_i),
    .o_rt_data_i(inf.o_rt_data_i),
    .i_wdata_i(inf.i_wdata_i),

    //execute stage
    .alu_result_i(inf.alu_result_i),

    //memory stage
    .lmd_i(inf.lmd_i),


    //from fetch stage
    .o_cur_pc_plus_one_o(inf.o_cur_pc_plus_one_o),
    .i_cur_insn_o(inf.i_cur_insn_o),

    //decode stage
    .r1sel_o(inf.r1sel_o),
    .r1re_o(inf.r1re_o),
    .r2sel_o(inf.r2sel_o),
    .r2re_o(inf.r2re_o),
    .wsel_o(inf.wsel_o),
    .regfile_we_o(inf.regfile_we_o),
    .nzp_we_o(inf.nzp_we_o),
    .select_pc_plus_one_o(inf.select_pc_plus_one_o),
    .is_load_o(inf.is_load_o),
    .is_store_o(inf.is_store_o),
    .is_branch_o(inf.is_branch_o),
    .is_control_insn_o(inf.is_control_insn_o),

    .o_rs_data_o(inf.o_rs_data_o),
    .o_rt_data_o(inf.o_rt_data_o),
    .i_wdata_o(inf.i_wdata_o),

    //execute stage
    .alu_result_o(inf.alu_result_o),

    //memory stage
    .lmd_o(inf.lmd_o)
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


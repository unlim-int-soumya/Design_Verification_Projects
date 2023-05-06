`include "pipeline_reg.v"


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2023 12:56:06 AM
// Design Name: 
// Module Name: IF
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`default_nettype none
module p_reg(
  input  wire         clk,
  input  wire         gwe,
  input  wire         rst,

  //from fetch stage
  input wire [15:0] o_cur_pc_plus_one_i,
  input wire [15:0] i_cur_insn_i,

  //decode stage
  input wire [2:0] r1sel_i,
  input wire r1re_i,
  input wire [2:0] r2sel_i,
  input wire r2re_i,
  input wire [2:0]  wsel_i,
  input wire regfile_we_i,
  input wire nzp_we_i,
  input wire select_pc_plus_one_i,
  input wire is_load_i,
  input wire is_store_i,
  input wire is_branch_i,
  input wire is_control_insn_i,

  input wire [15:0] o_rs_data_i,
  input wire [15:0] o_rt_data_i,
  input wire [15:0] i_wdata_i,

  //execute stage
  input wire [15:0] alu_result_i,

  //memory stage
  input wire [15:0]  lmd_i,

  //OUTPUT

  //from fetch stage
  output wire [15:0] o_cur_pc_plus_one_o,
  output wire [15:0] i_cur_insn_o,

  //decode stage
  output wire [2:0] r1sel_o,
  output wire r1re_o,
  output wire [2:0] r2sel_o,
  output wire r2re_o,
  output wire [2:0]  wsel_o,
  output wire regfile_we_o,
  output wire nzp_we_o,
  output wire select_pc_plus_one_o,
  output wire is_load_o,
  output wire is_store_o,
  output wire is_branch_o,
  output wire is_control_insn_o,

  output wire [15:0] o_rs_data_o,
  output wire [15:0] o_rt_data_o,
  output wire [15:0] i_wdata_o,

  //execute stage
  output wire [15:0] alu_result_o,

  //memory stage
  output wire [15:0] lmd_o
);

  pipeline_reg #(.n(16)) pipe_reg
  (.clk(clk),
   .gwe(gwe),
   .rst(rst),

   //from fetch stage
   .o_cur_pc_plus_one_i(o_cur_pc_plus_one_i),
   .i_cur_insn_i(i_cur_insn_i),

   //decode stage
   .r1sel_i(r1sel_i),
   .r1re_i(r1re_i),
   .r2sel_i(r2sel_i),
   .r2re_i(r2re_i),
   .wsel_i(wsel_i),
   .regfile_we_i(regfile_we_i),
   .nzp_we_i(nzp_we_i),
   .select_pc_plus_one_i(select_pc_plus_one_i),
   .is_load_i(is_load_i),
   .is_store_i(is_store_i),
   .is_branch_i(is_branch_i),
   .is_control_insn_i(is_control_insn_i),

   .o_rs_data_i(o_rs_data_i),
   .o_rt_data_i(o_rt_data_i),
   .i_wdata_i(i_wdata_i),

   //execute stage
   .alu_result_i(alu_result_i),

   //memory stage
   .lmd_i(lmd_i),

   //OUTPUT

   //from fetch stage
   .o_cur_pc_plus_one_o(o_cur_pc_plus_one_o),
   .i_cur_insn_o(i_cur_insn_o),

   //decode stage
   .r1sel_o(r1sel_o),
   .r1re_o(r1re_o),
   .r2sel_o(r2sel_o),
   .r2re_o(r2re_o),
   .wsel_o(wsel_o),
   .regfile_we_o(regfile_we_o),
   .nzp_we_o(nzp_we_o),
   .select_pc_plus_one_o(select_pc_plus_one_o),
   .is_load_o(is_load_o),
   .is_store_o(is_store_o),
   .is_branch_o(is_branch_o),
   .is_control_insn_o(is_control_insn_o),

   .o_rs_data_o(o_rs_data_o),
   .o_rt_data_o(o_rt_data_o),
   .i_wdata_o(i_wdata_o),

   //execute stage
   .alu_result_o(alu_result_o),

   //memory stage
   .lmd_o(lmd_o)

  );


endmodule

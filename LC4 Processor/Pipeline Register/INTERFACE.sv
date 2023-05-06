
interface intif(input bit clk);


  logic gwe, rst;

  //from fetch stage
  logic [15:0] o_cur_pc_plus_one_i;
  logic [15:0] i_cur_insn_i;

  //decode stage
  logic [2:0] r1sel_i;
  logic r1re_i;
  logic [2:0] r2sel_i;
  logic r2re_i;
  logic [2:0]  wsel_i;
  logic regfile_we_i;
  logic nzp_we_i;
  logic select_pc_plus_one_i;
  logic is_load_i;
  logic is_store_i;
  logic is_branch_i;
  logic is_control_insn_i;

  logic [15:0] o_rs_data_i;
  logic [15:0] o_rt_data_i;
  logic [15:0] i_wdata_i;

  //execute stage
  logic [15:0] alu_result_i;

  //memory stage
  logic [15:0]  lmd_i;

  //OUTPUT

  //from fetch stage
  logic [15:0] o_cur_pc_plus_one_o;
  logic [15:0] i_cur_insn_o;

  //decode stage
  logic [2:0] r1sel_o;
  logic r1re_o;
  logic [2:0] r2sel_o;
  logic r2re_o;
  logic [2:0]  wsel_o;
  logic regfile_we_o;
  logic nzp_we_o;
  logic select_pc_plus_one_o;
  logic is_load_o;
  logic is_store_o;
  logic is_branch_o;
  logic is_control_insn_o;

  logic [15:0] o_rs_data_o;
  logic [15:0] o_rt_data_o;
  logic [15:0] i_wdata_o;

  //execute stage
  logic [15:0] alu_result_o;

  //memory stage
  logic [15:0] lmd_o;


  //Lighthouse

  modport dut(input clk,
              gwe,
              rst,

              //from fetch stage
              o_cur_pc_plus_one_i,
              i_cur_insn_i,

              //decode stage
              r1sel_i,
              r1re_i,
              r2sel_i,
              r2re_i,
              wsel_i,
              regfile_we_i,
              nzp_we_i,
              select_pc_plus_one_i,
              is_load_i,
              is_store_i,
              is_branch_i,
              is_control_insn_i,

              o_rs_data_i,
              o_rt_data_i,
              i_wdata_i,

              //execute stage
              alu_result_i,

              //memory stage
              lmd_i,

              output 

              //from fetch stage
              o_cur_pc_plus_one_o,
              i_cur_insn_o,

              //decode stage
              r1sel_o,
              r1re_o,
              r2sel_o,
              r2re_o,
              wsel_o,
              regfile_we_o,
              nzp_we_o,
              select_pc_plus_one_o,
              is_load_o,
              is_store_o,
              is_branch_o,
              is_control_insn_o,

              o_rs_data_o,
              o_rt_data_o,
              i_wdata_o,

              //execute stage
              alu_result_o,

              //memory stage
              lmd_o
             );

endinterface



class dram_seq_item extends uvm_sequence_item;

  `uvm_object_utils(dram_seq_item)

  function new(string name="dram_seq_item");
    super.new(name);
  endfunction

  bit gwe;

  //from fetch stage
  rand bit [15:0] o_cur_pc_plus_one_i;
  rand bit [15:0] i_cur_insn_i;

  //decode stage
  rand bit [2:0] r1sel_i;
  rand bit r1re_i;
  rand bit [2:0] r2sel_i;
  rand bit r2re_i;
  rand bit [2:0]  wsel_i;
  rand bit regfile_we_i;
  rand bit nzp_we_i;
  rand bit select_pc_plus_one_i;
  rand bit is_load_i;
  rand bit is_store_i;
  rand bit is_branch_i;
  rand bit is_control_insn_i;

  rand bit [15:0] o_rs_data_i;
  rand bit [15:0] o_rt_data_i;
  rand bit [15:0] i_wdata_i;

  //execute stage
  rand bit [15:0] alu_result_i;

  //memory stage
  rand bit [15:0]  lmd_i;

  //OUTPUT

  //from fetch stage
  bit [15:0] o_cur_pc_plus_one_o;
  bit  [15:0] i_cur_insn_o;

  //decode stage
  bit  [2:0] r1sel_o;
  bit  r1re_o;
  bit  [2:0] r2sel_o;
  bit  r2re_o;
  bit  [2:0]  wsel_o;
  bit  regfile_we_o;
  bit  nzp_we_o;
  bit  select_pc_plus_one_o;
  bit  is_load_o;
  bit  is_store_o;
  bit  is_branch_o;
  bit  is_control_insn_o;

  bit  [15:0] o_rs_data_o;
  bit  [15:0] o_rt_data_o;
  bit  [15:0] i_wdata_o;

  //execute stage
  bit  [15:0] alu_result_o;

  //memory stage
  bit  [15:0] lmd_o;


  function string input2str();
    return $sformatf(" gwe=%0b, IF: o_cur_pc_plus_one_i=%0b,i_cur_insn_i=%0b, ID:r1sel_i=%0b,r1re_i=%0b,r2sel_i=%0b,r2re_i=%0b,wsel_i=%0b,regfile_we_i=%0b,nzp_we_i =%0b,select_pc_plus_one_i=%0b,is_load_i=%0b,is_store_i=%0b,is_branch_i=%0b,is_control_insn_i=%0b,o_rs_data_i=%0b,o_rt_data_i=%0b,i_wdata_i=%0b, EX: alu_result_i, MEM: lmd_i", gwe, o_cur_pc_plus_one_i,i_cur_insn_i, r1sel_i,r1re_i,r2sel_i,r2re_i,wsel_i,regfile_we_i,nzp_we_i ,select_pc_plus_one_i,is_load_i,is_store_i,is_branch_i,is_control_insn_i,o_rs_data_i,o_rt_data_i,i_wdata_i, alu_result_i,lmd_i);
  endfunction
  
  function string output2str();
    return $sformatf(" IF: o_cur_pc_plus_one_o=%0b,i_cur_insn_o=%0b, ID:r1sel_o=%0b,r1re_o=%0b,r2sel_o=%0b,r2re_o=%0b,wsel_o=%0b,regfile_we_o=%0b,nzp_we_o =%0b,select_pc_plus_one_o=%0b,is_load_o=%0b,is_store_o=%0b,is_branch_o=%0b,is_control_insn_o=%0b,o_rs_data_o=%0b,o_rt_data_o=%0b,i_wdata_o=%0b, EX: alu_result_o, MEM: lmd_o", o_cur_pc_plus_one_o,i_cur_insn_o, r1sel_o,r1re_o,r2sel_o,r2re_o,wsel_o,regfile_we_o,nzp_we_o ,select_pc_plus_one_o,is_load_o,is_store_o,is_branch_o,is_control_insn_o,o_rs_data_o,o_rt_data_o,i_wdata_o, alu_result_o,lmd_o);
  endfunction  


endclass

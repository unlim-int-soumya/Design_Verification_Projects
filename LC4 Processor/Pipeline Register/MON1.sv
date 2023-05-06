class dram_mon1 extends uvm_monitor;

  `uvm_component_utils(dram_mon1)

  dram_seq_item pkt;

  virtual intif inf;


  uvm_analysis_port #(dram_seq_item) item_collected_port;

  uvm_analysis_port #(dram_seq_item) custom_ap;


  function new(string name="dram_mon1",uvm_component parent);
    super.new(name,parent);
  endfunction


  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db #(virtual intif) ::get(this,"","inf",inf);
    item_collected_port=new("item_collected_port",this);
    custom_ap = new("analysis_port",this);
  endfunction

  task run_phase(uvm_phase phase);
    pkt=dram_seq_item::type_id::create("pkt");
    forever begin      

      //#54;

      #7;
      //#60;

      //INPUTS

      //By default signals
      pkt.gwe=inf.gwe;


      //Other Input Signals
      //from fetch stage
      pkt.o_cur_pc_plus_one_i = inf.o_cur_pc_plus_one_i;
      pkt.i_cur_insn_i= inf.i_cur_insn_i;

      //decode stage
      pkt.r1sel_i = inf.r1sel_i;
      pkt.r1re_i = inf.r1re_i;
      pkt.r2sel_i = inf.r2sel_i;
      pkt.r2re_i = inf.r2re_i;
      pkt.wsel_i = inf.wsel_i;
      pkt.regfile_we_i = inf.regfile_we_i;
      pkt.nzp_we_i = inf.nzp_we_i;
      pkt.select_pc_plus_one_i = inf.select_pc_plus_one_i;
      pkt.is_load_i = inf.is_load_i;
      pkt.is_store_i = inf.is_store_i;
      pkt.is_branch_i = inf.is_branch_i;
      pkt.is_control_insn_i = inf.is_control_insn_i;

      pkt.o_rs_data_i = inf.o_rs_data_i;
      pkt.o_rt_data_i = inf.o_rt_data_i;
      pkt.i_wdata_i = inf.i_wdata_i;

      //execute stage
      pkt.alu_result_i = inf.alu_result_i;

      //memory stage
      pkt.lmd_i = inf.lmd_i;





      //OUTPUTS

      //from fetch stage
      pkt.o_cur_pc_plus_one_o = inf.o_cur_pc_plus_one_o;
      pkt.i_cur_insn_o= inf.i_cur_insn_o;

      //decode stage
      pkt.r1sel_o = inf.r1sel_o;
      pkt.r1re_o = inf.r1re_o;
      pkt.r2sel_o = inf.r2sel_o;
      pkt.r2re_o = inf.r2re_o;
      pkt.wsel_o = inf.wsel_o;
      pkt.regfile_we_o = inf.regfile_we_o;
      pkt.nzp_we_o = inf.nzp_we_o;
      pkt.select_pc_plus_one_o = inf.select_pc_plus_one_o;
      pkt.is_load_o = inf.is_load_o;
      pkt.is_store_o = inf.is_store_o;
      pkt.is_branch_o = inf.is_branch_o;
      pkt.is_control_insn_o = inf.is_control_insn_o;

      pkt.o_rs_data_o = inf.o_rs_data_o;
      pkt.o_rt_data_o = inf.o_rt_data_o;
      pkt.i_wdata_o = inf.i_wdata_o;

      //execute stage
      pkt.alu_result_o = inf.alu_result_o;

      //memory stage
      pkt.lmd_o = inf.lmd_o;


      $display("MON: time=%0t", $time);

      `uvm_info("MON", $sformatf("Input item %s",pkt.input2str()), UVM_HIGH)
      `uvm_info("MON", $sformatf("Output item %s",pkt.output2str()), UVM_HIGH)


      `uvm_info("MON1","MON1 TRANSACTIONS" ,UVM_NONE);


      #3;

      item_collected_port.write(pkt);

      custom_ap.write (pkt);
    end
  endtask
endclass

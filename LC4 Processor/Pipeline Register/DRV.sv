class dram_drv extends uvm_driver #(dram_seq_item);

  `uvm_component_utils(dram_drv)

  virtual intif inf;

  dram_seq_item pkt;

  function new(string name="dram_drv",uvm_component parent);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    uvm_config_db #(virtual intif)::get(this,"","inf",inf);
  endfunction


  task run_phase(uvm_phase phase);

    forever begin

      seq_item_port.get_next_item(pkt);

      $display("DRV: time=%0t", $time);

      #5;

      //By default signals
      inf.gwe=pkt.gwe;


      //Other Input Signals
      //from fetch stage
      inf.o_cur_pc_plus_one_i = pkt.o_cur_pc_plus_one_i;
      inf.i_cur_insn_i= pkt.i_cur_insn_i;

      //decode stage
      inf.r1sel_i = pkt.r1sel_i;
      inf.r1re_i = pkt.r1re_i;
      inf.r2sel_i = pkt.r2sel_i;
      inf.r2re_i = pkt.r2re_i;
      inf.wsel_i = pkt.wsel_i;
      inf.regfile_we_i = pkt.regfile_we_i;
      inf.nzp_we_i = pkt.nzp_we_i;
      inf.select_pc_plus_one_i = pkt.select_pc_plus_one_i;
      inf.is_load_i = pkt.is_load_i;
      inf.is_store_i = pkt.is_store_i;
      inf.is_branch_i = pkt.is_branch_i;
      inf.is_control_insn_i = pkt.is_control_insn_i;

      inf.o_rs_data_i = pkt.o_rs_data_i;
      inf.o_rt_data_i = pkt.o_rt_data_i;
      inf.i_wdata_i = pkt.i_wdata_i;

      //execute stage
      inf.alu_result_i = pkt.alu_result_i;

      //memory stage
      inf.lmd_i = pkt.lmd_i;


      seq_item_port.item_done();

      `uvm_info("SEQ", $sformatf("Input item %s",pkt.input2str()), UVM_HIGH)

      `uvm_info("DRV","DRV TRANSACTION TO DUT",UVM_NONE);

    end
  endtask

endclass

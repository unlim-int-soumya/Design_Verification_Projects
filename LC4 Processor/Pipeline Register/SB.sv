class dram_sb extends uvm_scoreboard;

  `uvm_component_utils(dram_sb);

  dram_seq_item pkt,pkt1;


  //bit [7:0] mem[0:255];
  //bit [7:0] ref_data;

  uvm_tlm_analysis_fifo #(dram_seq_item)ip_fifo;
  uvm_tlm_analysis_fifo #(dram_seq_item)op_fifo;


  function new(string name="dram_sb",uvm_component parent);
    super.new(name,parent);
    ip_fifo=new("ip_fifo",this);
    op_fifo=new("op_fifo",this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    pkt=dram_seq_item::type_id::create("pkt",this);
    pkt1=dram_seq_item::type_id::create("pkt1",this);
  endfunction

  task run_phase(uvm_phase phase);
    forever begin

      /*
      fork
        ip_fifo.get(pkt);
        `uvm_info("SB","TRANSACTIONS FROM MON1",UVM_NONE);
        //$display("sb data_in=%d,addr=%d",pkt.data,pkt.addr);
        op_fifo.get(pkt1);
        `uvm_info("SB","TRANSACTIONS FROM MON2",UVM_NONE);
        //$display("sb data_out=%d,addr=%d",pkt1.data,pkt1.addr);
      join
      */

      //#30;

      ip_fifo.get(pkt);



      //mem[pkt.addr] = pkt.data;

      $display("SB: time=%0t", $time);



      //o_cur_pc_plus_one_o
      if(pkt.o_cur_pc_plus_one_i == pkt.o_cur_pc_plus_one_o) begin
        `uvm_info("SB", $sformatf("o_cur_pc_plus_one PASSED! o_cur_pc_plus_one_i=%0d o_cur_pc_plus_one_o=%0d", pkt.o_cur_pc_plus_one_i, pkt.o_cur_pc_plus_one_o), UVM_NONE)
      end else begin
        `uvm_error("SB", $sformatf("o_cur_pc_plus_one FAILED! o_cur_pc_plus_one_i=%0d o_cur_pc_plus_one_o=%0d", pkt.o_cur_pc_plus_one_i, pkt.o_cur_pc_plus_one_o))
      end

      //CURRENT INSTRUNCTION
      if(pkt.i_cur_insn_i == pkt.i_cur_insn_o) begin
        `uvm_info("SB", $sformatf("i_cur_insn PASSED! i_cur_insn_i=%0d i_cur_insn_i=%0d", pkt.i_cur_insn_i, pkt.i_cur_insn_o), UVM_NONE)
      end else begin
        `uvm_error("SB", $sformatf("i_cur_insn FAILED! i_cur_insn_i=%0d i_cur_insn_i=%0d", pkt.i_cur_insn_i, pkt.i_cur_insn_o))
      end

      //r1sel
      if(pkt.r1sel_i == pkt.r1sel_o) begin
        `uvm_info("SB", $sformatf("r1sel PASSED! r1sel_i=%0b r1sel_i=%0b", pkt.r1sel_i, pkt.r1sel_o), UVM_NONE)
      end else begin
        `uvm_error("SB", $sformatf("r1sel FAILED! r1sel_i=%0b r1sel_o=%0b", pkt.r1sel_i, pkt.r1sel_o))
      end
      
      
      //rere
      if(pkt.r1re_i == pkt.r1re_o) begin
        `uvm_info("SB", $sformatf("r1re PASSED! r1re_i=%0b r1re_o=%0b", pkt.r1re_i, pkt.r1re_o), UVM_NONE)
      end else begin
        `uvm_error("SB", $sformatf("r1re FAILED! r1re_i=%0b r1re_o=%0b", pkt.r1re_i, pkt.r1re_o))
      end    
      
      //r2sel
      if(pkt.r2sel_i == pkt.r2sel_o) begin
        `uvm_info("SB", $sformatf("r2sel PASSED! r2sel_i=%0b r2sel_o=%0b", pkt.r2sel_i, pkt.r2sel_o), UVM_NONE)
      end else begin
        `uvm_error("SB", $sformatf("r2sel FAILED! r2sel_i=%0b r2sel_o=%0b", pkt.r2sel_i, pkt.r2sel_o))
      end      
      
      
      //wsel
      if(pkt.wsel_i == pkt.wsel_o) begin
        `uvm_info("SB", $sformatf("wsel PASSED! wsel_i=%0b wsel_o=%0b", pkt.wsel_i, pkt.wsel_o), UVM_NONE)
      end else begin
        `uvm_error("SB", $sformatf("wsel FAILED! wsel_i=%0b wsel_o=%0b", pkt.wsel_i, pkt.wsel_o))
      end            
      

      //regfile_we
      if(pkt.regfile_we_i == pkt.regfile_we_o) begin
        `uvm_info("SB", $sformatf("regfile_we PASSED! regfile_we_i=%0b regfile_we_o=%0b", pkt.regfile_we_i, pkt.regfile_we_o), UVM_NONE)
      end else begin
        `uvm_error("SB", $sformatf("regfile_we FAILED! regfile_we_i=%0b regfile_we_o=%0b", pkt.regfile_we_i, pkt.regfile_we_o))
      end         
      
      //nzp_we
      if(pkt.nzp_we_i == pkt.nzp_we_o) begin
        `uvm_info("SB", $sformatf("nzp_we PASSED! nzp_we_i=%0b nzp_we_o=%0b", pkt.nzp_we_i, pkt.nzp_we_o), UVM_NONE)
      end else begin
        `uvm_error("SB", $sformatf("nzp_we FAILED! nzp_we_i=%0b nzp_we_o=%0b", pkt.nzp_we_i, pkt.nzp_we_o))
      end               
      

      //select_pc_plus_one
      if(pkt.select_pc_plus_one_i == pkt.select_pc_plus_one_o) begin
        `uvm_info("SB", $sformatf("select_pc_plus_one PASSED! select_pc_plus_one_i=%0b select_pc_plus_one_o=%0b", pkt.select_pc_plus_one_i, pkt.select_pc_plus_one_o), UVM_NONE)
      end else begin
        `uvm_error("SB", $sformatf("select_pc_plus_one FAILED! select_pc_plus_one_i=%0b select_pc_plus_one_o=%0b", pkt.select_pc_plus_one_i, pkt.select_pc_plus_one_o))
      end

      
      //is_load
      if(pkt.is_load_i == pkt.is_load_o) begin
        `uvm_info("SB", $sformatf("is_load PASSED! is_load_i=%0b is_load_o=%0b", pkt.is_load_i, pkt.is_load_o), UVM_NONE)
      end else begin
        `uvm_error("SB", $sformatf("is_load FAILED! is_load_i=%0b is_load_o=%0b", pkt.is_load_i, pkt.is_load_o))
      end      
      
      //is_store
      if(pkt.is_store_i == pkt.is_store_o) begin
        `uvm_info("SB", $sformatf("is_store PASSED! is_store_i=%0b is_store_o=%0b", pkt.is_store_i, pkt.is_store_o), UVM_NONE)
      end else begin
        `uvm_error("SB", $sformatf("is_store FAILED! is_store_i=%0b is_store_o=%0b", pkt.is_store_i, pkt.is_store_o))
      end            
      
      //is_branch
      if(pkt.is_branch_i == pkt.is_branch_o) begin
        `uvm_info("SB", $sformatf("is_branch PASSED! is_branch_i=%0b is_branch_o=%0b", pkt.is_branch_i, pkt.is_branch_o), UVM_NONE)
      end else begin
        `uvm_error("SB", $sformatf("is_branch_o FAILED! is_branch_i=%0b is_branch_o=%0b", pkt.is_branch_i, pkt.is_branch_o))
      end       
      
      //is_control_insn
      if(pkt.is_control_insn_i == pkt.is_control_insn_o) begin
        `uvm_info("SB", $sformatf("is_control_insn PASSED! is_control_insn_i=%0b is_control_insn_o=%0b", pkt.is_control_insn_i, pkt.is_control_insn_o), UVM_NONE)
      end else begin
        `uvm_error("SB", $sformatf("is_control_insn FAILED! is_control_insn_i=%0b is_control_insn_o=%0b", pkt.is_control_insn_i, pkt.is_control_insn_o))
      end            
      
      //o_rs_data
      if(pkt.o_rs_data_i == pkt.o_rs_data_o) begin
        `uvm_info("SB", $sformatf("o_rs_data PASSED! o_rs_data_i=%0b o_rs_data_o=%0b", pkt.o_rs_data_i, pkt.o_rs_data_o), UVM_NONE)
      end else begin
        `uvm_error("SB", $sformatf("o_rs_data FAILED! o_rs_data_i=%0b o_rs_data_o=%0b", pkt.o_rs_data_i, pkt.o_rs_data_o))
      end                  
      
      //o_rt_data
      if(pkt.o_rt_data_i == pkt.o_rt_data_o) begin
        `uvm_info("SB", $sformatf("o_rt_data PASSED! o_rt_data_i=%0b o_rt_data_o=%0b", pkt.o_rt_data_i, pkt.o_rt_data_o), UVM_NONE)
      end else begin
        `uvm_error("SB", $sformatf("o_rt_data FAILED! o_rt_data_i=%0b o_rt_data_o=%0b", pkt.o_rt_data_i, pkt.o_rt_data_o))
      end 
      
      //i_wdata
      if(pkt.i_wdata_i == pkt.i_wdata_o) begin
        `uvm_info("SB", $sformatf("i_wdata PASSED! i_wdata_i=%0b i_wdata_o=%0b", pkt.i_wdata_i, pkt.i_wdata_o), UVM_NONE)
      end else begin
        `uvm_error("SB", $sformatf("i_wdata FAILED! i_wdata_i=%0b i_wdata_o=%0b", pkt.i_wdata_i, pkt.i_wdata_o))
      end
      
      //alu_result
      if(pkt.alu_result_i == pkt.alu_result_o) begin
        `uvm_info("SB", $sformatf("alu_result PASSED! alu_result_i=%0b alu_result_o=%0b", pkt.alu_result_i, pkt.alu_result_o), UVM_NONE)
      end else begin
        `uvm_error("SB", $sformatf("alu_result FAILED! alu_result_i=%0b alu_result_o=%0b", pkt.alu_result_i, pkt.alu_result_o))
      end      
      
      //lmd
      if(pkt.lmd_i == pkt.lmd_o) begin
        `uvm_info("SB", $sformatf("lmd PASSED! lmd_i=%0b lmd_o=%0b", pkt.lmd_i, pkt.lmd_o), UVM_NONE)
      end else begin
        `uvm_error("SB", $sformatf("lmd FAILED! lmd_i=%0b lmd_o=%0b", pkt.lmd_i, pkt.lmd_o))
      end            
      

    end


  endtask

endclass

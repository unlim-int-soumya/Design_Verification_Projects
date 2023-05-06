class dram_cov extends uvm_subscriber #(dram_seq_item);

  //----------------------------------------------------------------------------
  `uvm_component_utils(dram_cov)
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  function new(string name="",uvm_component parent);
    super.new(name,parent);
    dut_cov=new();
  endfunction
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  dram_seq_item txn;
  real cov;
  //----------------------------------------------------------------------------
  
  //----------------------------------------------------------------------------
  covergroup dut_cov;
    option.per_instance= 1;
    option.comment     = "dut_cov";
    option.name        = "dut_cov";
    option.auto_bin_max= 255;
    
    o_cur_pc_plus_one_i  : coverpoint txn.o_cur_pc_plus_one_i;
    i_cur_insn_i  : coverpoint txn.i_cur_insn_i;
    r1sel_i  : coverpoint txn.r1sel_i;
    r2sel_i  : coverpoint txn.r2sel_i;
    wsel_i  : coverpoint txn.wsel_i;
   
    //CROSS : cross READ,WRITE;
  endgroup:dut_cov;

  //----------------------------------------------------------------------------

  //---------------------  write method ----------------------------------------
  function void write(dram_seq_item t);
    txn=t;
    dut_cov.sample();
  endfunction
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    cov=dut_cov.get_coverage();
  endfunction
  //----------------------------------------------------------------------------


  //----------------------------------------------------------------------------
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(),$sformatf("Coverage is %f",cov),UVM_MEDIUM)
  endfunction
  //----------------------------------------------------------------------------
  
endclass:dram_cov


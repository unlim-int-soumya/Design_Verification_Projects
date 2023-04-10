class sco extends uvm_scoreboard;
  `uvm_component_utils(sco)

  transaction tr, trref;

  uvm_tlm_analysis_fifo#(transaction) sco_data;
  uvm_tlm_analysis_fifo#(transaction) sco_data_ref;

  function new(input string inst = "sco", uvm_component parent = null);
    super.new(inst,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = transaction::type_id::create("tr");
    trref = transaction::type_id::create("tr_ref");
    sco_data = new("sco_data", this);
    sco_data_ref = new("sco_data_ref", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      sco_data.get(tr);
      sco_data_ref.get(trref);

      //Data Obtained from MONITOR
      `uvm_info("SB",$sformatf("INPUTS FROM MON: tr.insn =%0b", tr.insn),UVM_LOW);

      `uvm_info("SB",$sformatf("OUTPUTS FROM MON: \ntr.r1sel = %0b tr.r1re<= %0b tr.r2sel<= %0b tr.r2re <= %0b tr.wsel <= %0b \ntr.regfile_we <= %0b tr.nzp_we <= %0b tr.select_pc_plus_one <= %0b tr.is_load <= %0b tr.is_store <= %0b \ntr.is_branch <= %0b tr.is_control_insn <= %0b", tr.r1sel, tr.r1re,tr.r2sel, tr.r2re,tr.wsel,tr.regfile_we,tr.nzp_we, tr.select_pc_plus_one, tr.is_load, tr.is_store, tr.is_branch, tr.is_control_insn),UVM_NONE);


      //Data Obtained from DEC ENGINE
      `uvm_info("SB",$sformatf("INPUTS FROM DECODER: trref.insn =%0b", trref.insn),UVM_LOW);

      `uvm_info("SB",$sformatf("OUTPUTS FROM DECODER: \ntrref.r1sel = %0b trref.r1re<= %0b trref.r2sel<= %0b trref.r2re <= %0b trref.wsel <= %0b \ntrref.regfile_we <= %0b trref.nzp_we <= %0b trref.select_pc_plus_one <= %0b trref.is_load <= %0b trref.is_store <= %0b \ntrref.is_branch <= %0b trref.is_control_insn <= %0b\n", trref.r1sel, trref.r1re,trref.r2sel, trref.r2re,trref.wsel,trref.regfile_we,trref.nzp_we, trref.select_pc_plus_one, trref.is_load, trref.is_store, trref.is_branch, trref.is_control_insn),UVM_LOW);

      
      if(tr.compare(trref))  begin
        `uvm_info("SCO", "Test Passed\n\n", UVM_NONE)
      end
      else  begin
        `uvm_info("SCO", "Test Failed\n\n", UVM_NONE)
      end


    end
  endtask

endclass

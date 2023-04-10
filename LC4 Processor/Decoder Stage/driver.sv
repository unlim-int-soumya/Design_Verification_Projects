class drv extends uvm_driver#(transaction);

  `uvm_component_utils(drv)

  transaction tr;
  virtual mux_if mif;

  function new(input string path = "drv", uvm_component parent = null);
    super.new(path,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual mux_if)::get(this,"","mif",mif))//uvm_test_top.env.agent.drv.aif
      `uvm_error("drv","Unable to access Interface");
  endfunction

  virtual task run_phase(uvm_phase phase);
    tr = transaction::type_id::create("tr");
    forever begin


      //Immidiately gets data from generator
      seq_item_port.get_next_item(tr);

      mif.insn <= tr.insn;

      `uvm_info("DRV",$sformatf("INPUTS: \ntr.insn =%0b", tr.insn),UVM_NONE);

      `uvm_info("DRV",$sformatf("OUTPUTS: \ntr.insn = %0b tr.r1sel = %0b tr.r1re<= %0b tr.r2sel<= %0b tr.r2re <= %0b tr.wsel <= %0b \ntr.regfile_we <= %0b tr.nzp_we <= %0b tr.select_pc_plus_one <= %0b tr.is_load <= %0b tr.is_store <= %0b \ntr.is_branch <= %0b tr.is_control_insn <= %0b", tr.insn, tr.r1sel, tr.r1re,tr.r2sel, tr.r2re,tr.wsel,tr.regfile_we,tr.nzp_we, tr.select_pc_plus_one, tr.is_load, tr.is_store, tr.is_branch, tr.is_control_insn),UVM_NONE);

      //`uvm_info("DRV", $sformatf("a:%0d b:%0d c:%0d d:%0d sel:%0d y:%0d",tr.a, tr.b,tr.c,tr.d,tr.sel,tr.y), UVM_NONE);
      
      seq_item_port.item_done();

      //20 seconds rest then try to gets the next transaction
      #20;
    end
  endtask

endclass
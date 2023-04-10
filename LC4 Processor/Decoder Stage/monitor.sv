class mon extends uvm_monitor;
  `uvm_component_utils(mon)

  uvm_analysis_port#(transaction) send;
  transaction tr;
  virtual mux_if mif;

  function new(input string inst = "mon", uvm_component parent = null);
    super.new(inst,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = transaction::type_id::create("tr");
    send = new("send", this);
    if(!uvm_config_db#(virtual mux_if)::get(this,"","mif",mif))//uvm_test_top.env.agent.drv.aif
      `uvm_error("drv","Unable to access Interface");
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      //After 20 unit of driver sents the data to IF, it starts receiving the data
      #20;

      /*
      tr.a = mif.a;
      tr.b = mif.b;
      tr.c = mif.c;
      tr.d = mif.d;
      tr.sel = mif.sel;
      tr.y = mif.y;
      */


      //Inputs
      tr.insn = mif.insn;

      //Outputs
      //tr.insn <= mif.insn;   
      tr.r1sel = mif.r1sel; 
      tr.r1re = mif.r1re;   
      tr.r2sel = mif.r2sel; 
      tr.r2re = mif.r2re;
      tr.wsel = mif.wsel;
      tr.regfile_we = mif.regfile_we;
      tr.nzp_we = mif.nzp_we;
      tr.select_pc_plus_one = mif.select_pc_plus_one; 
      tr.is_load = mif.is_load; 
      tr.is_store = mif.is_store;
      tr.is_branch = mif.is_branch;
      tr.is_control_insn = mif.is_control_insn;


      `uvm_info("MON_DUT",$sformatf("INPUTS: \ntr.insn =%0b", tr.insn),UVM_NONE);

      `uvm_info("MON_DUT",$sformatf("OUTPUTS: \ntr.insn = %0b tr.r1sel = %0b tr.r1re<= %0b tr.r2sel<= %0b tr.r2re <= %0b tr.wsel <= %0b \ntr.regfile_we <= %0b tr.nzp_we <= %0b tr.select_pc_plus_one <= %0b tr.is_load <= %0b tr.is_store <= %0b \ntr.is_branch <= %0b tr.is_control_insn <= %0b", tr.insn, tr.r1sel, tr.r1re,tr.r2sel, tr.r2re,tr.wsel,tr.regfile_we,tr.nzp_we, tr.select_pc_plus_one, tr.is_load, tr.is_store, tr.is_branch, tr.is_control_insn),UVM_NONE);

      //`uvm_info("MON_DUT", $sformatf("a:%0d b:%0d c:%0d d:%0d sel:%0d y:%0d", tr.a, tr.b,tr.c,tr.d,tr.sel,tr.y), UVM_NONE);
      send.write(tr);
    end
  endtask

endclass
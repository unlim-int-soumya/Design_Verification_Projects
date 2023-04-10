class generator extends uvm_sequence#(transaction);
  `uvm_object_utils(generator)

  transaction tr;

  function new(input string path = "generator");
    super.new(path);
  endfunction

  virtual task body();
    repeat(15)
      begin
        tr = transaction::type_id::create("tr");
        start_item(tr);
        assert(tr.randomize());
        //`uvm_info("SEQ", $sformatf("a:%0d b:%0d c:%0d d:%0d sel:%0d y:%0d",
                                   //tr.a, tr.b, tr.c, tr.d, tr.sel, tr.y), UVM_NONE);

        `uvm_info("SEQ",$sformatf("INPUTS: \ntr.insn =%0b", tr.insn),UVM_NONE);

        `uvm_info("SEQ",$sformatf("OUTPUTS: \ntr.insn = %0b tr.r1sel = %0b tr.r1re<= %0b tr.r2sel<= %0b tr.r2re <= %0b tr.wsel <= %0b \ntr.regfile_we <= %0b tr.nzp_we <= %0b tr.select_pc_plus_one <= %0b tr.is_load <= %0b tr.is_store <= %0b \ntr.is_branch <= %0b tr.is_control_insn <= %0b", tr.insn, tr.r1sel, tr.r1re,tr.r2sel, tr.r2re,tr.wsel,tr.regfile_we,tr.nzp_we, tr.select_pc_plus_one, tr.is_load, tr.is_store, tr.is_branch, tr.is_control_insn),UVM_NONE);


        finish_item(tr);
      end
  endtask

endclass
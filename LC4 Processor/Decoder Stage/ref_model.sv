class ref_model extends uvm_monitor;
  `uvm_component_utils(ref_model)

  uvm_analysis_port#(transaction) send_ref;
  transaction tr;
  virtual mux_if mif;


  //Variables
  //variables
  bit [15:0] insn;               // instruction
  bit [ 2:0] r1sel;              // rs
  bit        r1re;               // does this instruction read from rs?
  bit [ 2:0] r2sel;              // rt
  bit        r2re;               // does this instruction read from rt?
  bit [ 2:0] wsel;               // rd
  bit        regfile_we;         // does this instruction write to rd?
  bit        nzp_we;             // does this instruction write the NZP bits?
  bit        select_pc_plus_one; // route PC+1 to the ALU instead of rs?
  bit        is_load;            // is this a load instruction?
  bit        is_store;           // is this a store instruction?
  bit        is_branch;          // is this a branch instruction?
  bit        is_control_insn;    

  //Intermediate Variable
  bit [3:0] opcode;
  bit is_add, is_mul, is_sub, is_div, is_addi;
  bit is_cmp, is_cmpu, is_cmpi, is_cmpiu;
  bit is_and, is_not, is_or, is_xor,is_andi;
  bit is_ldr, is_str, is_rti, is_const;
  bit is_sll, is_sra, is_srl, is_mod;
  bit is_hiconst, is_trap;
  bit is_jmpr, is_jmp, is_jsr, is_jsrr;
  bit is_arith;

  bit is_shift;
  bit is_logic;
  bit is_compare;
  bit is_tri;




  function new(input string inst = "ref_model", uvm_component parent = null);
    super.new(inst,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = transaction::type_id::create("tr");
    send_ref = new("send_ref", this);
    if(!uvm_config_db#(virtual mux_if)::get(this,"","mif",mif))//uvm_test_top.env.agent.drv.aif
      `uvm_error("ref_model","Unable to access Interface");
  endfunction

 
  function void predict();
    opcode = tr.insn[15:12];

    is_branch = (opcode == 4'b0000 & tr.insn != 0);

    is_arith = (opcode == 4'b0001);

    is_add = (is_arith & (tr.insn[5:3] == 3'b000));

    is_mul = (is_arith & (tr.insn[5:3] == 3'b001));

    is_sub = (is_arith & (tr.insn[5:3] == 3'b010));

    is_div = (is_arith & (tr.insn[5:3] == 3'b011));

    is_addi = (is_arith & tr.insn[5]);

    is_compare = (opcode == 4'b0010);

    is_cmp = (is_compare & (tr.insn[8:7] == 2'b00));

    is_cmpu = (is_compare & (tr.insn[8:7] == 2'b01));

    is_cmpi = (is_compare & (tr.insn[8:7] == 2'b10));

    is_cmpiu = (is_compare & (tr.insn[8:7] == 2'b11));

    is_jsr = (tr.insn[15:11] == 5'b01001);

    is_jsrr = (tr.insn[15:11] == 5'b01000);

    is_logic = (opcode == 4'b0101);

    is_and = (is_logic & (tr.insn[5:3] == 3'b000));

    is_not = (is_logic & (tr.insn[5:3] == 3'b001));

    is_or = (is_logic & (tr.insn[5:3] == 3'b010));

    is_xor = (is_logic & (tr.insn[5:3] == 3'b011));

    is_andi = (is_logic & tr.insn[5]);

    is_ldr = (opcode == 4'b0110);

    is_str = (opcode == 4'b0111);

    is_rti = (opcode == 4'b1000);

    is_const = (opcode == 4'b1001);


    is_shift = (opcode == 4'b1010);
    is_sll = (is_shift & (tr.insn[5:4] == 2'b00));
    is_sra = (is_shift & (tr.insn[5:4] == 2'b01));
    is_srl = (is_shift & (tr.insn[5:4] == 2'b10));
    is_mod = (is_shift & (tr.insn[5:4] == 2'b11));


    is_jmpr = (tr.insn[15:11] == 5'b11000);
    is_jmp = (tr.insn[15:11] == 5'b11001);
    is_hiconst = (opcode == 4'b1101);
    is_trap = (opcode == 4'b1111);


    r1sel = (is_compare | is_hiconst) ? tr.insn[11:9] :  
    (is_rti) ? 3'd7 : tr.insn[8:6];
    r1re = is_arith | 
    is_compare | 
    is_jsrr | 
    is_logic | 
    is_ldr | 
    is_str | 
    is_rti | 
    is_shift | 
    is_jmpr |
    is_hiconst
    ;

    //r2sel = 0;
    r2sel = (is_str) ? tr.insn[11:9] : tr.insn[2:0]; 

    r2re = is_add | is_mul |  is_sub | is_div |
    is_cmp | is_cmpu |
    is_and | is_or | is_xor |
    is_str |
    is_mod;

    wsel = (is_jsr | is_jsrr | is_trap) ? 3'd7 : tr.insn[11:9];  

    regfile_we = is_arith | is_jsr | is_jsrr | is_logic | is_ldr | is_const | is_shift | is_hiconst | is_trap;

    nzp_we = regfile_we | is_compare;
    select_pc_plus_one = is_trap | is_jsrr | is_jsr;
    is_load = is_ldr;
    is_store = is_str;
    is_control_insn =  is_jsr | is_jsrr | is_rti | is_jmpr | is_jmp | is_trap;

  endfunction



  virtual task run_phase(uvm_phase phase);
    forever begin
      //Refernce model also wait the same amount like monitor
      #20;   

      //Inputs
      tr.insn = mif.insn;

      //Computation
      predict();


      //Outputs
      tr.r1sel = r1sel;              // rs
      tr.r1re = r1re;               // does this instruction read from rs?
      tr.r2sel = r2sel;              // rt
      tr.r2re = r2re;               // does this instruction read from rt?
      tr.wsel = wsel;               // rd
      tr.regfile_we = regfile_we;         // does this instruction write to rd?
      tr.nzp_we = nzp_we;             // does this instruction write the NZP bits?
      tr.select_pc_plus_one = select_pc_plus_one; // route PC+1 to the ALU instead of rs?
      tr.is_load =is_load;            // is this a load instruction?
      tr.is_store = is_store;           // is this a store instruction?
      tr.is_branch = is_branch;          // is this a branch instruction?
      tr.is_control_insn = is_control_insn;

      `uvm_info("DEC",$sformatf("INPUTS: \ntr.insn =%0b", tr.insn),UVM_LOW);

      `uvm_info("DEC",$sformatf("OUTPUTS: \ntr.insn = %0b tr.r1sel = %0b tr.r1re<= %0b tr.r2sel<= %0b tr.r2re <= %0b tr.wsel <= %0b \ntr.regfile_we <= %0b tr.nzp_we <= %0b tr.select_pc_plus_one <= %0b tr.is_load <= %0b tr.is_store <= %0b \ntr.is_branch <= %0b tr.is_control_insn <= %0b", tr.insn, tr.r1sel, tr.r1re,tr.r2sel, tr.r2re,tr.wsel,tr.regfile_we,tr.nzp_we, tr.select_pc_plus_one, tr.is_load, tr.is_store, tr.is_branch, tr.is_control_insn),UVM_NONE);

      send_ref.write(tr);



    end
  endtask

endclass
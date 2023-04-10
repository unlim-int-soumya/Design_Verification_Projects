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

    is_shift = (opcode == 4'b1010) ? 1'b1: 1'b0;
    is_logic = (opcode == 4'b0101) ? 1'b1 : 1'b0;
    is_compare = (opcode == 4'b0010) ? 1'b1 : 1'b0;


    if(opcode == 4'b0000 && tr.insn!=0) begin
      is_branch = 1'b1;   
    end

    //Arithematic


    is_arith = (opcode == 4'b0000) ? 1'b1 : 1'b0;

    if(opcode == 4'b0000) begin
      case(tr.insn[5:3])
        3'b000:
          begin
            is_add = 1;		
          end
        3'b001:
          begin
            is_mul = 1;		
          end
        3'b010:
          begin
            is_sub = 1;		
          end
        3'b011:
          begin
            is_div = 1;		
          end
      endcase
      if(tr.insn[5]==1) 
        is_addi =1;

      //Comapare Insn

    end else if(opcode == 4'b0010) begin
      case(tr.insn[8:7])
        2'b00:
          begin
            is_cmp = 1'b1;
          end
        2'b01:
          begin
            is_cmpu = 1'b1;
          end
        2'b10:
          begin
            is_cmpi = 1'b1;
          end
        2'b11:
          begin
            is_cmpiu = 1'b1;
          end
      endcase

      //LOGICAL

    end else if(opcode == 4'b0101) begin
      case(tr.insn[5:3])
        3'b000:
          begin
            is_and = 1'b1;
          end
        3'b001:
          begin
            is_not = 1'b1;
          end
        3'b010:
          begin
            is_or = 1'b1;
          end
        3'b011:
          begin
            is_xor = 1'b1;
          end
      endcase	
      if(tr.insn[5])	is_andi = 1'b1;	


      //Load Store and all

    end else if (opcode ==4'b0110) begin
      is_ldr <= 1'b1;

    end else if(opcode == 4'b0111) begin
      is_str <= 1'b1;

    end else if(opcode == 4'b1000) begin
      is_rti <= 1'b1;

    end else if(opcode == 4'b1001) begin
      is_const <= 1'b1;

      //SHIFT

    end else if(opcode == 4'b1010) begin
      case(tr.insn[5:3])
        2'b00:
          begin
            is_sll = 1'b1;
          end
        2'b01:
          begin
            is_sra = 1'b1;
          end
        2'b10:
          begin
            is_srl = 1'b1;
          end
        2'b11:
          begin
            is_mod = 1'b1;
          end
      endcase


    end else if(opcode == 4'b1101) begin
      is_hiconst <= 1'b1;
    end else if(opcode == 4'b1111) begin
      is_trap <= 1'b1;
    end 


    if(tr.insn[15:11]==5'b11000) begin
      is_jmpr <= 1'b1;
    end else if(insn[15:11] == 5'b11001) begin
      is_jmp <= 1'b1;
    end else if(insn[15:11]==5'b01001) begin
      is_jsr <= 1'b1;
    end else if(insn[15:11] == 5'b01000) begin
      is_jsrr <= 1'b1;
    end 

    //Regfister file

    //r1sel
    if(is_compare || is_const) begin
      r1sel <= tr.insn[11:9];
    end else if(is_rti) begin
      r1sel <= 3'd7;
    end else begin
      r1sel <= tr.insn[8:6];
    end


    //r1re
    if(is_arith || is_compare || is_jsrr || is_logic || is_ldr || is_str || is_rti ||is_shift ||is_jmpr || is_hiconst)
      r1re = 1'b1;

    //r2sel
    if(is_str) begin
      r2sel <= tr.insn[11:9];
    end else begin
      r2sel <= tr.insn[2:0];
    end

    //r2re
    if(is_add || is_mul || is_sub || is_div || is_cmp || is_cmpu || is_and || is_or || is_xor || is_str || is_mod)
      r2re = 1'b1;

    //wsel 
    if(is_jsr || is_jsrr || is_trap) begin
      wsel <= 3'd7;
    end else begin
      wsel <= tr.insn[11:9];
    end

    //regfile_we
    if(is_arith || is_jsr || is_jsrr || is_logic || is_ldr || is_const || is_shift || is_hiconst || is_trap) 
      regfile_we = 1'b1;

    //nzp_we 
    if(regfile_we || is_compare) 
      nzp_we = 1'b1;

    //select_pc_plus_one
    if(is_trap || is_jsrr || is_jsr) 
      select_pc_plus_one = 1'b1;

    //is_load
    is_load = is_ldr;


    //is_store
    is_store = is_str;

    //is_control_insn
    if(is_jsr || is_jsrr || is_rti || is_jmpr || is_jmp ||is_trap) begin
      is_control_insn = 1'b1;
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
      //Refernce model also wait the same amount like monitor
      #20;
      /*
      tr.a = mif.a;
      tr.b = mif.b;
      tr.c = mif.c;
      tr.d = mif.d;
      tr.sel = mif.sel;
      */

      predict();

      //Inputs
      tr.insn = mif.insn;

      //tr.insn = pkt2.insn;            // instruction

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

      //`uvm_info("MON_REF", $sformatf("a:%0d b:%0d c:%0d d:%0d sel:%0d y:%0d", tr.a, tr.b,tr.c,tr.d,tr.sel,tr.y), UVM_NONE);
      send_ref.write(tr);



    end
  endtask

endclass
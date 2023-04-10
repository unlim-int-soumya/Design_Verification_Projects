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


      /*
      `uvm_info("SB", "Data Receiving from MON1 is as follow:\n", UVM_NONE);
      $display("SB: gwe=%0b reg_we=%0b next_pc=%0d", pkt.gwe, pkt.reg_we, pkt.next_pc);

      $display("SB: pc=%0d test_stall_f=%0b", pkt.pc, pkt.test_stall_f);

      `uvm_info("SB", "Data Received from MON1 : Done:", UVM_NONE);
      */

      if(pkt.next_pc == pkt.pc) begin
        `uvm_info("SB", $sformatf("PC PASSED! next_pc=%0d pc=%0d", pkt.next_pc, pkt.pc), UVM_NONE)
      end else begin
        `uvm_error("SB", $sformatf("PC Failed! next_pc=%0d pc=%0d", pkt.next_pc, pkt.pc))
      end

      if(pkt.test_stall_f == 0) begin
        `uvm_info("SB", $sformatf("STALL PASSED! test_stall_f=%0b", pkt.test_stall_f), UVM_NONE)
      end else begin
        `uvm_error("SB", $sformatf("STALL Failed! test_stall_f=%0b", pkt.test_stall_f))
      end


    end


  endtask

endclass

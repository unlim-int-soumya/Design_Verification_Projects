`timescale 1ns / 1ps

// Code your testbench here
// or browse Examples

// including the 'lc4_we_gen' module
`include "../design/include/clock_util.v"


// including the 'lc4_memory' module
`include "../design/include/lc4_memory.v"


// including the 'lc4_interface'
`include "../common/lc4_interface.sv"

// assertion module
`include "lc4_assertion.sv"

// including the 'lc4_package' module
`include "../env/lc4_package.sv"

import lc4_pkg::*;

// Including the whole testbench environment
`include "lc4_test_lib.sv"

module tb_top;

  // globally used signals
  reg clk, rst;

  // signals used in 'lc4_we_gen' module
  // Produce gwe and other we signals using same modules as lc4_system
  wire i1re, i2re, dre, gwe;

  // Below signals used in 'lc4_memory' module
  logic [15:0] cur_insn;
  wire [15:0] cur_dmem_data;

  // Outputs
  wire [15:0] cur_pc, cur_pc_plus1;
  wire [15:0] dmem_addr;
  wire [15:0] dmem_towrite;
  wire        dmem_we;

  // video out signal
  wire [15:0] vout_dummy;  // video out

  lc4_interface pif(clk, rst);	// Physical Interface


  // global clock generation 
  initial begin
    clk =0;
    forever #5 clk = ~clk;
  end


  // global reset generation
  initial begin
    rst = 1;
    //@(posedge clk);
    //@(posedge clk);
    #50;
    rst = 0;

    #14000;
    rst = 1;

  end



  //assign pif.i_cur_insn_A = cur_insn_A;
  //assign pif.i_cur_insn_B = cur_insn_B;


  // setting up lc4_interface configuration globally for all components
  initial begin
    uvm_config_db #(virtual lc4_interface)::set(uvm_root::get(),"*","pif",pif);
  end


  // Making available the values of 'i_cur_insn_A' & 'i_cur_insn_B'
  initial begin
    uvm_config_db #(logic)::set(uvm_root::get(),"*","pif.i_cur_insn",cur_insn);
  end


  string test_case_name;

  initial begin

    // Retrieve the value of TEST_CASE command-line argument
    if ($value$plusargs("TEST_CASE=%s", test_case_name)) begin
      $display("Running test case: %s", test_case_name);
      run_test(test_case_name);
    end else begin
      $display("No test case name provided. Running default test.");
      run_test("lc4_5_test"); // You can set a default test case name here
    end
    // Additional initialization code here...
  end  

  // we generator module
  lc4_we_gen we_gen(.clk(pif.clk),
      .i1re(i1re),
      .i2re(i2re),
      .dre(dre),
      .gwe(pif.gwe)
  );


  /*
  // Data and video memory block 
  lc4_memory memory (.idclk(pif.clk),
		  .i1re(i1re),
		  .i2re(i2re),
		  .dre(dre),
		  .gwe(pif.gwe),
		  .rst(pif.rst),
      .i1addr(cur_pc),
		  .i2addr(16'd0),      // Not used for scalar processors
      .i1out(pif.i_cur_insn),
      .daddr(dmem_addr),
		  .din(dmem_towrite),
      .dout(cur_dmem_data),
      .dwe(dmem_we),
      .vclk(1'b0),
      .vaddr(16'h0000),
      .vout(vout_dummy)
  );
  */

    // Data and video memory block 
  lc4_memory memory (.idclk(pif.clk),
		  .i1re(i1re),
		  .i2re(i2re),
		  .dre(dre),
		  .gwe(pif.gwe),
		  .rst(pif.rst),
      .i1addr(pif.o_cur_pc),
		  .i2addr(16'd0),      // Not used for scalar processors
      .i1out(pif.i_cur_insn),
      .daddr(pif.o_dmem_addr),
		  .din(pif.o_dmem_towrite),
      .dout(pif.i_cur_dmem_data),
      .dwe(pif.o_dmem_we),
      .vclk(1'b0),
      .vaddr(16'h0000),
      .vout(vout_dummy)
  );




  //.i_cur_insn_A(pif.i_cur_insn_A),    // output of instruction memory (pipe A)
  //.i_cur_insn_B(pif.i_cur_insn_B),    // output of instruction memory (pipe B)

  // main lc4_processor module    
  lc4_processor dut(
      .clk(pif.clk),             // main clock
      .rst(pif.rst),             // global reset
      .gwe(pif.gwe),             // global we for single-step clock

      .o_cur_pc(pif.o_cur_pc),        // address to read from instruction memory

      .i_cur_insn(pif.i_cur_insn),    // output of instruction memory
      
      .o_dmem_addr(pif.o_dmem_addr),     // address to read/write from/to data memory
      .i_cur_dmem_data(pif.i_cur_dmem_data), // contents of o_dmem_addr
      .o_dmem_we(pif.o_dmem_we),       // data memory write enable
      .o_dmem_towrite(pif.o_dmem_towrite),  // data to write to o_dmem_addr if we is set

      // testbench signals (always emitted from the WB stage)
      .test_stall(pif.test_stall),        // is this a stall cycle?  (0: no stall,

      .test_cur_pc(pif.test_cur_pc),       // program counter
      .test_cur_insn(pif.test_cur_insn),     // instruction bits
      .test_regfile_we(pif.test_regfile_we),   // register file write-enable
      .test_regfile_wsel(pif.test_regfile_wsel), // which register to write
      .test_regfile_data(pif.test_regfile_data), // data to write to register file
      .test_nzp_we(pif.test_nzp_we),       // nzp register write enable
      .test_nzp_new_bits(pif.test_nzp_new_bits), // new nzp bits
      .test_dmem_we(pif.test_dmem_we),      // data memory write enable
      .test_dmem_addr(pif.test_dmem_addr),    // address to read/write from/to memory
      .test_dmem_data(pif.test_dmem_data),    // data to read/write from/to memory
    
      // zedboard switches/display/leds (ignore if you don't want to control these)
      .switch_data(pif.switch_data),         // read on/off status of zedboard's 8 switches
      .led_data(pif.led_data),             // set on/off status of zedboard's 8 leds

      // Extra testbench signals
      .test_dec_insn(pif.test_dec_insn),    // Instruction at decode stage
      .test_ex_insn(pif.test_ex_insn),      // Instruction at execute stage
      .test_mem_insn(pif.test_mem_insn)     // Instruction at memory stage
  ); //slave model.


  // main lc4_processor module    
  bind lc4_processor lc4_assertion lc4_assertion_i(
      .clk(pif.clk),             // main clock
      .rst(pif.rst),             // global reset
      .gwe(pif.gwe),             // global we for single-step clock

      .o_cur_pc(o_cur_pc),        // address to read from instruction memory

      .i_cur_insn(pif.i_cur_insn),    // output of instruction memory
      
      .o_dmem_addr(o_dmem_addr),     // address to read/write from/to data memory
      .i_cur_dmem_data(pif.i_cur_dmem_data), // contents of o_dmem_addr
      .o_dmem_we(o_dmem_we),       // data memory write enable
      .o_dmem_towrite(o_dmem_towrite),  // data to write to o_dmem_addr if we is set

      // testbench signals (always emitted from the WB stage)
      .test_stall(test_stall),        // is this a stall cycle?  (0: no stall,

      .test_cur_pc(test_cur_pc),       // program counter
      .test_cur_insn(test_cur_insn),     // instruction bits
      .test_regfile_we(test_regfile_we),   // register file write-enable
      .test_regfile_wsel(test_regfile_wsel), // which register to write
      .test_regfile_data(test_regfile_data), // data to write to register file
      .test_nzp_we(test_nzp_we),       // nzp register write enable
      .test_nzp_new_bits(test_nzp_new_bits), // new nzp bits
      .test_dmem_we(test_dmem_we),      // data memory write enable
      .test_dmem_addr(test_dmem_addr),    // address to read/write from/to memory
      .test_dmem_data(test_dmem_data),    // data to read/write from/to memory
    
      // zedboard switches/display/leds (ignore if you don't want to control these)
      .switch_data(switch_data),         // read on/off status of zedboard's 8 switches
      .led_data(led_data),             // set on/off status of zedboard's 8 leds
      


      // Extra testbench signals
      .test_dec_insn(test_dec_insn),    // Instruction at decode stage
      .test_ex_insn(test_ex_insn),      // Instruction at execute stage
      .test_mem_insn(test_mem_insn)     // Instruction at memory stage
      ); //slave model.



  // initialization of all input signals 
  initial begin
    reset_design_inputs();
  end


  task reset_design_inputs();
      pif.gwe = 1;             // global we for single-step clock

      //pif.i_cur_insn_A = 0;    // output of instruction memory (pipe A)
      //pif.i_cur_insn_B = 0;    // output of instruction memory (pipe B)
    
      // zedboard switches/display/leds (ignore if you don't want to control these)
      pif.switch_data = 0;         // read on/off status of zedboard's 8 switches

  endtask


endmodule

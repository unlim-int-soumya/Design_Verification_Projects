module lc4_assertion(
    input wire         clk,
    input wire         rst,
    input wire         gwe,

    output wire [15:0] o_cur_pc,
    input wire [15:0]  i_cur_insn,
    output wire [15:0] o_dmem_addr,
    input wire [15:0]  i_cur_dmem_data,
    output wire        o_dmem_we,
    output wire [15:0] o_dmem_towrite,

    output wire [1:0]  test_stall,
    output wire [15:0] test_cur_pc,
    output wire [15:0] test_cur_insn,
    output wire        test_regfile_we, 
    output wire [2:0]  test_regfile_wsel, 
    output wire [15:0] test_regfile_data,
    output wire        test_nzp_we,
    output wire [2:0]  test_nzp_new_bits,
    output wire        test_dmem_we,
    output wire [15:0] test_dmem_addr,
    output wire [15:0] test_dmem_data,

    input wire [7:0]   switch_data,
    output wire [7:0]  led_data,


   // Extra trace signals
   output wire [15:0] test_dec_insn,  // Instruction at decode stage
   output wire [15:0] test_ex_insn,   // Instruction at execute stage
   output wire [15:0] test_mem_insn   // Instruction at memeory stage
  );


  // Register to store previous values for tracking
  reg [1:0] test_stall_prev;
  reg [15:0] test_cur_pc_prev;


  always @(negedge clk && (test_cur_pc != test_cur_pc_prev)) begin
	  if(!rst) begin
		  test_stall_prev <= test_stall;
		  test_cur_pc_prev <= test_cur_pc;
      $display("\nTEST_PREV: test_cur_pc=%0h test_cur_pc_prev=%0h test_stall=%0h test_stall_prev=%0h\n", test_cur_pc, test_cur_pc_prev, test_stall, test_stall_prev);
      $display("ASSERTION_SIGNALS: time=%0t i_cur_insn=%0h, i_cur_dmem_data=%0h, o_cur_pc=%0h, test_cur_pc=%0h, test_cur_insn=%0h\n", $time, i_cur_insn, i_cur_dmem_data, o_cur_pc, test_cur_pc, test_cur_insn);
	  end
  end




  //----------------------------------------------//
  // If the instruction is a load instruction (test_cur_insn[15:12] == 4'b0111), then after 4 cycles, o_dmem_we should be high.
  //----------------------------------------------//

  property load_instruction_prop_1;
      @(negedge clk) disable iff(rst) (test_cur_insn[15:12] == 4'b0110) |-> ##[3:5] (o_dmem_we == 1);
  endproperty


  LOAD_INSTRUCTION_ASSERT_1 : assert property (load_instruction_prop_1) 
    $info("LOAD_INSTRUCTION_ASSERT_1: Assertion Passed!"); 
  else 
    $error("LOAD_INSTRUCTION_ASSERT_1: Assertion failed! Load instruction detected, but o_dmem_we not asserted after 4 cycles");



  //----------------------------------------------//
  // If stall is 3, then test_cur_insn should be 0. 
  //----------------------------------------------//
  property stall_condition_prop_1;
    @(negedge clk) disable iff(rst) ##1 (test_stall == 3) |-> ##[0:0] (test_cur_insn == 16'h0000);
  endproperty


  STALL_CONDITION_ASSERT_1 : assert property (stall_condition_prop_1) 
    $info("STALL_CONDITION_ASSERT_1: Assertion Passed!");
  else 
    $error("STALL_CONDITION_ASSERT_1: Assertion failed! Stall condition detected, but test_cur_insn not 0");






  property known_value_prop(gwe, signal);
    @(posedge clk) disable iff(rst) ##1 (gwe && $fell(gwe)) |-> ##[12:15] (!$isunknown(signal));
  endproperty






  // Create assertions for each signal
  KNOWN_VALUE_O_CUR_PC: assert property (known_value_prop(gwe, o_cur_pc)) $info("KNOWN_VALUE_O_CUR_PC ASSERTION PASSED!"); else $error($sformatf("Assertion failed: o_cur_pc=%0h has unknown value",o_cur_pc));

  KNOWN_VALUE_O_DMEM_ADDR: assert property (known_value_prop(gwe, o_dmem_addr)) else $error("Assertion failed: o_dmem_addr has unknown value");
  KNOWN_VALUE_O_DMEM_WE: assert property (known_value_prop(gwe, o_dmem_we)) else $error("Assertion failed: o_dmem_we has unknown value");
  KNOWN_VALUE_O_DMEM_TOWRITE: assert property (known_value_prop(gwe, o_dmem_towrite)) else $error("Assertion failed: o_dmem_towrite has unknown value");
  KNOWN_VALUE_TEST_STALL: assert property (known_value_prop(gwe, test_stall)) else $error("Assertion failed: test_stall has unknown value");
  KNOWN_VALUE_TEST_CUR_PC: assert property (known_value_prop(gwe, test_cur_pc)) else $error("Assertion failed: test_cur_pc has unknown value");
  KNOWN_VALUE_TEST_REGFILE_WE: assert property (known_value_prop(gwe, test_regfile_we)) else $error("Assertion failed: test_regfile_we has unknown value");
  KNOWN_VALUE_TEST_REGFILE_WSEL: assert property (known_value_prop(gwe, test_regfile_wsel)) else $error("Assertion failed: test_regfile_wsel has unknown value");
  KNOWN_VALUE_TEST_REGFILE_WDATA: assert property (known_value_prop(gwe, test_regfile_data)) else $error("Assertion failed: test_regfile_wdata has unknown value");
  KNOWN_VALUE_TEST_NZP_WE: assert property (known_value_prop(gwe, test_nzp_we)) else $error("Assertion failed: test_nzp_we has unknown value");
  KNOWN_VALUE_TEST_NZP_NEW_BITS: assert property (known_value_prop(gwe, test_nzp_new_bits)) else $error("Assertion failed: test_nzp_new_bits has unknown value");
  KNOWN_VALUE_TEST_DMEM_WE: assert property (known_value_prop(gwe, test_dmem_we)) else $error("Assertion failed: test_dmem_we has unknown value");
  KNOWN_VALUE_TEST_DMEM_ADDR: assert property (known_value_prop(gwe, test_dmem_addr)) else $error("Assertion failed: test_dmem_addr has unknown value");
  KNOWN_VALUE_TEST_DMEM_DATA: assert property (known_value_prop(gwe, test_dmem_data)) else $error("Assertion failed: test_dmem_data has unknown value");




  //----------------------------------------------//
  // test for 'test_cur_pc' //
  //----------------------------------------------//
  property test_cur_pc_prop_1;
    @(negedge clk) disable iff(rst) ##1 (test_stall == 2'b10) |-> ##[0:0] (test_cur_insn == 16'h0000 && test_cur_pc == 16'h0000);
  endproperty


  property test_cur_pc_prop_2;
    @(negedge clk) disable iff (rst) ##1 (test_stall == 2'b00 && test_stall_prev == 2'b10) |-> (test_cur_pc == 16'h8200);
  endproperty



  TEST_CUR_PC_ASSERT_1: assert property(test_cur_pc_prop_1) 
    $info("test_cur_pc_prop_1: Assertions passed"); 
  else
    $error("test_cur_pc_prop_1: Assertion failed");
  
  TEST_CUR_PC_ASSERT_2: assert property(test_cur_pc_prop_2) 
    $info("test_cur_pc_prop_2: Assertions Passed"); 
  else 
    $error($sformatf("test_cur_pc_prop_2: Assertion Failed test_cur_insn=%0h test_cur_pc=%0h i_cur_dmem_data=%0h",test_cur_insn, test_cur_pc, i_cur_dmem_data));
 


  //------------------------------------------------------------------//
  // if previously no stall, then 'test_cur_pc' gets incremented by 1
  //------------------------------------------------------------------//
  always @(negedge clk) begin
    wait($rose(test_cur_pc) && (!test_stall_prev));
    assert(test_cur_pc == (test_cur_pc_prev + 1'b1)) 
      $info($sformatf("\n\nalways_assert: Assertion Passed! \ntest_stall=%0b test_cur_pc=%0h test_cur_pc_prev=%0h\n", test_stall, test_cur_pc, test_cur_pc_prev)); 
    else 
      $error($sformatf("\n\nalways_assert: Assertion Failed! \ntest_stall=%0b test_cur_pc=%0h test_cur_pc_prev=%0h\n", test_stall, test_cur_pc, test_cur_pc_prev));
  end



  //--------------------------------------------------------------------------------//
  // Previously stall, then 'test_cur_pc' gets incremented by 1 from the last value
  //--------------------------------------------------------------------------------//
  reg [15:0] stall_cur_pc;
  
  always @(negedge clk && test_stall == 2'b11) begin
    stall_cur_pc <= test_cur_pc_prev;

    $info($sformatf("time %0t STALL SIGNALS: stall_cur_pc = %0h", $time, stall_cur_pc));
    wait($fell(test_stall));
    $info($sformatf("time %0t STALL SIGNALS: stall_cur_pc = %0h", $time, stall_cur_pc));
  end



  // CUR_PC_AFTER_STALL_ASSERT : Immediate Assertion
  /*
  always @(negedge clk && (test_stall == 2'b00 && test_stall_prev == 2'b11) && (test_stall_prev!=2'b10) && (rst == 1'b0)) begin
    //$info($sformatf("cur_pc_after_stall_signals: time %0t SIGNALS: test_stall=%0h test_stall_prev=%0h test_cur_pc=%0h test_cur_pc_prev=%0h stall_cur_pc = %0h", $time, test_stall, test_stall_prev, test_cur_pc, test_cur_pc_prev, stall_cur_pc));
    assert(test_cur_pc == (stall_cur_pc + 1'b1))
      $info($sformatf("\n\nCUR_PC_AFTER_STALL_ASSERT: Assertion Passed! \ntest_stall=%0b test_cur_pc=%0h stall_cur_pc=%0h test_cur_pc_prev=%0h\n", test_stall, test_cur_pc, stall_cur_pc, test_cur_pc_prev));
    else
      $error($sformatf("\n\nCUR_PC_AFTER_STALL_ASSERT: Assertion Failed! \ntest_stall=%0b test_cur_pc=%0h stall_cur_pc=%0h test_cur_pc_prev=%0h\n", test_stall, test_cur_pc, stall_cur_pc, test_cur_pc_prev));
  end
  */



  // CUR_PC_AFTER_STALL_ASSERT : Concurrent Assertion
  property cur_pc_after_stall_assert;
    @(negedge clk) disable iff(rst) 
    if( (test_stall == 2'b00) && (test_stall_prev == 2'b11) && (test_stall_prev!=2'b10))
      test_cur_pc == (stall_cur_pc + 1'b1);

  endproperty


  // Assertion instantiation
  CUR_PC_AFTER_STALL_ASSERT: assert property(cur_pc_after_stall_assert)
    //$info(), $warning(), $error()
      $info($sformatf("\n\nCUR_PC_AFTER_STALL_ASSERT: Assertion Passed! \ntest_stall=%0b test_cur_pc=%0h stall_cur_pc=%0h test_cur_pc_prev=%0h\n", test_stall, test_cur_pc, stall_cur_pc, test_cur_pc_prev));
  else 
      $error($sformatf("\n\nCUR_PC_AFTER_STALL_ASSERT: Assertion Failed! \ntest_stall=%0b test_cur_pc=%0h stall_cur_pc=%0h test_cur_pc_prev=%0h\n", test_stall, test_cur_pc, stall_cur_pc, test_cur_pc_prev));



  //--------------------------------------------------------------------------------//
  // Checking out the o_dmem_we -> 1'b1 when next instruction is STORE
  //--------------------------------------------------------------------------------//
  property o_dmem_we_assert;
	  @(negedge clk) disable iff(rst)
	    if(test_mem_insn[15:12] == 4'b0111)
		    (o_dmem_we == 1'b1)
      else 
        o_dmem_we == 1'b0;
  endproperty
  

  // Assertion instantiation
  O_DMEM_WE_ASSERT: assert property(o_dmem_we_assert)
      $info($sformatf("\n\nO_DMEM_WE_ASSERT: Assertion Passed! \no_dmem_we=%0b test_cur_insn=%0h test_mem_insn=%0h\n", o_dmem_we, test_cur_insn, test_mem_insn));
  else 
      $error($sformatf("\n\nO_DMEM_WE_ASSERT: Assertion Failed! \no_dmem_we=%0b test_cur_insn=%0h test_mem_insn=%0h\n", o_dmem_we, test_cur_insn,test_mem_insn));


  //--------------------------------------------------------------------------------//
  // For load/store instructions check test_regfile_wsel
  //--------------------------------------------------------------------------------//
  property regfile_wsel_prop;
	  @(negedge clk) disable iff(rst)
		 	if((test_cur_insn[15:12]==4'b0111) || (test_cur_insn[15:12]==4'b0110))
			  (test_regfile_wsel == test_cur_insn[11:9])
      else 
        (test_regfile_wsel == 0);
  endproperty


  // Assertion instantiation
  REGFILE_WSEL_ASSERT: assert property(regfile_wsel_prop)
      $info($sformatf("\n\nREGFILE_WSEL_ASSERT: Assertion Passed! \ntest_regfile_wsel=%0b test_cur_insn=%0h\n", test_regfile_wsel, test_cur_insn));
  else 
      $error($sformatf("\n\nREGFILE_WSEL_ASSERT: Assertion Failed! \ntest_regfile_wsel=%0b test_cur_insn=%0h\n", test_regfile_wsel, test_cur_insn));



  //--------------------------------------------------------------------------------//
  // NOP Pipeline verification
  //--------------------------------------------------------------------------------//
  property nop_pipeline_logic_prop;
  @(negedge clk) disable iff(rst)
  if((test_ex_insn[15:12] == 4'b0110) && (test_ex_insn[11:9] == test_dec_insn[8:6]) || ((test_ex_insn[11:9] == test_dec_insn[11:9]) 
    && (test_dec_insn[15:12] != 4'b0111)))
		   ##[4:4] (test_ex_insn == 16'h0) ##[4:4] (test_mem_insn == 16'h0) ##[4:4] (test_cur_insn==16'h0);
  endproperty



  // Assertion instantiation
  NOP_PIPELINE_LOGIC_ASSERT: assert property(nop_pipeline_logic_prop)
      $info($sformatf("\n\nNOP_PIPELINE_LOGIC_ASSERT: Assertion Passed! \ntest_stall=%0b test_dec_insn=%0h test_ex_insn=%0h test_mem_insn=%0h test_cur_insn=%0h\n", test_stall, test_dec_insn, test_ex_insn, test_mem_insn, test_cur_insn));
  else 
      $error($sformatf("\n\nNOP_PIPELINE_LOGIC_ASSERT: Assertion Failed! \ntest_stall=%0b test_dec_insn=%0h test_ex_insn=%0h test_mem_insn=%0h test_cur_insn=%0h\n", test_stall, test_dec_insn, test_ex_insn, test_mem_insn, test_cur_insn));


  //--------------------------------------------------------------------------------//
  // Implementing stall logic working well, need to give correct logic
  //--------------------------------------------------------------------------------//
  property test_stall_logic_prop;
    @(negedge clk) disable iff(rst) 
    if((test_ex_insn[15:12] == 4'b0110) && (test_ex_insn[11:9] == test_dec_insn[8:6]) || ((test_ex_insn[11:9] == test_dec_insn[11:9]) 
    && (test_dec_insn[15:12] != 4'b0111)))
		   ##[12:12] (test_stall == 2'b11);
  endproperty



  // Assertion instantiation
  TEST_STALL_LOGIC_ASSERT: assert property(test_stall_logic_prop)
      $info($sformatf("\n\nTEST_STALL_LOGIC_ASSERT: Assertion Passed! \ntest_stall=%0b test_cur_insn=%0h test_ex_insn=%0h\n", test_stall, test_cur_insn, test_ex_insn));
  else 
      $error($sformatf("\n\nTEST_STALL_LOGIC_ASSERT: Assertion Failed! \ntest_stall=%0b test_cur_insn=%0h test_ex_insn=%0h\n", test_stall, test_cur_insn,test_ex_insn));

  logic [15:0] test_dec_insn_prev;
  logic [15:0] test_ex_insn_prev;
  logic [15:0] test_mem_insn_prev;
  logic [15:0] test_cur_insn_prev;

  always @(negedge gwe) begin
	  if(!rst) begin
		  test_dec_insn_prev <= test_dec_insn;
		  test_ex_insn_prev <= test_ex_insn;
		  test_mem_insn_prev <= test_mem_insn;
		  test_cur_insn_prev <= test_cur_insn;
      $info("\n\nFOUR_INSN_SIGNALS\n");
      $info($sformatf("\n\nINSN_SIGNALS: \ntest_dec_insn=%0h test_dec_insn_prev=%0h\n", test_dec_insn, test_dec_insn_prev));
      $info($sformatf("\n\nINSN_SIGNALS: \ntest_ex_insn=%0h test_ex_insn_prev=%0h\n", test_ex_insn, test_ex_insn_prev));
      $info($sformatf("\n\nINSN_SIGNALS: \ntest_mem_insn=%0h test_mem_insn_prev=%0h\n", test_mem_insn, test_mem_insn_prev));
      $info($sformatf("\n\nINSN_SIGNALS: \ntest_cur_insn=%0h test_cur_insn_prev=%0h\n", test_cur_insn, test_cur_insn_prev));
	  end
  end




  //--------------------------------------------------------------------------------//
  // Pipelined Stages Verification
  //--------------------------------------------------------------------------------//
  /*
  property _logic_prop;
    @(negedge clk) disable iff(rst)
    if($fell(gwe) && (!$isunknown(i_cur_insn))) 
	    ##[0:0] (test_dec_insn == i_cur_insn)
	    ##[4:4] (test_ex_insn == test_dec_insn_prev) 
	    ##[4:4] (test_mem_insn == test_mem_insn_prev) 
	    ##[4:4] (test_cur_insn==test_cur_insn_prev);
  endproperty
  */

  property pipeline_logic_prop(signal, signal_prev);
    @(negedge clk) disable iff(rst)
      if($fell(gwe) && (!$isunknown(signal))) 
        (signal == signal_prev);
  endproperty



  EX_STAGE_ASSERT: assert property (pipeline_logic_prop(test_ex_insn, test_dec_insn_prev)) 
    $info($sformatf("\n\nEX_STAGE_ASSERT Passed! test_ex_insn=%0h test_dec_insn_prev=%0h\n", test_ex_insn, test_dec_insn_prev));
  else 
    $error($sformatf("\n\nEX_STAGE_ASSERT Failed! test_ex_insn=%0h test_dec_insn_prev=%0h\n", test_ex_insn, test_dec_insn_prev));
  
  MEM_STAGE_ASSERT: assert property (pipeline_logic_prop(test_mem_insn, test_ex_insn_prev)) 
    $info($sformatf("\n\nMEM_STAGE_ASSERT Passed! test_mem_insn=%0h test_ex_insn_prev=%0h\n", test_mem_insn, test_ex_insn_prev));
  else 
    $error($sformatf("\n\nMEM_STAGE_ASSERT Failed! test_mem_insn=%0h test_ex_insn_prev=%0h\n", test_mem_insn, test_ex_insn_prev));

  WB_STAGE_ASSERT: assert property (pipeline_logic_prop(test_cur_insn, test_mem_insn_prev)) 
    $info($sformatf("\n\nWB_STAGE_ASSERT Passed! test_cur_insn=%0h test_mem_insn_prev=%0h\n", test_cur_insn, test_mem_insn_prev));
  else 
    $error($sformatf("\n\nWB_STAGE_ASSERT Failed! test_cur_insn=%0h test_mem_insn_prev=%0h\n", test_cur_insn, test_mem_insn_prev));

endmodule

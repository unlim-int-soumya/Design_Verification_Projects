`define TB_ADDR_WIDTH 10
//`define TB_ADDR_WIDTH $clog2(TB_MEM_DEPTH)
`define TB_DATA_WIDTH 32
`define TB_MEM_WIDTH 32
`define TB_MEM_DEPTH 1024

`define bfm_vif bfm_vif.bfm_mp.bfm_cb
`define mon_vif mon_vif.mon_mp.mon_cb

class apb_common;
  static int num_tx = 1;
  static int num_beats;
  static int num_agents = 3;
  static mailbox gen2bfm[];
  
  static virtual apb_intf vif;
  static int tx_driven_count = 0;
  static semaphore smp = new(1);
  
  static mailbox mon2scb = new();
  
  static int compare_count;
  
  static mailbox mon2cov = new();
  static int cov_count;
  
  static string testname;
  
  function new();
    //Sampling testname from command line
    if(!$value$plusargs("testname=%s",testname)) begin
      $fatal("Top: No Testname ");
    end
    $display("testname=%s",testname);
    
    gen2bfm = new[num_agents];
    foreach (gen2bfm[i]) begin
       gen2bfm[i] = new();
    end

    //number of transfer in each transaction
    case(testname)
      "test_wr_rd" : num_beats = 2;
      "test_wr"    : num_beats = 1;
      "test_rd"    : num_beats = 1;
    endcase
    
  endfunction
  
endclass

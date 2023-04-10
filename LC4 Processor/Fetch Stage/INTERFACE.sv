
interface intif(input bit clk);

  
  logic reg_we, gwe, rst;
  logic [15:0] next_pc;
  logic [15:0] pc;
  logic [1:0] test_stall_f;


  //Lighthouse
  
  modport dut(input clk,
              rst,
              gwe,
              reg_we,
              next_pc,
              
              output 
              pc,
              test_stall_f
             );
  
endinterface



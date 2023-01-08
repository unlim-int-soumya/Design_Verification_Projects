`include "design.sv"

`include "apb_pkg.sv"
//import apb_pkg::*;
`include "apb_intf.sv"
`include "apb_base_test.sv"

`include "binding.sv"

module top;
  apb_common common = new();

  reg pclk;
  reg presetn;
  
  initial begin
    pclk=0;
    forever #5 pclk=~pclk;
  end
  
  initial begin
    presetn=0;
    reset_design_inputs();
    repeat(2) @(posedge pclk);
    presetn=1;
  end
  
  function void reset_design_inputs();
    intf.pwdata = 0;
    intf.paddr = 0;
    intf.pselx = 0;
    intf.penable = 0;
    intf.pwrite = 0;
  endfunction
  
  apb_intf intf(pclk,presetn);

  apb_slave dut(
    .pclk(intf.pclk),
    .presetn(intf.presetn),
    .pwdata(intf.pwdata),
    .paddr(intf.paddr),
    .pselx(intf.pselx),
    .penable(intf.penable),
    .pwrite(intf.pwrite),
    .prdata(intf.prdata),
    .pready(intf.pready),
    .pslverr(intf.pslverr)
  );

  apb_base_test base_test();

  initial begin
    
    apb_common::vif = intf;
    //wait(apb_common::tx_driven_count == 1 * apb_common::num_agents * apb_common::num_tx);
    wait(apb_common::tx_driven_count == apb_common::num_beats * apb_common::num_agents * apb_common::num_tx);
    #50;
    $finish;
  end
  
endmodule

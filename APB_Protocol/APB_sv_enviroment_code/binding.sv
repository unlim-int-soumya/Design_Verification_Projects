`include "assertion.sv"

module binding;

  bind apb_slave assertion dut(
    .clk(pclk),
    .resetn(presetn),
    .wdata(pwdata),
    .addr(paddr),
    .selx(pselx),
    .enable(penable),
    .write(pwrite),
    .rdata(prdata),
    .ready(pready),
    .slverr(pslverr)
  ); 
  
endmodule

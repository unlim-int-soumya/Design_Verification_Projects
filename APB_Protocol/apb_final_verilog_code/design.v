`include "apb_master.v"
`include "apb_slave.v"

`define ADDR_WIDTH 10
`define DATA_WIDTH 32

module apb_master_slave(
    apb_clk,
    apb_resetn,
    apb_wdata,
    apb_addr,
    apb_wr_rd,
    apb_rdata
  );

  input apb_clk;
  input apb_resetn;
  input [`DATA_WIDTH-1:0]apb_wdata;
  input [`ADDR_WIDTH-1:0]apb_addr;
  input apb_wr_rd;
  output [`DATA_WIDTH-1:0]apb_rdata;

  wire pready_w;
  wire [`DATA_WIDTH-1:0]pwdata_w;
  wire [`ADDR_WIDTH-1:0]paddr_w;
  wire pselx_w;
  wire penable_w;
  wire pwrite_w;
  wire pslverr_w;
  wire [`DATA_WIDTH-1:0]prdata_w;

  apb_master master(
    .clk(apb_clk),
    .resetn(apb_resetn),
    .wdata(apb_wdata),
    .addr(apb_addr),
    .wr_rd(apb_wr_rd),
    .pready(pready_w),
    .prdata(prdata_w),
    .pslverr(pslverr_w),
    .pwdata(pwdata_w),
    .paddr(paddr_w),
    .pselx(pselx_w),
    .penable(penable_w),
    .pwrite(pwrite_w),
    .apb_rdata(apb_rdata)
  );

  apb_slave slave(
    .pclk(apb_clk),
    .presetn(apb_resetn),
    .pwdata(pwdata_w),
    .paddr(paddr_w),
    .pselx(pselx_w),
    .penable(penable_w),
    .pwrite(pwrite_w),
    .prdata(prdata_w),
    .pready(pready_w),
    .pslverr(pslverr_w)
  );

endmodule

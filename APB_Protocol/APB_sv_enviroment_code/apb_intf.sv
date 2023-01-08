interface apb_intf(input logic pclk,presetn);
  logic [`TB_DATA_WIDTH-1:0]pwdata;
  logic [`TB_ADDR_WIDTH-1:0]paddr;
  logic pselx;
  logic penable;
  logic pwrite;
  logic [`TB_DATA_WIDTH-1:0]prdata;
  logic pready;
  logic pslverr;

  clocking bfm_cb @(posedge pclk);
    output pwdata;
    output paddr;
    output pselx;
    output penable;
    output pwrite;
    input  prdata;
    input  pready;
    input  pslverr;
  endclocking

  clocking mon_cb @(posedge pclk);
    input pwdata;
    input paddr;
    input pselx;
    input penable;
    input pwrite;
    input prdata;
    input pready;
    input pslverr;
  endclocking

  modport bfm_mp (clocking bfm_cb);
  modport mon_mp (clocking mon_cb);

endinterface

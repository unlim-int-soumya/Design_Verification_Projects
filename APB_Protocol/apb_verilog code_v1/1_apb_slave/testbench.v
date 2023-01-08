`include "design.v"

//`define ADDR_WIDTH 12
`define ADDR_WIDTH 10
`define DATA_WIDTH 32

module top;
  reg pclk;
  reg presetn;
  reg [`DATA_WIDTH-1:0]pwdata;
  reg [`ADDR_WIDTH-1:0]paddr;
  reg pselx;
  reg penable;
  reg pwrite;

  wire [`DATA_WIDTH-1:0]prdata;
  wire pready;
  wire pslverr;

  integer data;
  integer addr;

  apb_slave dut(
    pclk,
    presetn,
    pwdata,
    paddr,
    pselx,
    penable,
    pwrite,
    prdata,
    pready,
    pslverr
  );

  initial begin  
    pclk=0;
    forever #5 pclk=~pclk;
  end

  initial begin
    presetn=0;
    task_rst();
    @(posedge pclk);
    presetn=1;
  end

  task task_rst;
    begin
      pwdata=0;
      paddr=0;
      pselx=0;
      penable=0;
    end
  endtask

  initial begin
    repeat(5) begin

      data=$random;
      addr=$urandom_range(0,(2**(`ADDR_WIDTH)));
      // idle
      @(posedge pclk);
      pselx=0;
      penable=0;
      @(posedge pclk);

      // setup
      pselx=1;
      penable=0;
      paddr=addr;
      pwdata=data;
      pwrite=1; 
      @(posedge pclk);

      // access
      pselx=1;
      penable=1;
      @(pready);
      @(posedge pclk);
      task_rst();

      @(posedge pclk);
      // setup
      pselx=1;
      penable=0;
      paddr=addr;
      pwrite=0; 
      @(posedge pclk);

      // access
      pselx=1;
      penable=1;
      @(pready);
      @(posedge pclk);
      task_rst();

    end

    #20;
    $finish;
  end

endmodule

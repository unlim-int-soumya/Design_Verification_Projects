`include "design.v"

//`define ADDR_WIDTH 12
`define ADDR_WIDTH 10
`define DATA_WIDTH 32

module top;
  reg clk;
  reg resetn;
  reg [`DATA_WIDTH-1:0]wdata;
  reg [`ADDR_WIDTH-1:0]addr;
  reg wr_rd;
  reg pready;

  wire [`DATA_WIDTH-1:0]pwdata;
  wire [`ADDR_WIDTH-1:0]paddr;
  wire pselx;
  wire penable;
  wire pwrite;

  apb_master dut(
    clk,
    resetn,
    wdata,
    addr,
    wr_rd,
    pready,
    pwdata,
    paddr,
    pselx,
    penable,
    pwrite
  ); 

  initial begin  
    clk=0;
    forever #5 clk=~clk;
  end

  initial begin
    resetn=0;
    task_rst();
    @(posedge clk);
    resetn=1;
  end

  task task_rst;
    begin
      wdata=0;
      addr=0;
      wr_rd='bx;
      pready=0;
    end
  endtask

  initial begin
    @(posedge clk);
    repeat(5) begin
      task_write();
      repeat(3) @(posedge clk);
      task_read();
      repeat(3) @(posedge clk);
    end 
    #20;
    $finish;
  end

  task task_write;
    begin
      wdata=$random;
      addr='b001;
      wr_rd=1;
      //pready=0;
      pready=1;
    end
  endtask

  task task_read;
    begin
      addr='b001;
      wr_rd=0;
      pready=1;
    end
  endtask
  
endmodule

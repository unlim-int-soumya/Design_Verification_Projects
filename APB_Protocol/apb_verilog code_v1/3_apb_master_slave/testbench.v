`include "design.v"

//`define ADDR_WIDTH 12
`define ADDR_WIDTH 10
`define DATA_WIDTH 32
`define START_ADDR 0
`define END_ADDR 5

//`define START_ADDR 4000
//`define END_ADDR 4005

module top;

  reg apb_clk;
  reg apb_resetn;
  reg [`DATA_WIDTH-1:0]apb_wdata;
  reg [`ADDR_WIDTH-1:0]apb_addr;
  reg apb_wr_rd;

  wire [`DATA_WIDTH-1:0]apb_rdata;
  wire apb_slverr; 

  integer i=0;
  reg [30*8:1] testname;

  parameter S_ADDR=`START_ADDR;
  parameter E_ADDR= `END_ADDR;

  apb_master_slave dut(
    apb_clk,
    apb_resetn,
    apb_wdata,
    apb_addr,
    apb_wr_rd,
    apb_rdata,
    apb_slverr
  );

  initial begin  
    apb_clk=0;
    forever #5 apb_clk=~apb_clk;
  end

  initial begin
    apb_resetn=0;
    task_rst();
    @(posedge apb_clk);
    apb_resetn=1;
  end

  task task_rst;
    begin
      apb_wdata=0;
      apb_addr=0;
      apb_wr_rd='bx;
    end
  endtask

  initial begin
    @(posedge apb_clk);
    $value$plusargs("testname=%s",testname);
    case(testname)
      "wr_rd":begin
        task_write(S_ADDR,E_ADDR);
        task_read(S_ADDR,E_ADDR);
      end 
      "wr_followed_by_rd":begin
        task_wr_followed_rd(S_ADDR,E_ADDR);
      end
      "write":begin
        task_write(S_ADDR,E_ADDR);
      end
      "read":begin
        task_read(S_ADDR,E_ADDR);
      end
    endcase
    #20;
    $finish;
  end

  task task_write(input integer s_addr,input integer e_addr);
    begin
      for(i=s_addr;i<e_addr;i=i+1) begin
        @(posedge apb_clk);
        apb_wdata=$random;
        apb_addr=i;
        apb_wr_rd=1;
        repeat(3) @(posedge apb_clk);
      end
    end
  endtask

  task task_read(input integer s_addr,input integer e_addr);
    begin
      for(i=s_addr;i<e_addr;i=i+1) begin
        @(posedge apb_clk);
        apb_addr=i;
        apb_wr_rd=0;
        repeat(3) @(posedge apb_clk);
      end
    end
  endtask

  task task_wr_followed_rd(input integer s_addr,input integer e_addr);
    begin
      for(i=s_addr;i<e_addr;i=i+1) begin
        @(posedge apb_clk);
        apb_wdata=$random;
        apb_addr=i;
        apb_wr_rd=1;
        repeat(3) @(posedge apb_clk);
        @(posedge apb_clk);
        apb_addr=i;
        apb_wr_rd=0;
        repeat(3) @(posedge apb_clk);
      end
    end
  endtask
endmodule

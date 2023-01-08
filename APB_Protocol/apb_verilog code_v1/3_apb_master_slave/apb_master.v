//`define ADDR_WIDTH 12
`define ADDR_WIDTH 10
`define DATA_WIDTH 32

module apb_master(
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

  input clk;
  input resetn;
  input [`DATA_WIDTH-1:0]wdata;
  input [`ADDR_WIDTH-1:0]addr;
  input wr_rd;

  input pready;

  output reg [`DATA_WIDTH-1:0]pwdata;
  output reg [`ADDR_WIDTH-1:0]paddr;
  output reg pselx;
  output reg penable;
  output reg pwrite;

  reg [1:0] present_state;
  reg [1:0] next_state;

  parameter idle=2'b00;
  parameter setup=2'b01;
  parameter access=2'b10;

  always@(posedge clk or negedge resetn) begin
    if(!resetn)begin
      present_state<=idle;
      next_state=idle;
    end
    else begin
      present_state<=next_state;
    end
  end

  always@(*)begin
    case(present_state)
      idle:begin
        if(!resetn)begin
          pwdata<=0;
          paddr<=0;
          pselx<=0;
          penable<=0;
          pwrite<=0;
          next_state=idle;
        end
        else begin
          pselx=0;
          penable=0;
          next_state=setup;
        end
      end
      setup:begin
        pselx=1;
        penable=0;
        paddr=addr;
        pwdata=wdata;
        pwrite=wr_rd; 
        next_state=access;
      end
      access:begin
        pselx=1;
        penable=1;
        if(pready) begin
          next_state=idle;
        end
        else if(!pready) begin
          next_state=access;
        end
        else begin
          next_state=idle;
        end
      end
      default:begin
        next_state=idle;
      end
    endcase
  end

endmodule

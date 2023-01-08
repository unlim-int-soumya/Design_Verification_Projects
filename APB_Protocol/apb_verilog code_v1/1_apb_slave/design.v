//`define ADDR_WIDTH 12
`define ADDR_WIDTH 10
//`define ADDR_WIDTH $clog2(TB_MEM_DEPTH)
`define DATA_WIDTH 32
`define MEM_WIDTH 32
`define MEM_DEPTH 1024

module apb_slave(
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
  input pclk;
  input presetn;
  input [`DATA_WIDTH-1:0]pwdata;
  input [`ADDR_WIDTH-1:0]paddr;
  input pselx;
  input penable;
  input pwrite;
  output reg [`DATA_WIDTH-1:0]prdata;
  output reg pready;
  output reg pslverr;

  reg [`MEM_WIDTH-1:0]mem[`MEM_DEPTH-1:0];

  reg [1:0] present_state;
  reg [1:0] next_state;

  parameter idle=2'b00;
  parameter setup=2'b01;
  parameter access=2'b10;

  integer i;

  always@(posedge pclk or negedge presetn) begin
    if(!presetn)begin
      for(i=0;(i<`MEM_DEPTH);i=i+1) begin
        mem[i]='h0;
      end
      present_state<=idle;
      next_state=idle;
    end
    else begin
      present_state<=next_state;
    end
  end

  always@(presetn,present_state,pselx,penable,pwrite)begin
    case(present_state)
      idle:begin
        pready=0;
        pslverr=0;
        if(!presetn) begin
          prdata=0;
          pslverr=0;
        end
        else if((!pselx)&&(!penable)) begin
          next_state=idle;
        end
        else if((pselx)&&(!penable)) begin
          next_state=setup;
        end
      end
      setup:begin
        pready=0;
        pslverr=0;
        next_state=access;
      end
      access:begin
        pready=1;
        if((pselx)&&(penable)) begin
          if(pwrite) begin
            mem[paddr]=pwdata;
          end
          else if(!pwrite) begin
            prdata=mem[paddr];
          end

          if((paddr>=0)&&(paddr<`MEM_DEPTH))begin
            pslverr=0;
          end
          else begin
            pslverr=1;
          end

          next_state=access;
        end
        else if((pselx)&&(!penable))begin
          pready=0;
          pslverr=0;
          next_state=setup;
        end
        else if((!pselx)&&(!penable))begin
          pready=0;
          pslverr=0;
          next_state=idle;
        end    
      end
      default:begin
        next_state=idle;
      end
    endcase
  end

endmodule

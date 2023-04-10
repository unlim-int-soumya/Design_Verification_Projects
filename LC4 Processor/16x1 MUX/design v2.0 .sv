`ifndef IN_LENGTH
`define IN_LENGTH 16
`endif

`ifndef SEL_LENGTH
`define SEL_LENGTH 4
`endif

module mux_16x1(
  input [`SEL_LENGTH-1:0] sel, 
  input [`IN_LENGTH-1:0]in,
  input rstn,
  output reg out
);
  
  always @ (*) begin
    if(!rstn) begin
      out = 0;
    end else begin
      out = ((~sel[3])&(~sel[2])&(~sel[1])&(~sel[0]) |
             (~sel[3])&(~sel[2])&(~sel[1])&(sel[0]) |
             (~sel[3])&(~sel[2])&(sel[1])&(~sel[0]) |
             (~sel[3])&(~sel[2])&(sel[1])&(sel[0]) |
      
             (~sel[3])&(sel[2])&(~sel[1])&(~sel[0]) |
             (~sel[3])&(sel[2])&(~sel[1])&(sel[0]) |
             (~sel[3])&(sel[2])&(sel[1])&(~sel[0]) |
             (~sel[3])&(sel[2])&(sel[1])&(sel[0]) |
      
             (sel[3])&(~sel[2])&(~sel[1])&(~sel[0]) |
             (sel[3])&(~sel[2])&(~sel[1])&(sel[0]) |
             (sel[3])&(~sel[2])&(sel[1])&(~sel[0]) |
             (sel[3])&(~sel[2])&(sel[1])&(sel[0]) |
      
             (sel[3])&(sel[2])&(~sel[1])&(~sel[0]) |
             (sel[3])&(sel[2])&(~sel[1])&(sel[0]) |
             (sel[3])&(sel[2])&(sel[1])&(~sel[0]) |
             (sel[3])&(sel[2])&(sel[1])&(sel[0])) & in;
 	 
    end
  end

endmodule

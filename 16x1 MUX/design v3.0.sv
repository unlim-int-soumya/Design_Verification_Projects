//`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SELF
// Engineer: Soumya Dash
// 
// Create Date: 01/02/2023 08:59:07 PM
// Design Name: 16x1 MUX
// Module Name: abc
// Project Name: 16x1 MUX
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`ifndef IN_LENGTH
`define IN_LENGTH 16
`endif

`ifndef SEL_LENGTH
`define SEL_LENGTH 4
`endif

module adder(
  input [`SEL_LENGTH-1:0] sel, 
  input [`IN_LENGTH-1:0]in,
  input rstn,
  output reg out
    );
  always @ (*) begin
    if(!rstn) begin
      out = 0;
    end else begin
        out = sel[3] ? (sel[2]? (sel[1]? (sel[0]? in[15]: in[14]):(sel[0]? in[13]: in[12])):
        (sel[1]?(sel[0]? (in[11]):(in[10])):(sel[0]? (in[9]):(in[8]))))
        :(
        sel[2]? (sel[1]? (sel[0]? in[7]: in[6]):(sel[0]? in[5]: in[4])):
        (sel[1]?(sel[0]? (in[3]):(in[2])):(sel[0]? (in[1]):(in[0])))
        ); 	 
    end
  end
endmodule

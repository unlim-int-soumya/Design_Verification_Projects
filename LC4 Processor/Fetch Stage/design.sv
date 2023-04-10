`include "IF_stage.v"


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2023 12:56:06 AM
// Design Name: 
// Module Name: IF
// Project Name: 
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

`default_nettype none
module IF(
  input wire reg_we, gwe, rst, clk,
  input wire [15:0] next_pc, 
  output wire [15:0] pc, 
  output wire [1:0] test_stall_f
);

  fetch_stage #(
    .width_pc_reg(16),
    .rst_pc_reg(16'h8200),
    .width_stall_f(2),
    .rst_stall_f(2'd0)
  )f_stage (
    .we(reg_we),
    .gwe(gwe),
    .rst(rst),
    .clk(clk),
    .in_pc_reg(next_pc),
    .out_pc_reg(pc),
    .in_stall_f(2'd0),
    .out_stall_f(test_stall_f)
  );

endmodule

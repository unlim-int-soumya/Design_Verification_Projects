/* TODO: INSERT NAME AND PENNKEY HERE */

`timescale 1ns / 1ps
`default_nettype none

/**
 * @param a first 1-bit input
 * @param b second 1-bit input
 * @param g whether a and b generate a carry
 * @param p whether a and b would propagate an incoming carry
 */

/*
module gp1(input wire a, b,
           output wire g, p);
   assign g = a & b;
   assign p = a | b;
endmodule

*/


/**
 * Computes aggregate generate/propagate signals over a 4-bit window.
 * @param gin incoming generate signals 
 * @param pin incoming propagate signals
 * @param cin the incoming carry
 * @param gout whether these 4 bits collectively generate a carry (ignoring cin)
 * @param pout whether these 4 bits collectively would propagate an incoming carry (ignoring cin)
 * @param cout the carry outs for the low-order 3 bits
 */
module gp4(input wire [3:0] gin, pin,
           input wire cin,
           output wire gout, pout,
           output wire [3:0] cout);
  
  //wire test;
  
  assign cout[0] = gin[0] | (pin[0] & cin);
  assign cout[1] = gin[1] | (pin[1] & cout[0]);
  assign cout[2] = gin[2] | (pin[2] & cout[1]);
  
  assign gout = (gin >=4'b1000)? 1'b1: ( (pin>=4'b1000 && gin >=4'b0100) | (pin>=4'b1100 && gin >=4'b0010) | (pin>=4'b1110 && gin >=4'b0001) ? 1'b1: 1'b0);
  assign pout = & pin;
  
  assign cout[3] = gout | (pout & cout[2]);
  
endmodule
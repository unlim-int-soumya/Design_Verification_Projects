interface sfr_if(input logic clk, reset_n);
  
  logic rw;
  logic [7:0] address_in;
  logic [7:0] data_in;
  logic [7:0] data_out;
  
endinterface
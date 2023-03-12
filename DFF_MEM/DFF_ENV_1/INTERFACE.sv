
interface intif(input bit clk);

  //rdata = data_out
  //wdata = data_in
  //addr = address_in
  logic [7:0] address_in, data_in;

  logic rw;
  logic reset;
  
  logic [7:0] data_out;

  //Lighthouse
  
  modport dut(input clk,
              reset,
              rw,
              data_in,
              address_in,
              
              output 
              data_out);
  
endinterface



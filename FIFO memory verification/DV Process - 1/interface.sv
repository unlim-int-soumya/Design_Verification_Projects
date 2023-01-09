/***********************************************
* interface 
***********************************************/
interface dut_if;
    logic clock, reset, put, get, full_bar, empty_bar;
    logic [15:0] data_in;
    logic [15:0] data_out;
endinterface : dut_if
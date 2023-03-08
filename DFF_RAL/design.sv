module dff_with_memory(
  input clk, // clock signal
  input reset, // reset signal
  input rw, // control signal: 0 for read, 1 for write
  input [7:0] address_in, // input address to read from or write to
  input [7:0] data_in, // input data to be written
  output wire [7:0] data_out // output data from memory
);

reg [7:0] memory [0:255]; // memory element with 256 8-bit locations

  reg [7:0] dff_out; // output of the DFF

  
always @(posedge clk) begin
  if (!reset) begin
    dff_out <= 1'b0; // reset the DFF
  end else begin
    
    if (rw) begin // write operation
      
      //s1 will execute first, after this value would be stored in memory
      dff_out = data_in; // store the input data in the DFF
      memory[address_in] <= dff_out; // store the output of the DFF in memory
    end else begin // read operation
     
      dff_out <= memory[address_in+1]; // read data from memory into the DFF
    end
    
  end
end

// read the stored value from memory whenever data_out is requested
assign data_out = dff_out;

endmodule

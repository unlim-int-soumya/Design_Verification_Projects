module adder(
  input a, 
  input b, 
  input cin,
  input rstn,
  output reg sum, 
  output reg cout
);
  
  always @ (*) begin
    if(!rstn) begin
  		sum = 0;
      	cout = 0;
    end else begin
      {cout, sum} = a + b + cin;
      //{cout, sum} = a + b;
 	 end
  end

endmodule


/*
module adder(
  input rstn, 
  input a, 
  input b, 
  input cin,
  output reg sum, 
  output reg cout
);
  
  always @ (*) begin
        if(!rstn) begin
          sum = 0;
          cout = 0;
          end
        else begin
          sum = (a ^ b) ^ cin;
          //sum = 1;
          //cout = 1;
          cout = ((a ^ b) & cin) | (a & b);
        end
  end

endmodule
*/
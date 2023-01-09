module fifo_memory(
	input clk,
	input rstn,
	input enq,
	input deq,
	input [7:0] din,
	output reg [7:0] dout,
	output reg full,
	output reg empty
);

parameter DEPTH = 16;
parameter WIDTH = 8;

reg [7:0] mem [0:DEPTH-1];
reg [3:0] wr_ptr;		// used for writing
  reg [3:0] rd_ptr;		//Used for reading


always @ (posedge clk) begin
  if(rstn) begin
		wr_ptr <= 0;
		rd_ptr <= 0;
	end else begin
		if(enq) begin
			mem[wr_ptr] <= din;
			wr_ptr <= (wr_ptr == DEPTH-1)? 0 : wr_ptr + 1;	//If FIFO full then just reset the wr_ptr to 1
		end
		else if(deq) begin
			dout <= mem[rd_ptr];
			rd_ptr <= (rd_ptr == DEPTH-1)? 0 : rd_ptr + 1;
		end
	end
end

  /*
  always @ (*) begin
    if((wr_ptr == rd_ptr) && enq)
      full = 1'b1;
    else if((wr_ptr == rd_ptr) && !enq)
      empty = 1'b1;
  end
  */
  assign full = (wr_ptr == rd_ptr) && enq;
  assign empty = (wr_ptr == rd_ptr) && (!enq);
  
endmodule
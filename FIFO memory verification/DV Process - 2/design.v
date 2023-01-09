module fifo_memory(
	input clk,
	input rst,
	input enq,
	input deq,
	input [7:0] din,
	output [7:0] dout,
	output full,
	output empty
);

parameter DEPTH = 16;
parameter WIDTH = 8;

reg [7:0] mem [0:DEPTH-1];
reg [3:0] wr_ptr;		// used for writing
reg [3:)] rd_ptr;		//Used for reading


always @ (posedge clk) begin
	if(rst) begin
		wr_ptr <= 0;
		rd_ptr <= 0;
	end else begin
		if(enq) begin
			mem[wr_ptr] <= din;
			wr_ptr <= (wr_ptr == DEPTH-1)? 0 : wr_ptr + 1;	//If FIFO full then just reset the wr_ptr to 1
		end
		if(deq) begin
			dout <= mem[rd_ptr];
			rd_ptr <= (rd_ptr == DEPTH-1)? 0 : rd_ptr + 1;
		end
	end
end

assign full = (wr_ptr == rd_ptr) && enq;
assign empty = (wr_ptr == rd_ptr) && !enq;

endmodule
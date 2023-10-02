// Code your design here

`include "axi_common.sv"
import axi_common::*;

module axi_slave(
   input aclk, arst,
   input [3:0] awid,
   input [31:0] awaddr,
   input [3:0] awlen,
   input [2:0] awsize,
   input [1:0] awbrust,
   input [1:0] awlock,
   input [3:0] awcache,
   input [2:0] awprot,
   input awqos,
   input awregion,
   input awuser,
   input awvalid,
   output reg awready,
   input [3:0] wid,
   input [31:0] wdata,
   input [3:0] wstrb,
   input wlast,
   input wuser,
   input wvalid,
   output reg wready,
   output reg [3:0] bid,
   output reg [1:0] bresp,
   output buser,
   output reg bvalid,
   input bready,
   //read signal
   input [3:0] arid,
   input [31:0] araddr,
   input [3:0] arlen,
   input [2:0] arsize,
   input [1:0] arbrust,
   input [1:0] arlock,
   input [3:0] arcache,
   input [2:0] arprot,
   input arqos,
   input arregion,
   input aruser,
   input arvalid,
   output reg arready,
   output reg [3:0] rid,
   //output reg [31:0] rdata,
   output [31:0] rdata,
   output reg rlast,
   output ruser,
   output reg rvalid,
   input rready,
   output reg [1:0] rresp
);

parameter WIDTH=32;

bit [31:0] addr_offset, wrap_lower_addr, wrap_upper_addr;
integer tx_size;

reg [WIDTH-1:0] mem [int];//associative array

reg [3:0] awid_t;
reg [31:0] awaddr_t;
reg [3:0] awlen_t;
reg [2:0] awsize_t;
reg [1:0] awbrust_t;
reg [1:0] awlock_t;
reg [3:0] awcache_t;
reg [2:0] awprot_t;
reg awqos_t;
reg [3:0] arid_t;
reg [31:0] araddr_t;
reg [3:0] arlen_t;
reg [2:0] arsize_t;
reg [1:0] arbrust_t;
reg [1:0] arlock_t;
reg [3:0] arcache_t;
reg [2:0] arprot_t;
reg arqos_t;
integer write_count;

reg [31:0] rdata_t;


assign buser = 0;
assign ruser = 0;



reg [31:0] delay_addr_range_1;	//32'h1000_0000 <--> 32'h2000_0000
reg [31:0] delay_addr_range_2;	//32'h2000_0000	<--> 32'h4000_0000
reg [31:0] delay_addr_range_3;	//32'h4000_0000	<--> 32'h8000_0000
reg [31:0] delay_addr_range_4;	//32'h8000_0000 <--> 32'hD000_0000

integer resp_delay;

always @(posedge aclk) begin
// write address handshake
	if (awvalid == 1) begin
		awready = 1;
		awaddr_t = awaddr;
		awlen_t = awlen;
		awsize_t = awsize;
		awbrust_t = awbrust;
		awid_t = awid;
		awlock_t = awlock;
		awprot_t = awprot;
		awcache_t = awcache;

    resp_delay = get_addr_range(awaddr);
    #resp_delay;

	end
	else begin
		awready = 0;
	end

//write data handshake	
	if (wvalid == 1) begin
		wready = 1;
		store_write_data();
		write_count++;
		if (wlast == 1)begin
			if (write_count != awlen + 1)begin
			$error("write brust are not matching awlen+1");
		end
			write_resp_phase(wid);
		end
	end
	else begin
		wready = 0;
	end


//read address handshake	
	if (arvalid == 1) begin
		arready = 1;
		araddr_t = araddr;
		arlen_t = arlen;
		arsize_t = arsize;
		arbrust_t = arbrust;
		arid_t = arid;
		arlock_t = arlock;
		arprot_t = arprot;
		arcache_t = arcache;

    // During read address calculate wrap lower and upper boundaries
    calc_wrap_boundaries(araddr_t, arlen_t, arsize_t);

    fork
      resp_delay = get_addr_range(araddr);
      #resp_delay;
      // master has requested, I need to supply the data
      drive_read_data();
    join_none;


	end
	else begin
		arready = 0;
	end
end

  always @(posedge aclk) begin
    if (arst == 1)begin
		 arready = 0;
		 wready = 0;
		 awready = 0;
		 rid = 0;
		 rdata_t = 0;
		 rlast = 0;
		 rvalid = 0;
		 bid = 0;
		 bvalid = 0;
		 bresp = 0;
		 rresp = 0;
	  end
  end



task store_write_data();
	if(awsize_t == 0) begin
		mem[awaddr_t] = wdata[7:0];
	end
	if(awsize_t == 1) begin
		mem[awaddr_t] = wdata[7:0];
		mem[awaddr_t+1] = wdata[15:8];
	end
	if(awsize_t == 2) begin
		mem[awaddr_t] = wdata[7:0];
		mem[awaddr_t+1] = wdata[15:8];
		mem[awaddr_t+2] = wdata[23:16];
		mem[awaddr_t+3] = wdata[31:24];
	end
//if(awsize_t == 3) begin
//  mem[awaddr_t] = wdata[7:0];
//  mem[awaddr_t+1] = wdata[15:8];
//	mem[awaddr_t+2] = wdata[23:16];
//	mem[awaddr_t+3] = wdata[31:24];
//	mem[awaddr_t+4] = wdata[39:32];
//	mem[awaddr_t+5] = wdata[47:40];
//	mem[awaddr_t+6] = wdata[55:48];
//	mem[awaddr_t+7] = wdata[63:56];
//end

	awaddr_t += (2**awsize_t);

endtask

  
task drive_read_data();

	for (int i = 0; i<=arlen_t + 1; i++) begin
    
    @(posedge aclk);

    if(arsize_t == 0) begin
      rdata_t[7:0] = mem[araddr_t];
      end
	
    if(arsize_t == 1) begin
      rdata_t[7:0] = mem[araddr_t];
      rdata_t[15:8] = mem[araddr_t + 1];
    end
	
    if(arsize_t == 2) begin

      rdata_t[7:0] = mem[araddr_t];
      rdata_t[15:8] = mem[araddr_t+1];
      rdata_t[23:16] = mem[araddr_t+2];
      rdata_t[31:24] = mem[araddr_t+3];

    end
  
    //if(arsize_t == 3) begin
    //   rdata[7:0] = mem[araddr_t];
    //   rdata[15:8] = mem[araddr_t+1];
    //	 rdata[23:16] = mem[araddr_t+2];
    //	 rdata[31:24] = mem[araddr_t+3];
    //	 rdata[39:32] = mem[araddr_t+4];
    //	 rdata[47:40] = mem[araddr_t+5];
    //	 rdata[55:48] = mem[araddr_t+6];
    //	rdata[63:56] = mem[araddr_t+7];
    //end                 

    rvalid = 1;
    rid = arid_t;
    rresp = 2'b00;

    if(i==arlen_t + 1) begin 
      rlast = 1;
    end

    wait (rready == 1);	
    araddr_t += (2**arsize_t);

    if(arbrust_t == WRAP) begin
      if(araddr_t >=wrap_upper_addr) begin
        araddr_t = wrap_lower_addr;
      end
      //check_wrap_boundaries(araddr_t, len_t, brust_size_t);
    end

  end

  @(posedge aclk);
  rvalid = 0;
  rid = 0;
  rdata_t = 0;
  rlast = 0;

endtask

assign rdata = rdata_t;

task write_resp_phase(input [3:0] id);
	@(posedge aclk);
	bvalid = 1;
	bid = id;
	bresp = 2'b00;
	wait (bready == 1);
	@(posedge aclk);
	bvalid = 0;
endtask


function void calc_wrap_boundaries(bit [31:0] addr, bit [3:0] len, bit [2:0] brust_size);
  //slave need to check when address reaches upper wrap boundary, then it should round it off
  tx_size = (len + 1)*(2**brust_size);
  addr_offset = addr%tx_size;
  wrap_lower_addr = addr - addr_offset;
  wrap_upper_addr = wrap_lower_addr + tx_size - 1;
endfunction



function int get_addr_range (input [31:0] addr);

  integer delay;

	if(addr inside {[32'h1000_0000:32'h2000_0000]}) delay = delay_addr_range_1;
	if(addr inside {[32'h3000_0000:32'h5000_0000]}) delay = delay_addr_range_2;
	if(addr inside {[32'h6000_0000:32'h9000_0000]}) delay = delay_addr_range_3;
	if(addr inside {[32'hA000_0000:32'hD000_0000]}) delay = delay_addr_range_4;

  return delay;
endfunction


endmodule

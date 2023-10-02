module axi_assertion(
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
   input awready,
   input [3:0] wid,
   input [31:0] wdata,
   input [3:0] wstrb,
   input wlast,
   input wuser,
   input wvalid,
   input wready,
   input [3:0] bid,
   input [1:0] bresp,
   input buser,
   input bvalid,
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
   input arready,
   input [3:0] rid,
   //input [31:0] rdata,
   input [31:0] rdata,
   input rlast,
   input ruser,
   input rvalid,
   input rready,
   input [1:0] rresp
   );
  
   // Handshaking Check
   property handshake_prop(valid, ready, MAX);
      @(posedge aclk) valid |-> ##[0:MAX] (ready == 1);
   endproperty

   // wa channel handshaking
   WA_CHANNEL_HANDSHAKE_PROP : assert property (handshake_prop(awvalid, awready, 5));
   WD_CHANNEL_HANDSHAKE_PROP : assert property (handshake_prop(wvalid, wready, 5));
   WR_CHANNEL_HANDSHAKE_PROP : assert property (handshake_prop(bvalid, bready, 5));
   RA_CHANNEL_HANDSHAKE_PROP : assert property (handshake_prop(arvalid, arready, 5));
   //RD_CHANNEL_HANDSHAKE_PROP : assert property (handshake_prop(rvalid, rready, 5));

   //when write address phase is happening, all address channel signals should have known values
   property valid_check_prop(valid, check_signal);
        @(posedge aclk) valid |-> not ($isunknown(check_signal));   // check signal should have a known value
   endproperty

   WA_AWADDR_PROP : assert property (valid_check_prop(awvalid, awaddr));
   WA_AWLEN_PROP : assert property (valid_check_prop(awvalid, awlen));
   WA_AWSIZE_PROP : assert property (valid_check_prop(awvalid, awsize));
   WA_AWBRUST_PROP : assert property (valid_check_prop(awvalid, awbrust));
   WA_AWID_PROP : assert property (valid_check_prop(awvalid, awid));
   WA_AWPROT_PROP : assert property (valid_check_prop(awvalid, awprot));
   WA_AWLOCK_PROP : assert property (valid_check_prop(awvalid, awlock));
   WA_AWCACHE_PROP : assert property (valid_check_prop(awvalid, awcache));
   WD_WDATA_PROP : assert property (valid_check_prop(wvalid, wdata));
   WD_WID_PROP : assert property (valid_check_prop(wvalid, wid));
   WD_WSTRB_PROP : assert property (valid_check_prop(wvalid, wstrb));
   
   WR_BID_PROP : assert property (valid_check_prop(bvalid, bid));
   WR_BRESP_PROP : assert property (valid_check_prop(bvalid, bresp));


   // READ
   RA_ARADDR_PROP : assert property (valid_check_prop(arvalid, araddr));
   RA_ARLEN_PROP : assert property (valid_check_prop(arvalid, arlen));
   RA_ARSIZE_PROP : assert property (valid_check_prop(arvalid, arsize));
   RA_ARBRUST_PROP : assert property (valid_check_prop(arvalid, arbrust));
   RA_ARID_PROP : assert property (valid_check_prop(arvalid, arid));
   RA_ARPROT_PROP : assert property (valid_check_prop(arvalid, arprot));
   RA_ARLOCK_PROP : assert property (valid_check_prop(arvalid, arlock));
   RA_ARCACHE_PROP : assert property (valid_check_prop(arvalid, arcache));
   //RD_RDATA_PROP : assert property (valid_check_prop(rvalid, rdata));
   RD_RID_PROP : assert property (valid_check_prop(rvalid, rid));
   //RD_RSTRB_PROP : assert property (valid_check_prop(rvalid, rstrb));
   
   RD_RRESP_PROP : assert property (valid_check_prop(rvalid, rresp));



endmodule
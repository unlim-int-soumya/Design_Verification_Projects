interface axi_intf(input logic aclk, input arst);
  logic [3:0] awid;

  logic [31:0] awaddr;
  logic [3:0] awlen;
  logic [2:0] awsize;
  logic [1:0] awbrust;
  logic [1:0] awlock;
  logic [3:0] awcache;
  logic [2:0] awprot;
  logic awqos;
  logic awregion;
  logic awuser;
  logic awvalid;
  logic awready;
  logic [3:0] wid;
  logic [31:0] wdata;
  logic [3:0] wstrb;
  logic wlast;
  logic wuser;
  logic wvalid;
  logic wready;
  logic [3:0] bid;
  logic [1:0] bresp;
  logic buser;
  logic bvalid;
  logic bready;
  
  
  
  logic [3:0] arid;

  logic [31:0] araddr;
  logic [3:0] arlen;
  logic [2:0] arsize;
  logic [1:0] arbrust;
  logic [1:0] arlock;
  logic [3:0] arcache;
  logic [2:0] arprot;
  logic arqos;
  logic arregion;
  logic aruser;
  logic arvalid;
  logic arready;
  logic [3:0] rid;
  logic [31:0] rdata;

  logic rlast;
  logic ruser;
  logic rvalid;
  logic rready;  
  logic [1:0] rresp;


  clocking drv_cb @ (posedge aclk);
  
    //default input #0 output #0;
    
    default input #0 output #0;
    
    output awid;

    // write address
    output awaddr;
    output awlen;
    output awsize;
    output awbrust;
    output awlock;
    output awcache;
    output awprot;
    output awqos;
    output awregion;
    output awuser;
    output awvalid;

    input awready;


    output wid;
    output wdata;
    output wstrb;
    output wlast;
    output wuser;
    output wvalid;
    input wready;

    input bid;
    input bresp;
    input buser;
    input bvalid;
    output bready;

    //read signal
    output arid;
    output araddr;
    output arlen;
    output arsize;
    output arbrust;
    output arlock;
    output arcache;
    output arprot;
    
    output arqos;
    output arregion;
    output aruser;
    output arvalid;
    
    input arready;
    input rid;
    input rdata;
    input rlast;
    input ruser;
    input rvalid;

    
    output rready;
    input rresp;


  endclocking



  clocking mon_cb @ (posedge aclk);
  
    //default input #0 output #1;
    
    default input #1;
    
    input awid;

    // write address
    input awaddr;
    input awlen;
    input awsize;
    input awbrust;
    input awlock;
    input awcache;
    input awprot;
    input awqos;
    input awregion;
    input awuser;
    input awvalid;

    input awready;


    input wid;
    input wdata;
    input wstrb;
    input wlast;
    input wuser;
    input wvalid;
    input wready;

    input bid;
    input bresp;
    input buser;
    input bvalid;
    input bready;

    //read signal
    input #0 arid;
    input #0 araddr;
    input #0 arlen;
    input #0 arsize;
    input #0 arbrust;
    input #0 arlock;
    input #0 arcache;
    input #0 arprot;
    
    input #0 arqos;
    input #0 arregion;
    input #0 aruser;
    input #0 arvalid;
    
    input #0 arready;
    input #0 rid;
    input #0 rdata;
    input #0 rlast;
    input #0 ruser;
    input #0 rvalid;

    
    input #0 rready;
    input #0 rresp;

  endclocking

  modport DRIVER (clocking drv_cb, input aclk, arst);

  modport MONITOR (clocking mon_cb, input aclk, arst);

  
  
endinterface
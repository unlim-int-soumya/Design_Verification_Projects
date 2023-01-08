`define ADDR_WIDTH 10
`define DATA_WIDTH 32

module assertion(
  input clk,
  input resetn,
  input [`DATA_WIDTH-1:0]wdata,
  input [`ADDR_WIDTH-1:0]addr,
  input selx,
  input enable,
  input write,
  input [`DATA_WIDTH-1:0]rdata,
  input ready,
  input slverr
  );

  property p1;
    disable iff(!resetn)
    @(posedge clk) selx |-> (!ready) |-> ##1 enable;
  endproperty

  property p2;
    disable iff(!resetn)
    @(posedge clk) selx |=> $stable(write);
  endproperty

  property p3;
    disable iff(!resetn)
    @(posedge clk) selx |=> $stable(addr);
  endproperty
  
  property p4;
    disable iff(!resetn)
    @(posedge clk) selx |=> $stable(wdata);
  endproperty
  
  property p5;
    disable iff(!resetn)
    @(posedge clk) enable |=> $stable(write);
  endproperty

  property p6;
    disable iff(!resetn)
    @(posedge clk) enable |=> $stable(addr);
  endproperty
  
  property p7;
    disable iff(!resetn)
    @(posedge clk) enable |=> $stable(wdata);
  endproperty
  
  property p8;
    disable iff(!resetn)
    @(posedge clk) ready |-> !$isunknown(slverr);
  endproperty

  property p9;
    disable iff(!resetn)
    @(posedge clk) (!write && ready) |-> !$isunknown(rdata);
  endproperty
  
  property p10;
    disable iff(!resetn)
    @(posedge clk) write |-> !$isunknown(addr);
  endproperty
  
  property p11;
    disable iff(!resetn)
    @(posedge clk) !write |-> !$isunknown(addr);
  endproperty
  
  property p12;
    disable iff(!resetn)
    @(posedge clk) write |-> !$isunknown(wdata);
  endproperty
  

  assert property (p1)
    else $error("p1:assertion failed");

  assert property (p2)
    else $error("p2:assertion failed");
    
  assert property (p3)
    else $error("p3:assertion failed");

  assert property (p4)
    else $error("p4:assertion failed");

  assert property (p5)
    else $error("p5:assertion failed");
    
  assert property (p6)
    else $error("p6:assertion failed");
    
  assert property (p7)
    else $error("p7:assertion failed");

  assert property (p8)
    else $error("p8:assertion failed");
    
  /*assert property (p9)
    else $error("p9:assertion failed");*/
    
  assert property (p10)
    else $error("p10:assertion failed");

  assert property (p11)
    else $error("p11:assertion failed");
    
  assert property (p12)
    else $error("p12:assertion failed");

endmodule

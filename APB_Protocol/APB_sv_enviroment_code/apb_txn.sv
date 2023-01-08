class apb_txn;
  
  rand logic [`TB_DATA_WIDTH-1:0]pwdata;
  rand logic [`TB_ADDR_WIDTH-1:0]paddr;
  rand logic pwrite;
  logic [`TB_DATA_WIDTH-1:0]prdata;
  logic pslverr;
  
  constraint paddr_range{soft paddr <= 'h3ff;};
  
  function void display(string name);
    $display("............................");
    $display("time=%0t: %s",$time,name);
    $display("paddr=%h",paddr);
    $display("pwdata=%h",pwdata);
    $display("pwrite=%h",pwrite);
    $display("prdata=%h",prdata);
    $display("pslverr=%h",pslverr);
    $display("............................");
  endfunction
  
endclass

class agent extends component_base;
  
  driver drv;
  sequencer ag_seqr;
  monitor mon;
  
  function new(string name, component_base parent);
    super.new(name, parent);
    
    drv = new("drv", this);
    ag_seqr = new("ag_seqr", this);
    mon = new("mon", this);
    
    //ag_seqr = new drv.seqr;
    
    // in question it was given to driver sequencer handle to sequencer instance. 
    // How below can be true
    drv.seqr = ag_seqr;
    
    $display("agent created");
    
  endfunction
  
  task run();
    $display(getname());
    myprint();
    $display("\n");
  endtask
  
endclass
class apb_agent;
  apb_gen gen;
  apb_bfm bfm;
  apb_mon mon;
  
  function new();
    gen=new();
    bfm=new();
    mon=new();
  endfunction
  
  task run(int j);
    $display("Agent:agent_no:%0d",j);
    fork
      gen.run(j);
      bfm.run(j);
      mon.run(j);
    join
  endtask
  
endclass

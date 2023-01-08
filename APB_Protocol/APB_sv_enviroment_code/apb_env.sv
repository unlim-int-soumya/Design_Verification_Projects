class apb_env;
  apb_agent agentDA[];
  apb_scb scb;
  apb_cov_collecter cov;
  
  function new();
    agentDA = new[apb_common::num_agents];
    foreach (agentDA[i]) begin
      agentDA[i] = new();
    end
    scb = new();
    cov = new();
  endfunction
  task run();
    for (int i =0; i < apb_common::num_agents; i++) begin
      automatic int j = i;
      fork
        agentDA[j].run(j);
      join_none
    end
    fork
      scb.run();
      cov.run();
    join
    wait fork;
  endtask
endclass

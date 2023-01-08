class apb_cov_collecter;
  apb_txn txn;

  covergroup cov_grp;
    cov_p1:coverpoint txn.paddr{bins b1 = {['h0:'hf]};
                                bins b2 = {['h10:'hff]};
                                bins b3 = {['h100:'h200]};
                                bins b4 = {['h201:'h300]};
                                bins b5 = {['h301:'h3ff]};}
                         
    cov_p2:coverpoint txn.pwdata{bins b1 = {['h0:'hf]};
                                 bins b2 = {['h10:'hff]};
                                 bins b3 = {['h100:'hfff]};
                                 bins b4 = {['h1000:'hffff]};
                                 bins b5 = {['h10000:'hfffff]};
                                 bins b6 = {['h100000:'hffffff]};
                                 bins b7 = {['h1000000:'hfffffff]};
                                 bins b8 = {['h10000000:'hffffffff]};}
                                
    cov_p3:coverpoint txn.pwrite;
    
    cov_p4:coverpoint txn.prdata{bins b1 = {['h0:'hf]};
                                 bins b2 = {['h10:'hff]};
                                 bins b3 = {['h100:'hfff]};
                                 bins b4 = {['h1000:'hffff]};
                                 bins b5 = {['h10000:'hfffff]};
                                 bins b6 = {['h100000:'hffffff]};
                                 bins b7 = {['h1000000:'hfffffff]};
                                 bins b8 = {['h10000000:'hffffffff]};}
  endgroup

  function new();
    cov_grp = new();
  endfunction

  task run();
    forever begin
      apb_common::mon2cov.get(txn);
      txn.display("Coverage: Data packet");
      cov_grp.sample();
      get_coverage();
      apb_common::cov_count++;
      $display("cov_count=%0d",apb_common::cov_count);
    end
  endtask

  task get_coverage;
    $display("-----------------coverage report-----------------");
    $display("cov_grp.cov_p1 paddr:coverage = %0f%%", cov_grp.cov_p1.get_coverage());
    $display("cov_grp.cov_p2 pwdata:coverage = %0f%%", cov_grp.cov_p2.get_coverage());
    $display("cov_grp.cov_p3 pwrite:coverage = %0f%%", cov_grp.cov_p3.get_coverage());
    $display("cov_grp.cov_p4 prdata:coverage = %0f%%", cov_grp.cov_p4.get_coverage());
    $display("TOTAL COVERAGE = %0f%%", $get_coverage());
  endtask

endclass

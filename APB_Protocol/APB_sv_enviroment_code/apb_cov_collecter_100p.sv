class apb_cov_collecter;
  apb_txn txn;

  covergroup cov_grp;
    cov_p1:coverpoint txn.paddr{bins b1 = {['h0:'h400]};}
                         
    cov_p2:coverpoint txn.pwdata{bins b1 = {['0:'hffffffff]};}
                                
    cov_p3:coverpoint txn.pwrite;
    
    cov_p4:coverpoint txn.prdata{bins b1 = {['h0:'hffffffff]};}
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

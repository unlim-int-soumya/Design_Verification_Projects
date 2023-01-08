class apb_mon;
  virtual apb_intf mon_vif;
  apb_txn txn;

  task run(int j);
    mon_vif = apb_common::vif;
    forever begin
      txn = new();
      apb_common::smp.get(1);
      if(`mon_vif.pselx) begin
        if(`mon_vif.penable) begin
          wait(`mon_vif.pready);
          // write
          if(`mon_vif.pwrite) begin
            if(`mon_vif.pslverr) begin
              $error("pslverr");
            end
            else begin
              txn.paddr = `mon_vif.paddr;
              txn.pwrite = `mon_vif.pwrite;
              txn.pwdata = `mon_vif.pwdata;
              txn.pslverr = `mon_vif.pslverr;
            end 
          end
          // read
          else if(!`mon_vif.pwrite) begin
            if(`mon_vif.pslverr) begin
              $error("pslverr");
            end
            else begin
              txn.paddr = `mon_vif.paddr;
              txn.pwrite = `mon_vif.pwrite;
              txn.prdata = `mon_vif.prdata;
              txn.pslverr = `mon_vif.pslverr;
            end 
          end
          $display("Monitor:agent_no=%0d",j);
          txn.display("Monitor: Data packet");
          apb_common::mon2scb.put(txn);
          apb_common::mon2cov.put(txn);
          @(`mon_vif);
        end
      end
      apb_common::smp.put(1);
      @(`mon_vif);
    end
  endtask

endclass

class apb_bfm;
  apb_txn txn;
  virtual apb_intf bfm_vif;
  int k;

  task run(int j);
    bfm_vif = apb_common::vif;
    k=j;
    forever begin
      apb_common::gen2bfm[j].get(txn);
      $display("Driver:agent_no=%0d",k);
      txn.display("Driver: Data packet received from generator");
      apb_common::smp.get(1);
      if(txn.pwrite==1) begin
        write_data(txn);
      end
      else if(txn.pwrite==0) begin
        read_data(txn);
      end
      apb_common::tx_driven_count++;
      apb_common::smp.put(1);
    end
  endtask
  
  task write_data(apb_txn txn);
    wait(bfm_vif.presetn==1);
    @(`bfm_vif);
    `bfm_vif.pselx <= 1;
    `bfm_vif.penable <= 0;
    `bfm_vif.paddr <= txn.paddr;
    `bfm_vif.pwdata <= txn.pwdata;
    `bfm_vif.pwrite <= txn.pwrite;
    @(`bfm_vif);
    `bfm_vif.penable <= 1;
    wait(`bfm_vif.pready==1);
    $display("Driver:agent_no=%0d",k);
    txn.display("Driver: Data packet received from DUT");
    @(`bfm_vif);
    `bfm_vif.pselx <= 0;
    `bfm_vif.penable <= 0;
  endtask

  task read_data(apb_txn txn);
    wait(bfm_vif.presetn==1);
    @(`bfm_vif);
    `bfm_vif.pselx <= 1;
    `bfm_vif.penable <= 0;
    `bfm_vif.paddr <= txn.paddr;
    `bfm_vif.pwrite <= txn.pwrite;
    @(`bfm_vif);
    `bfm_vif.penable <= 1;
    wait(`bfm_vif.pready==1);
    txn.prdata = `bfm_vif.prdata;
    txn.pslverr = `bfm_vif.pslverr;
    $display("Driver:agent_no=%0d",k);
    txn.display("Driver: Data packet received from DUT");
    @(`bfm_vif);
    `bfm_vif.pselx <= 0;
    `bfm_vif.penable <= 0;
  endtask
  
endclass

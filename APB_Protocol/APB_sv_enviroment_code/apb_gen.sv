class apb_gen;
  apb_txn txn;
  apb_txn txQ[$];
  
  task run(int j);
    case (apb_common::testname)
      "test_wr_rd" : begin
                       write(j);
                       write_followed_read(j);
                     end
      "test_wr" : begin
                       write(j);
                     end
      "test_rd" : begin
                       read(j);
                     end
    endcase
    txQ.delete();
  endtask
  
  task write(int j);
    for(int i = 0; i < apb_common::num_tx; i++) begin
      txn = new();
      //disabling constraint
      txn.paddr_range.constraint_mode(0);
      //assert(txn.randomize());
      //assert(txn.randomize()with {pwrite == 1; paddr == 12'h1ff;});
      assert(txn.randomize()with {pwrite == 1;});
      $display("Generator:agent_no=%0d",j);
      txn.display("Generator: Data packet for write");
      apb_common::gen2bfm[j].put(txn);
      txQ.push_back(txn);
    end
  endtask
  
  task write_followed_read(int j);
    for(int i = 0; i < apb_common::num_tx; i++) begin
      txn = new();
      assert(txn.randomize()with {pwrite == 0; paddr == txQ[i].paddr;});
      $display("Generator:agent_no=%0d",j);
      txn.display("Generator: Data packet for read");
      apb_common::gen2bfm[j].put(txn);
    end
  endtask
  
    task read(int j);
    for(int i = 0; i < apb_common::num_tx; i++) begin
      txn = new();
      //disabling constraint
      txn.paddr_range.constraint_mode(0);
      assert(txn.randomize()with {pwrite == 0;});
      $display("Generator:agent_no=%0d",j);
      txn.display("Generator: Data packet for read");
      apb_common::gen2bfm[j].put(txn);
    end
  endtask
  
endclass
class apb_scb;
  apb_txn txn;
  reg [`TB_MEM_WIDTH-1:0]mem[`TB_MEM_DEPTH-1:0];

  task run();
    forever begin
      apb_common::mon2scb.get(txn);
      txn.display("Scoreboard: Data packet");     

      if((!txn.pslverr)==((txn.paddr>=0)&&(txn.paddr<`TB_MEM_DEPTH))) begin
        if(txn.pwrite) begin
          $display("Scoreboard:slave error for write comparision passed");
          mem[txn.paddr] = txn.pwdata;
        end
        else if(!txn.pwrite) begin
          $display("Scoreboard:slave error for read comparision passed");
          if(mem[txn.paddr]==txn.prdata) begin
            $display("Scoreboard:Data read comparision passed");
          end
          else begin
            $error("Scoreboard:Data read comparision failed");
          end
        end
        apb_common::compare_count++;
        $display("compare_count=%0d",apb_common::compare_count);
      end
      else begin
        $error("Scoreboard:slave error comparision failed");
        apb_common::compare_count++;
        $display("compare_count=%0d",apb_common::compare_count);
      end
    end

  endtask

endclass

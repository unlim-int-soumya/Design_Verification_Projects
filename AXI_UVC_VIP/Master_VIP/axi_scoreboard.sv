class axi_scoreboard extends uvm_subscriber #(axi_tx);

  `uvm_component_utils(axi_scoreboard)


  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  axi_tx t;

  byte mem[int]; //associative array
  //byte mem[2**32-1:0]; //memory will be very large

  bit [31:0] exp_data;

  //uvm_analysis_imp #(axi_t, axi_scoreboard) item_collect_export;

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "Build Phase Executed", UVM_MEDIUM)
    //item_collect_export = new("item_collect_export"); 
  endfunction


  function void write(T t);

    `uvm_info(get_type_name(), "Run Phase", UVM_MEDIUM)

    //forever begin
      if(t.wr_rd == WRITE) begin
        for(int i=0; i<=t.len ;i++) begin

          if(t.brust_size == 0) begin
            if(t.addr % `WDATA_SIZE == 0) mem[t.addr] = t.dataQ[i][7:0];
            if(t.addr % `WDATA_SIZE == 1) mem[t.addr] = t.dataQ[i][15:8];
            if(t.addr % `WDATA_SIZE == 2) mem[t.addr] = t.dataQ[i][23:16];
            if(t.addr % `WDATA_SIZE == 3) mem[t.addr] = t.dataQ[i][31:24];
          end

          if(t.brust_size == 1) begin
            if(t.addr % `WDATA_SIZE == 0)  begin
              mem[t.addr] = t.dataQ[i][7:0];
              mem[t.addr+1] = t.dataQ[i][15:8];
            end
            if(t.addr % `WDATA_SIZE == 2)  begin
              mem[t.addr] = t.dataQ[i][23:16];
              mem[t.addr+1] = t.dataQ[i][31:24];
            end
          end

          if(t.brust_size == 2) begin
            if(t.addr % `WDATA_SIZE == 0)  begin
              mem[t.addr] = t.dataQ[i][7:0];
              mem[t.addr+1] = t.dataQ[i][15:8];
              mem[t.addr+2] = t.dataQ[i][23:16];
              mem[t.addr+3] = t.dataQ[i][31:24];
              //$display("Storing data to reference model memory");
              `uvm_info(get_type_name(), "Storing data to reference model memory", UVM_MEDIUM)
            end
          end

          t.addr = t.addr + 2**t.brust_size;
        end
      end

      else if(t.wr_rd == READ) begin


        for(int i=0; i<=t.len; i++) begin


          if (t.brust_size == 2) begin
            if (t.addr % `WDATA_SIZE == 0) begin
              exp_data[7:0] = mem[t.addr];
              exp_data[15:8] = mem[t.addr+1];
              exp_data[23:16] = mem[t.addr+2];
              exp_data[31:24] = mem[t.addr+3];

              if (exp_data == t.dataQ[i]) begin
                `uvm_info(get_type_name(), $sformatf("Read data matched with expected data, ref_model_data=%0h, dut_data=%0h", exp_data, t.dataQ[i]), UVM_LOW)
              end else begin
                `uvm_error(get_type_name(), $sformatf("read data mismatch with expected data, ref_model_data=%0h, dut_data=%0h", exp_data, t.dataQ[i]))
              end
              t.addr = t.addr + 2**t.brust_size;
            end
          end


        end

      end //if READ

    //end   // forever


  endfunction

endclass

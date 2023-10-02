//++++++++++++++++++++++++//
//		 	AXI_REF		  //
//++++++++++++++++++++++++//
`include "uvm_macros.svh"
import uvm_pkg::*;
class axi_ref extends uvm_component;

  `uvm_component_utils(axi_ref)


  function new(string name = "", uvm_component parent= null);
    super.new(name, parent);
  endfunction


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction


  axi_tx tx;

  byte mem[int]; //associative array
  //byte mem[2**32-1:0]; //memory will be very large

  bit [31:0] exp_data;


  task run_phase(uvm_phase phase);

    `uvm_info(get_type_name(), "Run Phase", UVM_MEDIUM)

    forever begin

      if(tx.wr_rd == WRITE) begin

        for(int i=0; i<=tx.len ;i++) begin

          if(tx.brust_size == 0) begin
            if(tx.addr % `WDATA_SIZE == 0) mem[tx.addr] = tx.dataQ[i][7:0];
            if(tx.addr % `WDATA_SIZE == 1) mem[tx.addr] = tx.dataQ[i][15:8];
            if(tx.addr % `WDATA_SIZE == 2) mem[tx.addr] = tx.dataQ[i][23:16];
            if(tx.addr % `WDATA_SIZE == 3) mem[tx.addr] = tx.dataQ[i][31:24];
          end

          if(tx.brust_size == 1) begin
            if(tx.addr % `WDATA_SIZE == 0)  begin
              mem[tx.addr] = tx.dataQ[i][7:0];
              mem[tx.addr+1] = tx.dataQ[i][15:8];
            end
            if(tx.addr % `WDATA_SIZE == 2)  begin
              mem[tx.addr] = tx.dataQ[i][23:16];
              mem[tx.addr+1] = tx.dataQ[i][31:24];
            end
          end

          if(tx.brust_size == 2) begin
            if(tx.addr % `WDATA_SIZE == 0)  begin
              mem[tx.addr] = tx.dataQ[i][7:0];
              mem[tx.addr+1] = tx.dataQ[i][15:8];
              mem[tx.addr+2] = tx.dataQ[i][23:16];
              mem[tx.addr+3] = tx.dataQ[i][31:24];
              $display("Storing data to reference model memory");
            end
          end

          tx.addr = tx.addr + 2**tx.brust_size;
        end
      end

      else if(tx.wr_rd == READ) begin


        for(int i=0; i<=tx.len; i++) begin


          if (tx.brust_size == 2) begin
            if (tx.addr % `WDATA_SIZE == 0) begin
              exp_data[7:0] = mem[tx.addr];
              exp_data[15:8] = mem[tx.addr+1];
              exp_data[23:16] = mem[tx.addr+2];
              exp_data[31:24] = mem[tx.addr+3];

              if (exp_data == tx.dataQ[i]) begin
                $display("read data matched with expected data, ref_model_data=%0h, dut_data=%0h", exp_data, tx.dataQ[i]);
              end else begin
                $error("read data mismatch with expected data, ref_model_data=%0h, dut_data=%0h", exp_data, tx.dataQ[i]);
              end
              tx.addr = tx.addr + 2**tx.brust_size;
            end
          end


        end

      end //if READ

    end   // forever


  endtask

endclass

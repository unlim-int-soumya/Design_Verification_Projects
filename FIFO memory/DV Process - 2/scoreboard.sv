

class scoreboard extends uvm_scoreboard;

	`uvm_component_utils(scoreboard)

	function new(string name ="scoreboard", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	//Why three. Create a process
  bit [7:0] ref_dout;
  bit ref_full;
  bit ref_empty;
  
  bit [7:0] ref_mem [0:15];
  bit [3:0] ref_wr_ptr=0;
  bit [3:0] ref_rd_ptr=0;

	uvm_analysis_imp #(Item, scoreboard) m_analysis_imp;

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		m_analysis_imp = new("m_analysis_imp", this);
	endfunction

 	virtual function void write(Item item);
		`uvm_info("write", $sformatf("Data Received = 0x%0h", item), UVM_MEDIUM)
/*	endfunction

  virtual task run_phase (uvm_phase phase);
		super.run_phase(phase);

      @(posedge vif.cb) begin */
			if(item.rstn) begin
				ref_wr_ptr <= 0;
				ref_rd_ptr <= 0;
			end else begin
				if(item.enq) begin
					ref_mem[ref_wr_ptr] <= item.din;
					ref_wr_ptr <= (ref_wr_ptr == 15)? 0 : ref_wr_ptr + 1;	//If FIFO full then just reset the wr_ptr to 1
				end
              else if(item.deq) begin
					ref_dout <= ref_mem[ref_rd_ptr];
					ref_rd_ptr <= (ref_rd_ptr == 15)? 0 : ref_rd_ptr + 1;
				end
			end
		//end

    
			ref_full = (ref_wr_ptr == ref_rd_ptr) && item.enq;
      ref_empty = (ref_wr_ptr == ref_rd_ptr) && (!item.enq);


	//endtask

    //endfunction
 


  /*virtual function void check_phase (uvm_phase phase);
		super.check_phase(phase);*/

    		if(item.dout != ref_dout) begin
			//`uvm_error("SCBD", $sformatf("ERROR! out=%0d exp=%0d", item.out, exp_out), UVM_HIGH)
      		`uvm_error("SCBD", $sformatf("dout ERROR! rstn=%0d enq=%0d deq =%0b din =%0b dout=%0b full=%0b empty=%0b ref_dout =%0b ref_full =%0b ref_empty =%0b ref_wr_ptr=%0b ref_rd_ptr=%0b ", item.rstn, item.enq, item.deq, item.din, item.dout, item.full, item.empty, ref_dout, ref_full, ref_empty, ref_wr_ptr,ref_rd_ptr))
		end else begin
          		`uvm_info("SCBD", $sformatf("dout PASS! rstn=%0d enq=%0d deq =%0b din =%0b dout=%0b full=%0b empty=%0b ref_dout =%0b ref_full =%0b ref_empty =%0b", item.rstn, item.enq, item.deq, item.din, item.dout, item.full, item.empty, ref_dout, ref_full, ref_empty), UVM_LOW)
		end
    
    		if(item.full != ref_full) begin
			//`uvm_error("SCBD", $sformatf("ERROR! out=%0d exp=%0d", item.out, exp_out), UVM_HIGH)
      		`uvm_error("SCBD", $sformatf("full ERROR! rstn=%0d enq=%0d deq =%0b din =%0b dout=%0b full=%0b empty=%0b ref_dout =%0b ref_full =%0b ref_empty =%0b", item.rstn, item.enq, item.deq, item.din, item.dout, item.full, item.empty, ref_dout, ref_full, ref_empty))
		end else begin
          	`uvm_info("SCBD", $sformatf("full PASS! rstn=%0d enq=%0d deq =%0b din =%0b dout=%0b full=%0b empty=%0b ref_dout =%0b ref_full =%0b ref_empty =%0b", item.rstn, item.enq, item.deq, item.din, item.dout, item.full, item.empty, ref_dout, ref_full, ref_empty), UVM_LOW)
		end
    
    		if(item.empty != ref_empty) begin
			//`uvm_error("SCBD", $sformatf("ERROR! out=%0d exp=%0d", item.out, exp_out), UVM_HIGH)
      		`uvm_error("SCBD", $sformatf("empty ERROR! rstn=%0d enq=%0d deq =%0b din =%0b dout=%0b full=%0b empty=%0b ref_dout =%0b ref_full =%0b ref_empty =%0b", item.rstn, item.enq, item.deq, item.din, item.dout, item.full, item.empty, ref_dout, ref_full, ref_empty))
		end else begin
          		`uvm_info("SCBD", $sformatf("empty PASS! rstn=%0d enq=%0d deq =%0b din =%0b dout=%0b full=%0b empty=%0b ref_dout =%0b ref_full =%0b ref_empty =%0b", item.rstn, item.enq, item.deq, item.din, item.dout, item.full, item.empty, ref_dout, ref_full, ref_empty), UVM_LOW)
		end		


	endfunction
    
   

endclass
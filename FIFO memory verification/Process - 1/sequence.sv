`include "sequencer.sv"
/***********************************************
* sequence 
***********************************************/
// FIFO test 1
// write FIFO from empty to full -> read FIFO from full to empty
class FIFO_test_1_sequence extends uvm_sequence #(data_transaction); 
    `uvm_object_utils(FIFO_test_1_sequence)
    
    data_transaction tr;

  function new(string name = "data_seq_1");
        super.new(name); 
    endfunction
    
    task body();
        for (int i = 0; i < 40; i++) begin 
            tr = data_transaction::type_id::create("tx_data_tr");
            start_item(tr);
            
            if (i < 20) begin
                if (!tr.randomize() with {tr.put == 1'b1; tr.get == 1'b0;}) begin
                    `uvm_error("Sequence", "Randomization failure for trasaction")
                end 
            end
            else begin
                if (!tr.randomize() with {tr.put == 1'b0; tr.get == 1'b1;}) begin
                    `uvm_error("Sequence", "Randomization failure for trasaction")
                end 
            end

            finish_item(tr); 
        end
    endtask
endclass : FIFO_test_1_sequence   

// Write FIFO from empty to half-full, and then read/write at the same time
class FIFO_test_2_sequence extends uvm_sequence #(data_transaction);
	`uvm_object_utils(FIFO_test_2_sequence)
	
    data_transaction tr;
	
    function new(string name = "data_seq_1");
		super.new(name);
	endfunction
	
	task body();
		for (int i = 0; i < 40; i++) begin 
          	tr = data_transaction::type_id::create("rd_tr");
            start_item(tr);
            
            if (i < 4) begin
                if (!tr.randomize() with {tr.put == 1'b1; tr.get == 1'b0;}) begin
                    `uvm_error("Sequence", "Randomization failure for trasaction")
                end 
            end
            else begin
                if (!tr.randomize() with {tr.put == 1'b1; tr.get == 1'b1;}) begin
                    `uvm_error("Sequence", "Randomization failure for trasaction")
                end 
            end

            finish_item(tr); 
        end
	endtask
endclass

class FIFO_rst_sequence extends uvm_sequence #(rst_transaction);
    `uvm_object_utils(FIFO_rst_sequence)
    
    rst_transaction tr; 
    
  function new(string name = "rst_seq");
        super.new(name); 
    endfunction

    task body();
        tr = rst_transaction::type_id::create("rst_tx_tr");
        start_item(tr); 
        tr.rst = 1'b1;
        finish_item(tr); 

        tr = rst_transaction::type_id::create("rst_tx_tr");
        start_item(tr); 
        tr.rst = 1'b0;
        finish_item(tr); 
    endtask   
endclass



/***********************************************
* virtual sequence 
***********************************************/
class top_vseq_base extends uvm_sequence #(uvm_sequence_item);
    `uvm_object_utils(top_vseq_base)
    
    rst_sequencer rst_sqr_h;
    data_sequencer data_sqr_h;
    
    function new(string name = "top_vseq_base");
        super.new(name);
    endfunction 
endclass

class vseq_rst_data extends top_vseq_base;
    `uvm_object_utils(vseq_rst_data)
  
    FIFO_test_1_sequence fifo_data_seq_h;
    FIFO_rst_sequence fifo_rst_seq_h;

    function new(string name = "vseq_rst_data");
        super.new(name); 
    endfunction

    task body();
        fifo_data_seq_h = FIFO_test_1_sequence::type_id::create("fifo_data_seq_h");   
        fifo_rst_seq_h  = FIFO_rst_sequence::type_id::create("fifo_rst_seq_h");    

      fork
        fifo_rst_seq_h.start(rst_sqr_h);  
        fifo_data_seq_h.start(data_sqr_h); 
      join
    endtask
endclass : vseq_rst_data 

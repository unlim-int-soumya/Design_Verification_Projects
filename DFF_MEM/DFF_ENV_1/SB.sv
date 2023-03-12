class dff_sb extends uvm_scoreboard;

  `uvm_component_utils(dff_sb);

  dff_seq_item pkt,pkt1;

  bit [7:0] mem[0:255];
  bit [7:0] ref_data;
  
  uvm_tlm_analysis_fifo #(dff_seq_item)ip_fifo;
  uvm_tlm_analysis_fifo #(dff_seq_item)op_fifo;


  function new(string name="dff_sb",uvm_component parent);
    super.new(name,parent);
    ip_fifo=new("ip_fifo",this);
    op_fifo=new("op_fifo",this);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    pkt=dff_seq_item::type_id::create("pkt",this);
    pkt1=dff_seq_item::type_id::create("pkt1",this);
  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      
      fork
        ip_fifo.get(pkt);
        `uvm_info("SB","TRANSACTIONS FROM MON1",UVM_NONE);
        $display("sb data_in=%d,addr=%d",pkt.data,pkt.addr);
        op_fifo.get(pkt1);
        `uvm_info("SB","TRANSACTIONS FROM MON2",UVM_NONE);
        $display("sb data_out=%d,addr=%d",pkt1.data,pkt1.addr);
      join
      
      
      if(pkt.rw == 0) begin
        mem[pkt.addr] = pkt.data;
      end
      
      
      ref_data = mem[pkt1.addr];
      
      //if(pkt1.rw) begin
      
      //if(pkt1.rw) begin
    
      if(ref_data==pkt1.data) begin
      //if(pkt1.data==mem[pkt1.addr]) begin
        `uvm_info("SB MATCHED",$sformatf("DATA pkt1.rw=%0b pkt1.addr=%0d Ref data_out=%d, actual data_out=%d",pkt1.rw, pkt1.addr, ref_data,pkt1.data),UVM_NONE);
      end else begin
        `uvm_error("SB NOT MATCHED",$sformatf("DATA pkt1.rw=%0b pkt1.addr=%0d Ref data_out=%d,Actual data_out=%d",pkt1.rw,pkt1.addr,ref_data,pkt1.data));
    
      end 
        
      
    //end 
      
    
    end
        
       
  endtask

endclass

//class my_coverage extends uvm_subscriber #(ip_data);
class my_coverage extends uvm_subscriber #(seq_item);

  //----------------------------------------------------------------------------
  `uvm_component_utils(my_coverage)
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  function new(string name="",uvm_component parent);
    super.new(name,parent);
    dut_cov=new();
  endfunction
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  
  //ip_data txn;
  seq_item txn;
  real cov;
  //----------------------------------------------------------------------------
  
  //----------------------------------------------------------------------------
  covergroup dut_cov;
    option.per_instance= 1;
    option.comment     = "dut_cov";
    option.name        = "dut_cov";
    option.auto_bin_max= 255;

//     rand bit [31:0] addr;
//     rand bit [31:0] data;
//     rand bit rd_or_wr; 
    
    addr  : coverpoint txn.addr;
    data  : coverpoint txn.data;
    rw  : coverpoint txn.rw;
    //m_data:coverpoint txn.m_data;
    //CROSS : cross READ,WRITE;
  endgroup:dut_cov;

  //----------------------------------------------------------------------------

  //---------------------  write method ----------------------------------------
  //function void write(ip_data t);
  function void write(seq_item t);
    txn=t;
    dut_cov.sample();
  endfunction
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    cov=dut_cov.get_coverage();
  endfunction
  //----------------------------------------------------------------------------


  //----------------------------------------------------------------------------
  function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(),$sformatf("Coverage is %f",cov),UVM_MEDIUM)
  endfunction
  //----------------------------------------------------------------------------
  
endclass:my_coverage


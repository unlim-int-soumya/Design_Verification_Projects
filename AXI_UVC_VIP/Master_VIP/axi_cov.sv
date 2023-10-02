//++++++++++++++++++++++++//
//		 	AXI_COV	  	  //
//++++++++++++++++++++++++//

class axi_cov extends uvm_subscriber #(axi_tx);

  `uvm_component_utils(axi_cov)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  event axi_cg_e;

  axi_tx tx;

  real cov;

  covergroup axi_cg;

    ADDR_CP:coverpoint tx.addr {
      option.auto_bin_max = 0;
    }

    WR_RD_CP:coverpoint tx.wr_rd {
      bins WR = {WRITE};
      bins RD = {READ};
    }

    ADDR_X_WR_RD_CP: cross ADDR_CP, WR_RD_CP;

    LEN_CP: coverpoint tx.len{
      option.auto_bin_max = 16;
    }
    ID_CP: coverpoint tx.id{
      option.auto_bin_max = 16;
    }
    BRUST_TYPE_CP: coverpoint tx.brust_type{
      bins FIXED = {FIXED};
      bins INCR = {INCR};
      bins WRAP = {WRAP};
      illegal_bins illegal_brust_type = {RSVD_BRUSTT};
    }
    BRUST_SIZE_CP: coverpoint tx.brust_size{
      bins BRUST_SIZE_1_BYTE = {BRUST_SIZE_1_BYTE};
      bins BRUST_SIZE_2_BYTE = {BRUST_SIZE_2_BYTE};
      bins BRUST_SIZE_4_BYTE = {BRUST_SIZE_4_BYTE};
      bins BRUST_SIZE_16_BYTE = {BRUST_SIZE_16_BYTE};
      bins BRUST_SIZE_32_BYTE = {BRUST_SIZE_32_BYTE};
      bins BRUST_SIZE_64_BYTE = {BRUST_SIZE_64_BYTE};
      bins BRUST_SIZE_128_BYTE = {BRUST_SIZE_128_BYTE}; 
    }
    LOCK_CP: coverpoint tx.lock{
      bins NORMAL = {NORMAL};
      bins EXCLUSIVE = {EXCLUSIVE};
      bins LOCKED = {LOCKED};
      illegal_bins illegal_lock = {RSVD_LOCKT};
    }
    RESP_CP: coverpoint tx.resp{
      bins OKAY = {OKAY};
      bins EXOKAY = {EXOKAY};
      bins SLVERR = {SLVERR};
      bins DECERR = {DECERR};
    }

    LEN_X_WR_RD_CP: cross LEN_CP, WR_RD_CP;
    ID_X_WR_RD_CP: cross ID_CP, WR_RD_CP;
    BRUST_TYPE_X_WR_RD_CP: cross BRUST_TYPE_CP, WR_RD_CP;
    BRUST_SIZE_X_WR_RD_CP: cross BRUST_SIZE_CP, WR_RD_CP;
    LOCK_X_WR_RD_CP: cross LOCK_CP, WR_RD_CP;
    RESP_X_WR_RD_CP: cross RESP_CP, WR_RD_CP;
  endgroup: axi_cg;


  //------------------------------------------------------------------------

  //---------------------  write method -----------------------------------
  function void write(axi_tx t);
    tx=t;
    //inside suscriber
    axi_cg.sample();
  endfunction
  //-----------------------------------------------------------------------

endclass

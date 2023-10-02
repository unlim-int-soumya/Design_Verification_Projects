//++++++++++++++++++++++++//
//		 	AXI_AGENT	  //
//++++++++++++++++++++++++//

class axi_agent extends uvm_agent;

  `uvm_component_utils(axi_agent)



  function new(string name, uvm_component parent);
    super.new(name, parent);
    //mon = new("mon", this);
  endfunction	

  // uvm_active_passive_enum is_active = UVM_ACTIVE;


  axi_sqr sqr;
  axi_bfm bfm;
  axi_mon mon;

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    //    if(is_active == UVM_ACTIVE) begin
    //sqr = axi_sqr::type_id::create("sqr", this);
    //bfm = axi_bfm::type_id::create("bfm", this);
    //mon = axi_mon::type_id::create("mon", this);
    sqr = new("sqr", this);
    bfm = new("bfm", this);
    mon = new("mon", this);
    // end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    //if(is_active == UVM_ACTIVE)
    bfm.seq_item_port.connect(sqr.seq_item_export);
  endfunction

endclass

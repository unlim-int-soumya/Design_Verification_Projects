//++++++++++++++++++++++++//
//		 	AXI_MON		  //
//++++++++++++++++++++++++//

`define MONI_IF vif.MONITOR.mon_cb

class axi_mon extends uvm_monitor;

  virtual axi_intf vif;
  axi_tx tx;
  axi_tx tx_t;

  uvm_analysis_port #(axi_tx) custom_ap;

  `uvm_object_utils(axi_mon)

  function new(string name = "", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    custom_ap = new("custom_ap", this);
    
    uvm_config_db #(virtual axi_intf)::get(this, "", "pif", vif);

  endfunction


  task run_phase(uvm_phase phase);

    `uvm_info(get_type_name(), "Run Phase", UVM_HIGH)

    forever begin
      // waits for posedge of clk
      @(posedge vif.MONITOR.aclk);

      // if awvalid and awready received
      if(`MONI_IF.awvalid && `MONI_IF.awready) begin
        tx = new();
        tx.addr = `MONI_IF.awaddr; 
        tx.wr_rd = WRITE;
        tx.len= `MONI_IF.awlen;
        tx.brust_size= brust_size_t'(`MONI_IF.awsize);
        tx.id= `MONI_IF.awid;
        tx.brust_type=brust_type_t'(`MONI_IF.awbrust);
        tx.lock= lock_t'(`MONI_IF.awlock);
        tx.prot= `MONI_IF.awprot;
        tx.cache = `MONI_IF.awcache;


      end

      if(`MONI_IF.wvalid && `MONI_IF.wready) begin
        tx.dataQ.push_back(`MONI_IF.wdata);
      end

      if(`MONI_IF.bvalid && `MONI_IF.bready) begin
        tx.resp = resp_t'(`MONI_IF.bresp);

        tx_t = new tx;
        custom_ap.write(tx);
        //axi_common::mon2cov.put(tx_t);   //Put it into mailbox
        //axi_common::mon2ref.put(tx_t);   //Put it into mailbox
        tx = new();
      end





      if(`MONI_IF.arvalid && `MONI_IF.arready) begin
        tx = new();
        tx.addr = `MONI_IF.araddr; 
        tx.wr_rd = READ;
        tx.len= `MONI_IF.arlen;
        tx.brust_size= brust_size_t'(`MONI_IF.arsize);
        tx.id= `MONI_IF.arid;
        tx.brust_type=brust_type_t'(`MONI_IF.arbrust);
        tx.lock= lock_t'(`MONI_IF.arlock);
        tx.prot= `MONI_IF.arprot;
        tx.cache = `MONI_IF.arcache;

      end

      if(`MONI_IF.rvalid && `MONI_IF.rready) begin
        tx.dataQ.push_back(`MONI_IF.rdata);
        tx.resp = resp_t'(`MONI_IF.rresp);
        tx.id = `MONI_IF.rid;

        if(`MONI_IF.rlast == 1) begin 

          //tx.print("axi_rd_tx");

          tx_t = new tx;
          `uvm_info(get_type_name(), $sformatf("Packet Collected : Read %s", tx.sprint()), UVM_LOW)
          custom_ap.write(tx);
          
          tx = new();
        end;

      end

    end
  endtask

endclass

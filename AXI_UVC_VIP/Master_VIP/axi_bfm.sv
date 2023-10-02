//++++++++++++++++++++++++//
//		 	AXI_BFM		  //
//++++++++++++++++++++++++//

`define DRIV_IF vif.DRIVER.drv_cb


class axi_bfm extends uvm_driver #(axi_tx);

  `uvm_component_utils(axi_bfm)

  function new(string name = "axi_bfm", uvm_component parent);
    super.new(name, parent);
  endfunction


  axi_tx tx;
  virtual axi_intf vif;
  //integer delay;

  integer wr_delay;


  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    

    uvm_config_db #(virtual axi_intf)::get(this, "", "pif", vif);

  endfunction

  task run_phase(uvm_phase phase);

  //fork 
    forever begin
        seq_item_port.get_next_item(req);

        fork 
          drive_tx(req);    
          `uvm_info(get_type_name(), $sformatf("DRIVER : Packet Sent :\n%s", req.sprint()), UVM_LOW)
        join_none
        #req.packet_delay;

        seq_item_port.item_done();
    end
  //join
  endtask


  task drive_tx(axi_tx tx);

    case(tx.wr_rd)
      1: begin
        write_addr_phase(tx);
        write_data_phase(tx);
        write_resp_phase(tx);
      end
      0: begin
        read_addr_phase(tx);
        read_data_phase(tx);
      end
    endcase

  endtask

  task write_addr_phase(axi_tx tx);
    `uvm_info(get_type_name(), "WRITE_ADDR_PHASE", UVM_MEDIUM)
    
    // At positive edge of clk
    @(posedge vif.DRIVER.aclk);
    `DRIV_IF.awid <= tx.id;
    `DRIV_IF.awaddr <= tx.addr;
    `DRIV_IF.awlen <= tx.len;
    `DRIV_IF.awsize <= tx.brust_size;
    `DRIV_IF.awbrust <= tx.brust_type;
    `DRIV_IF.awlock <= tx.lock;
    `DRIV_IF.awcache <= tx.cache;
    `DRIV_IF.awprot <= tx.prot;
    `DRIV_IF.awqos <= 1'b0;
    `DRIV_IF.awregion <= 1'b0;
    `DRIV_IF.awvalid <= 1'b1;

    // ready I will get as input
    wait(`DRIV_IF.awready == 1);


    @(posedge vif.DRIVER.aclk);
    `DRIV_IF.awvalid <= 1'b0;
    `DRIV_IF.awid <= 0;
    `DRIV_IF.awaddr <= 0;
    `DRIV_IF.awlen <= 0;
    `DRIV_IF.awsize <= 0;
    `DRIV_IF.awbrust <= 0;
    `DRIV_IF.awlock <= 0;
    `DRIV_IF.awcache <= 0;
    `DRIV_IF.awprot <= 0;
    `DRIV_IF.awqos <= 1'b0;
  endtask

  task write_data_phase(axi_tx tx);

    `uvm_info(get_type_name(), "WRITE_DATA_PHASE", UVM_MEDIUM)

    for (int i=0;i<=tx.len;i++) begin

      // At posedge of aclk
      @(posedge vif.DRIVER.aclk);
      `DRIV_IF.wdata <= tx.dataQ.pop_front();
      `DRIV_IF.wid <= tx.id;
      `DRIV_IF.wstrb <= 4'hF;
      // if last data then put 1
      `DRIV_IF.wlast <= (i == tx.len) ? 1 : 0;
      `DRIV_IF.wvalid <= 1'b1;

      // I will receive wready as input
      wait (`DRIV_IF.wready == 1);
    end


    @(posedge vif.DRIVER.aclk);
    `DRIV_IF.wdata <= 0;
    `DRIV_IF.wid <= 0;
    `DRIV_IF.wstrb <= 0;
    `DRIV_IF.wlast <= 0;
    `DRIV_IF.wvalid <= 0;

    wr_delay = $urandom_range(50, 200);
    #wr_delay;
  endtask

  task write_resp_phase(axi_tx tx);
    `uvm_info(get_type_name(), "WRITE_RESP_PHASE", UVM_MEDIUM)
    
    // slave initiates transaction
    while (`DRIV_IF.bvalid == 0) begin
      @(posedge vif.DRIVER.aclk);
      `DRIV_IF.bready <= 1;
    end
    @(posedge vif.DRIVER.aclk); begin
      `DRIV_IF.bready <= 0;
    end
  endtask

  task read_addr_phase(axi_tx tx);
    `uvm_info(get_type_name(), "READ_ADDR_PHASE", UVM_MEDIUM)
    
    @(posedge vif.DRIVER.aclk);
    `DRIV_IF.arid <= tx.id;
    `DRIV_IF.araddr <= tx.addr;
    `DRIV_IF.arlen <= tx.len;
    `DRIV_IF.arsize <= tx.brust_size;
    `DRIV_IF.arbrust <= tx.brust_type;
    `DRIV_IF.arlock <= tx.lock;
    `DRIV_IF.arcache <= tx.cache;
    `DRIV_IF.arprot <= tx.prot;
    `DRIV_IF.arqos <= 1'b0;
    `DRIV_IF.arregion <= 1'b0;
    `DRIV_IF.arvalid <= 1'b1;

    // ready I will get as input
    wait(`DRIV_IF.arready == 1);


    @(posedge vif.DRIVER.aclk);
    `DRIV_IF.arvalid <= 1'b0;
    `DRIV_IF.arid <= 0;
    `DRIV_IF.araddr <= 0;
    `DRIV_IF.arlen <= 0;
    `DRIV_IF.arsize <= 0;
    `DRIV_IF.arbrust <= 0;
    `DRIV_IF.arlock <= 0;
    `DRIV_IF.arcache <= 0;
    `DRIV_IF.arprot <= 0;
  endtask

  task read_data_phase(axi_tx tx);
    `uvm_info(get_type_name(), "READ_DATA_PHASE", UVM_MEDIUM)
    
    tx.dataQ.delete(); // As randomized data, delee it before start storing

    for (int i=0;i<=tx.len;i++) begin


      // While rvalid it will wait for next positive edge of clock
      while(`DRIV_IF.rvalid == 0) begin
        @(posedge vif.DRIVER.aclk);
      end                 // when rvalid 1, master is giving valid data


      `DRIV_IF.rready <= 1'b1;      
      tx.dataQ.push_back(`DRIV_IF.rdata);

      @(posedge vif.DRIVER.aclk);   // wait for one edge of clock
      `DRIV_IF.rready <= 1'b0;      // drop ready signal
    end

  endtask


endclass

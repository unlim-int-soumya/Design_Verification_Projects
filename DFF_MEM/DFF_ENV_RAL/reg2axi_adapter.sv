class reg_axi_adapter extends uvm_reg_adapter;
  `uvm_object_utils(reg_axi_adapter)
  
  function new(string name = "reg_axi_adapter");
    super.new(name);
  endfunction
  
  virtual function uvm_sequence_item reg2bus (const ref uvm_reg_bus_op r_w);
    seq_item bus_item = seq_item::type_id::create("bus_item");
    bus_item.addr = r_w.addr;
    bus_item.data = r_w.data;
    bus_item.rw = (r_w.kind == UVM_READ) ? 0: 1;
    
    `uvm_info(get_type_name, $sformatf("\nreg2bus: addr = %0h, data = %0h, rw = %0h", bus_item.addr, bus_item.data, bus_item.rw), UVM_LOW);
    return bus_item;
  endfunction
  
  virtual function void bus2reg (uvm_sequence_item bus_item, ref uvm_reg_bus_op r_w);
    seq_item bus_pkt;
    if(!$cast(bus_pkt, bus_item))
      `uvm_fatal(get_type_name(), "Failed to cast bus_item transaction")

    r_w.addr = bus_pkt.addr;
    r_w.data = bus_pkt.data;
    r_w.kind = (!bus_pkt.rw) ? UVM_READ: UVM_WRITE;
  endfunction
  
  
endclass
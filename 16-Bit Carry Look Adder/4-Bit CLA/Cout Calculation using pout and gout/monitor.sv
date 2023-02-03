class monitor extends uvm_monitor;

  `uvm_component_utils(monitor)

  Item item;
  
  function new(string name = "monitor", uvm_component parent = null);
    super.new(name, parent);
    item = new();
  endfunction

  virtual des_if vif;
  uvm_analysis_port #(Item) mon_analysis_port;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db #(virtual des_if)::get(this,"", "des_if", vif))
      `uvm_fatal("MON", $sformatf("Could not get vif"))

    mon_analysis_port = new("mon_analysis_port", this);
     //Item item = Item::type_id::create("item");
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      //wait(!vif.rstn);
      @(vif.cb);
          //Item item=Item::type_id::create("item");
          item.gin = vif.gin;
          item.pin = vif.pin;
          item.cin = vif.cin;
    

          item.cout = vif.cout;
          item.pout = vif.pout;
      	item.gout = vif.gout;
      
          mon_analysis_port.write(item);
      `uvm_info("MON", $sformatf("Item sent to SCBD %s",item.convert2str()), UVM_MEDIUM)
    end
  endtask

endclass

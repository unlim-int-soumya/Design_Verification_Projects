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
      wait(!vif.rstn);
      @(vif.cb);
          //Item item=Item::type_id::create("item");
          item.a = vif.a;
          item.b = vif.b; 
          item.cin = vif.cin;
      //@(vif.cb);
          item.sum = vif.sum;
          item.rstn = vif.rstn;
          item.cout = vif.cout;
          //mon_analysis_port.write(item);
          mon_analysis_port.write(item);
          `uvm_info("MON", $sformatf("Saw item %s",item.convert2str()), UVM_HIGH)
    end
  endtask

endclass


// Your code here

class ral_control_reg extends uvm_reg;
  
  rand uvm_reg_field data_bit;
  
  `uvm_object_utils(ral_control_reg)
  function new(string name = "ral_control_reg");
    //super.new(name, 8, build_coverage(UVM_CVR_ALL));
    super.new(name, 8, build_coverage(UVM_NO_COVERAGE));
  endfunction
  
  virtual function void build();
    data_bit = uvm_reg_field::type_id::create("data_bit");
    
    data_bit.configure(this, 8, 0, "RW", 0, 1'b0, 1, 1, 0);

  endfunction
endclass


//----------------------------------------------------------------------

class module_reg extends uvm_reg_block;
  rand ral_control_reg  control_reg[255];

  
  `uvm_object_utils(module_reg)
  function new(string name = "module_reg");
    super.new(name);
  endfunction
  
  virtual function void build();
    
    integer i;
    
      for(i=0; i<255;i=i+1) begin
        control_reg[i] = ral_control_reg::type_id::create();
        control_reg[i].configure(this, null);
        control_reg[i].build(); 
      end
    
   
    
    default_map = create_map("", 0, 1, UVM_LITTLE_ENDIAN, 1);
    

    for(i=0; i<255;i=i+1) begin
        this.default_map.add_reg(control_reg[i],  i, "RW"); 
      end

    
  endfunction
endclass

//----------------------------------------------------------------------
//----------------------------------------------------------------------

// Top Level class: SFR Reg Model
class RegModel_SFR extends uvm_reg_block;
  rand module_reg mod_reg;
  
  uvm_reg_map axi_map;
  `uvm_object_utils(RegModel_SFR)
  
  function new(string name = "RegModel_SFR");
    //super.new(name, .has_coverage(UVM_CVR_ALL));
    super.new(name, .has_coverage(UVM_NO_COVERAGE));
  endfunction
  
  virtual function void build();
    default_map = create_map("axi_map", 0, 1, UVM_LITTLE_ENDIAN, 0);
   
    mod_reg = module_reg::type_id::create("mod_reg");
    mod_reg.configure(this);
    mod_reg.build();
    default_map.add_submap(this.mod_reg.default_map, 0);
  endfunction
endclass
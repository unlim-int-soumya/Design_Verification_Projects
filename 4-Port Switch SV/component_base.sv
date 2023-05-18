class component_base;

  protected string name;

  component_base parent;

  function new(string name, component_base parent);
    this.name = name;
    this.parent = parent;

    //$display("Component_base created");

  endfunction

  virtual function string pathname();
    component_base ptr =  this;
    pathname = name;
    while(ptr.parent != null) begin
      ptr = ptr.parent;
      pathname = {ptr.name, ".", pathname};
    end


  endfunction: pathname

  
  virtual function string getname();
    return name;
  endfunction

  virtual function void myprint();
    $display("@ %0s", this.pathname());
  endfunction

endclass
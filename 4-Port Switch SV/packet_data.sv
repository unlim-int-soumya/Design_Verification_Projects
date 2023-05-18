// Follow instructions in lab book

// add print and type policies here


typedef enum { ANY, SINGLE, MULTICAST, BROADCAST } p_type;

// Worked
//typedef enum { any, single, multicast, broadcast } p_type;

typedef enum { HEX, DEC, BIN } pp_t;


// packet class
class packet;

  local string name;
  //local string name;
  rand bit [3:0] target;
  bit [3:0] source;		//Source set via constructor so no need to be randomized
  rand bit [7:0] data;	

  // add properties here
  
  //MISTAKE WAS HERE
  //rand p_type ptype;
  p_type ptype;
  
  //constraint pt_const {ptype inside {SINGLE, MULTICAST, BROADCAST};}

  // add constructor to set instance name and source by arguments and packet type

  function new(string name, int idt);

    // this written as name is declared as local
    this.name = name;

    // for source, ptype cases this not required as they aren't local
    source = 1 << idt;

    ptype = ANY;

  endfunction

  // target cannot be zero
  constraint target_zero {target != 0;}


  // source and target bit can't be same
  constraint same_bit { 
    (source & target) == 0;
  } 
  
  //constraint pte {ptype != ANY;};


  // Add a method gettype()
  function string gettype();
    return ptype.name();
  endfunction

  // Add a method getname()
  function string getname();
    return name;
  endfunction  


  // add print with policy

  function void print(input pp_t pp = HEX);

    // Display the string Data
    $display("name %s", name);

    // Display Numerical Data
    case(pp)
      HEX: $display("source %0h, target %0h, data %0h", source, target, data);
      DEC: $display("source %0d, target %0d, data %0h", source, target, data);
      BIN: $display("source %0b, target %0b, data %0b", source, target, data);
    endcase

    $display("ptype %s", gettype());

  endfunction

endclass




class psingle extends packet;

  function new(string name, int idt);
    super.new(name, idt);
    ptype = SINGLE;
  endfunction

  constraint s_const {target inside {1,2,4,8};}

endclass



class pmulticast extends packet;

  function new(string name, int idt);
    super.new(name, idt);
    ptype = MULTICAST;
  endfunction

  constraint m_const {target inside {3,[5:7],[9:14]};}

endclass

class pbroadcast extends packet;

  function new(string name, int idt);
    super.new(name, idt);
    ptype = BROADCAST;
  endfunction 

  constraint b_const {target == 4'b1111;}

  // broadcast same bit can be 1
  constraint same_bit { 
    //(source & target) != 0;
  } 

endclass
//++++++++++++++++++++++++//
//		 	AXI_TX		  //
//++++++++++++++++++++++++//

class axi_tx extends uvm_sequence_item;

  rand bit [31:0]addr; //
  rand bit [31:0]dataQ[$];
  rand bit [3:0]len;
  rand wr_rd_t wr_rd;
  rand brust_size_t brust_size;
  rand bit [3:0] id;
  rand brust_type_t brust_type;
  rand lock_t lock;
  rand bit [2:0] prot;
  rand bit [3:0] cache;
  rand resp_t resp;
  
  rand int packet_delay;

  `uvm_object_utils_begin(axi_tx)
  `uvm_field_int(addr, UVM_ALL_ON)
  `uvm_field_int(len, UVM_ALL_ON)
  `uvm_field_int(id, UVM_ALL_ON)
  `uvm_field_int(prot, UVM_ALL_ON)
  `uvm_field_int(cache, UVM_ALL_ON)

  `uvm_field_enum(wr_rd_t, wr_rd, UVM_ALL_ON)
  `uvm_field_enum(brust_size_t, brust_size, UVM_ALL_ON)
  `uvm_field_enum(brust_type_t, brust_type, UVM_ALL_ON)
  `uvm_field_enum(lock_t, lock, UVM_ALL_ON)
  `uvm_field_enum(resp_t, resp, UVM_ALL_ON)

  `uvm_field_sarray_int(dataQ, UVM_ALL_ON)

  `uvm_field_int(packet_delay, UVM_ALL_ON)

  `uvm_object_utils_end
  
    // Define control knobs
  function new(string name = "axi_tx");
    super.new(name);
  endfunction


  constraint pkt_dly {
      packet_delay >= 50;

      packet_delay <= 150;
    }


  // Size of data beats
  constraint dataq_c{dataQ.size()==len+1;}

  // Brust can't be Reserved
  // Lock can't be reserved
  constraint rsvd_c {
    brust_type != RSVD_BRUSTT;
    lock != RSVD_LOCKT;
  }

  // Initially, the transactions generated in such a way that 
  // They would hold the below values
  constraint soft_c {
    soft resp == OKAY;
    soft brust_size == 2;
    soft brust_type == INCR;
    soft prot == 3'b0;
    soft cache == 4'b0;
    soft lock == NORMAL;
    soft addr % 4 == 0; //addr aligned to 4 bytes boudary
  }

endclass

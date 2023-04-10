class scoreboard extends uvm_scoreboard;

  `uvm_component_utils(scoreboard)

  function new(string name = "scoreboard", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  bit ref_out;
  uvm_analysis_imp #(Item, scoreboard) m_analysis_imp;
  virtual des_if vif;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(virtual des_if)::get(this, "", "des_if", vif))
      `uvm_info("SCBD", $sformatf("Couldn't get vif"), UVM_HIGH)

    m_analysis_imp = new("m_analysis_imp", this);
  endfunction

  virtual function void write(Item item);
    
    if(!item.rstn) begin
        ref_out = 0;
      end else begin
        case(item.sel)
          4'b0000: ref_out = item.in[0];
          4'b0001: ref_out = item.in[1];
          4'b0010: ref_out = item.in[2];
          4'b0011: ref_out = item.in[3];
          4'b0100: ref_out = item.in[4];
          4'b0101: ref_out = item.in[5];
          4'b0110: ref_out = item.in[6];
          4'b0111: ref_out = item.in[7];
          4'b1000: ref_out = item.in[8];
          4'b1001: ref_out = item.in[9];
          4'b1010: ref_out = item.in[10];
          4'b1011: ref_out = item.in[11];
          4'b1100: ref_out = item.in[12];
          4'b1101: ref_out = item.in[13];
          4'b1110: ref_out = item.in[14];
          4'b1111: ref_out = item.in[15];
          default: ref_out = 0;
        endcase
      end
    
    //Output matching
    if(item.out!=ref_out)
      `uvm_error("SCBD", $sformatf("FAIL! OUT not matched item.sel=%0b item.in=%0b item.rstn=%0b item.out=%0b ref_out=%0b", item.sel, item.in, item.rstn, item.out, ref_out))
      else
        `uvm_info("SCBD", $sformatf("PASS! COUT matched item.sel=%0b item.in=%0b item.rstn=%0b item.out=%0b item.out=%0b", item.sel, item.in, item.rstn, item.out, ref_out), UVM_HIGH)

        endfunction

endclass

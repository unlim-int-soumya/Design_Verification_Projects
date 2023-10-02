`include "uvm_macros.svh"
`include "axi_common.sv"

package axi_pkg;

import uvm_pkg::*;

import axi_common::*;


`include "axi_tx.sv"

`include "axi_seq.sv"
`include "axi_sqr.sv"
`include "axi_bfm.sv"
`include "axi_mon.sv"
`include "axi_agent.sv"
`include "axi_scoreboard.sv"
`include "axi_cov.sv"
`include "axi_env.sv"

endpackage

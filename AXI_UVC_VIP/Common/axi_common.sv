`ifndef __AXI_COMMON__
`define __AXI_COMMON__

package axi_common;

`define WDATA_SIZE 4  //bytes

typedef enum bit {
  READ,
  WRITE
} wr_rd_t;

typedef enum bit[2:0] {
  BRUST_SIZE_1_BYTE,
  BRUST_SIZE_2_BYTE,
  BRUST_SIZE_4_BYTE,
  BRUST_SIZE_16_BYTE,
  BRUST_SIZE_32_BYTE,
  BRUST_SIZE_64_BYTE,
  BRUST_SIZE_128_BYTE
} brust_size_t;

typedef enum bit [1:0] {
  FIXED = 2'b00,
  INCR,
  WRAP,
  RSVD_BRUSTT
} brust_type_t;

typedef enum bit [1:0] {
  NORMAL = 2'b00,
  EXCLUSIVE,
  LOCKED,
  RSVD_LOCKT
} lock_t;
typedef enum bit [1:0] {
  OKAY = 2'b00,
  EXOKAY,
  SLVERR,
  DECERR
} resp_t;

typedef enum bit [1:0] {
  LOW = 2'b00,
  MEDIUM = 2'b01,
  HIGH,
  DEBUG
} verb_t;

endpackage

`endif
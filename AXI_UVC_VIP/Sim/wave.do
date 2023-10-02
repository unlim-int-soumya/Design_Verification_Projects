onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/pif/aclk
add wave -noupdate /top/pif/arst
add wave -noupdate -group WR_ADDR_CH /top/pif/awid
add wave -noupdate -group WR_ADDR_CH /top/pif/awaddr
add wave -noupdate -group WR_ADDR_CH /top/pif/awlen
add wave -noupdate -group WR_ADDR_CH /top/pif/awsize
add wave -noupdate -group WR_ADDR_CH /top/pif/awbrust
add wave -noupdate -group WR_ADDR_CH /top/pif/awlock
add wave -noupdate -group WR_ADDR_CH /top/pif/awcache
add wave -noupdate -group WR_ADDR_CH /top/pif/awprot
add wave -noupdate -group WR_ADDR_CH /top/pif/awqos
add wave -noupdate -group WR_ADDR_CH /top/pif/awregion
add wave -noupdate -group WR_ADDR_CH /top/pif/awuser
add wave -noupdate -group WR_ADDR_CH /top/pif/awvalid
add wave -noupdate -group WR_ADDR_CH /top/pif/awready
add wave -noupdate -group WR_DATA_CH /top/pif/wid
add wave -noupdate -group WR_DATA_CH /top/pif/wdata
add wave -noupdate -group WR_DATA_CH /top/pif/wstrb
add wave -noupdate -group WR_DATA_CH /top/pif/wlast
add wave -noupdate -group WR_DATA_CH /top/pif/wuser
add wave -noupdate -group WR_DATA_CH /top/pif/wvalid
add wave -noupdate -group WR_DATA_CH /top/pif/wready
add wave -noupdate -group WR_RESP_CH /top/pif/bid
add wave -noupdate -group WR_RESP_CH /top/pif/bresp
add wave -noupdate -group WR_RESP_CH /top/pif/buser
add wave -noupdate -group WR_RESP_CH /top/pif/bvalid
add wave -noupdate -group WR_RESP_CH /top/pif/bready
add wave -noupdate -group RD_ADDR_CH /top/pif/arid
add wave -noupdate -group RD_ADDR_CH /top/pif/araddr
add wave -noupdate -group RD_ADDR_CH /top/pif/arlen
add wave -noupdate -group RD_ADDR_CH /top/pif/arsize
add wave -noupdate -group RD_ADDR_CH /top/pif/arbrust
add wave -noupdate -group RD_ADDR_CH /top/pif/arlock
add wave -noupdate -group RD_ADDR_CH /top/pif/arcache
add wave -noupdate -group RD_ADDR_CH /top/pif/arprot
add wave -noupdate -group RD_ADDR_CH /top/pif/arqos
add wave -noupdate -group RD_ADDR_CH /top/pif/arregion
add wave -noupdate -group RD_ADDR_CH /top/pif/aruser
add wave -noupdate -group RD_ADDR_CH /top/pif/arvalid
add wave -noupdate -group RD_ADDR_CH /top/pif/arready
add wave -noupdate -expand -group RD_DATA_CH /top/pif/rid
add wave -noupdate -expand -group RD_DATA_CH /top/pif/rdata
add wave -noupdate -expand -group RD_DATA_CH /top/pif/rlast
add wave -noupdate -expand -group RD_DATA_CH /top/pif/ruser
add wave -noupdate -expand -group RD_DATA_CH /top/pif/rvalid
add wave -noupdate -expand -group RD_DATA_CH /top/pif/rready
add wave -noupdate -expand -group RD_DATA_CH /top/pif/rresp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1465 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {1202 ns} {1728 ns}

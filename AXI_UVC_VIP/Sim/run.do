vlog ../Common/axi_pkg.sv ../Top/axi_top.sv +incdir+../Top/axi_top.sv +incdir+../Master_VIP +incdir+../Slave_VIP +incdir+../Common

variable time [format "%s" [clock format [clock seconds] -format %Y-%m-%d_%H-%M-%S]]
set testname axi_5_test
set log_f "$testname\_$time.log"
vsim -novopt top +testname=axi_5_test -l $log_f
do wave.do
run -all

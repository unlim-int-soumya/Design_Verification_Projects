vlog ../design/lc4_pipeline.v ../sim/testbench.sv +incdir+../common +incdir+../design/include +incdir+../design +incdir+../env +incdir+../design +incdir+../test_data

variable time [format "%s" [clock format [clock seconds] -format %Y-%m-%d_%H-%M-%S]]

set testname lc4_5_test
set log_f "$testname\_$time.log"
vsim -novopt tb_top +testname=lc4_5_test -l $log_f
do wave.do
run -all

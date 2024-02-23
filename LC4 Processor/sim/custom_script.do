vlog ../design/lc4_pipeline.v ../sim/testbench.sv +incdir+common +incdir+design/include +incdir+design +incdir+env +incdir+design +incdir+test_data
variable time [format "%s" [clock format [clock seconds] -format %Y-%m-%d_%H-%M-%S]]
set testname store_load_no_depen_test
set log_f "$testname\_$time.log"
vsim -novopt tb_top +TEST_CASE=store_load_no_depen_test -l $log_f
add wave /tb_top/pif/*
run -all
vlog testbench.sv -l comp_run.log
vsim -novopt top +testname=test_wr_rd -l sim_run.log
#vsim -novopt top +testname=test_wr -l sim_run.log
#vsim -novopt top +testname=test_rd -l sim_run.log
add wave sim:/top/dut/*
run -all

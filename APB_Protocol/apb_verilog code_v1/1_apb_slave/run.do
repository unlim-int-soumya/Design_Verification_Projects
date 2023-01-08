vlog testbench.v -l comp_run.log
vsim -novopt top -l sim_run.log
add wave sim:/top/dut/*
run -all

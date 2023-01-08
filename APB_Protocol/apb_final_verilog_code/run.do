vlog testbench.v 
#vsim -novopt top +testname=wr_rd
vsim -novopt top +testname=wr_followed_by_rd
#vsim -novopt top +testname=write
#vsim -novopt top +testname=read
add wave sim:/top/*
run -all

# custom-script.py

import os
import subprocess
import sys  # Make sure to import the sys module

# Get the directory of the script
script_directory = os.path.dirname(os.path.abspath(__file__))

# Change to the script directory
os.chdir(script_directory)

# Set the root directory
root_directory = r'C:\questasim64_10.6c\lc4_pipeline'

# Command line arguments
if len(sys.argv) < 2:
    print("Usage: python custom-script.py <test_case_name>")
    sys.exit(1)

test_case_name = sys.argv[1]

# QuestaSim command to compile and simulate
compile_cmd = 'vlog ../design/lc4_pipeline.v ../sim/testbench.sv +incdir+common +incdir+design/include +incdir+design +incdir+env +incdir+design +incdir+test_data'

# QuestaSim script commands
time_cmd = 'variable time [format "%s" [clock format [clock seconds] -format %Y-%m-%d_%H-%M-%S]]'
testname_cmd = f'set testname {test_case_name}'
log_cmd = r'set log_f "$testname\_$time.log"'
vsim_cmd = f'vsim -novopt tb_top +TEST_CASE={test_case_name} -l $log_f'  # Pass the test case name as a plusarg

# Waveform commands
wave_cmd = 'add wave /tb_top/pif/*'

# Run command
run_cmd = 'run -all'

# Combine all commands into a single string
questasim_script = f"{compile_cmd}\n{time_cmd}\n{testname_cmd}\n{log_cmd}\n{vsim_cmd}\n{wave_cmd}\n{run_cmd}"

# Save the QuestaSim script to a file named custom_script.do
script_file_path = os.path.join(root_directory, 'sim', 'custom_script.do')
with open(script_file_path, 'w') as script_file:
    script_file.write(questasim_script)

# Open QuestaSim terminal and execute the script
subprocess.Popen(['vsim', '-do', script_file_path], shell=True)

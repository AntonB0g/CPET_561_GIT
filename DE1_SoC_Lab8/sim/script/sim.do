vlib work
vcom -93 -work work ../../src/low_pass_filter.vhd
vocm -93 -work work ../../src/clkDelay.vhd
vcom -93 -work work ../src/low_pass_filter_tb.vhd
vsim -voptargs=+acc -msgmode both low_pass_filter_tb
do wave.do
run 10 ms

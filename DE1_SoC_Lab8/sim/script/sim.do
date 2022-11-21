vlib work
vcom -93 -work work ../../src/low_pass_filter.vhd
vcom -93 -work work ../../src/clkDelay.vhd
vcom -93 -work work ../../hw/multiplier.vhd
vcom -93 -work work ../src/low_pass_filter_tb.vhd
vsim -voptargs=+acc -msgmode both low_pass_filter_tb
do wave.do
run 20000 ns

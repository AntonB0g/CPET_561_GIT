vlib work
vcom -93 -work work ../../src/audio_filter.vhd
vcom -93 -work work ../../src/clkDelay.vhd
vcom -93 -work work ../../src/multiplier.vhd
vcom -93 -work work ../src/audio_filter_tb.vhd
vsim -voptargs=+acc -msgmode both audio_filter_tb
do wave.do
run 20000 ns

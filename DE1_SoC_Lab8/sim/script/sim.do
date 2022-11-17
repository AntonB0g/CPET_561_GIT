vlib work
vcom -93 -quiet -work work ../src/raminfr_be.vhd
vcom -93 -quiet -work work ../src/raminfr_be_tb2.vhd
vsim -voptargs=+acc -msgmode both raminfr_be_tb
do wave.do
run -all

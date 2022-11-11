vlib work
vcom -93 -work work ../../src/Embedded_memory.vhd
vcom -93 -work work ../src/memory_tb.vhd
vsim -voptargs=+acc -msgmode both memory_tb
run 10 ms

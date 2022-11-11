vlib work
vcom -93 -work work ../../src/ServoController.vhd
vcom -93 -work work ../src/ServoController_tb.vhd
vsim -voptargs=+acc -msgmode both ServoController_tb
do wave.do
run -all

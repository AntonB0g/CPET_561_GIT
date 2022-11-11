onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ServoController_tb/clk_tb
add wave -noupdate /ServoController_tb/reset_n_tb
add wave -noupdate /ServoController_tb/write_en_tb
add wave -noupdate /ServoController_tb/writedata_tb
add wave -noupdate /ServoController_tb/address_tb
add wave -noupdate /ServoController_tb/irq_tb
add wave -noupdate /ServoController_tb/pwm_tb
add wave -noupdate -divider UUT
add wave -noupdate /ServoController_tb/UUT/write_en
add wave -noupdate /ServoController_tb/UUT/writedata
add wave -noupdate /ServoController_tb/UUT/address
add wave -noupdate /ServoController_tb/UUT/irq
add wave -noupdate /ServoController_tb/UUT/pwm
add wave -noupdate /ServoController_tb/UUT/State
add wave -noupdate /ServoController_tb/UUT/angle_count
add wave -noupdate /ServoController_tb/UUT/period_count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {50 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 177
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {101 ns} {206 ns}
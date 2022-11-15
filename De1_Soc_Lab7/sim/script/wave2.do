onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /memory_tb/clk_tb
add wave -noupdate /memory_tb/reset_n_tb
add wave -noupdate /memory_tb/address_tb
add wave -noupdate -radix hexadecimal /memory_tb/writedata_tb
add wave -noupdate -radix binary /memory_tb/writebyteenable_n_tb
add wave -noupdate -radix hexadecimal /memory_tb/readdata_tb
add wave -noupdate -radix hexadecimal /memory_tb/expected_value
add wave -noupdate /memory_tb/UUT/RAM0
add wave -noupdate /memory_tb/UUT/RAM1
add wave -noupdate /memory_tb/UUT/RAM2
add wave -noupdate /memory_tb/UUT/RAM3
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {793569513 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {1570490714 ps}

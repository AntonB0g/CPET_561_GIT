onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -divider "TB"
add wave -noupdate -radix binary /audio_filter_tb/clk_tb
add wave -noupdate -radix binary /audio_filter_tb/reset_n_tb
add wave -noupdate -radix hexadecimal /audio_filter_tb/data_in_tb
add wave -noupdate -radix binary /audio_filter_tb/filter_en_tb
add wave -noupdate -radix binary /audio_filter_tb/data_out_tb
add wave -divider "UUT"
add wave -noupdate -radix binary /audio_filter_tb/UUT/clk
add wave -noupdate -radix binary /audio_filter_tb/UUT/reset_n
add wave -noupdate -radix hexadecimal /audio_filter_tb/UUT/data_in
add wave -noupdate -radix hexadecimal /audio_filter_tb/UUT/filter_en
add wave -noupdate -radix binary /audio_filter_tb/UUT/data_out
add wave -noupdate  sim:/audio_filter_tb/UUT/output
add wave -noupdate  sim:/audio_filter_tb/UUT/input_signal
add wave -noupdate  sim:/audio_filter_tb/UUT/res
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
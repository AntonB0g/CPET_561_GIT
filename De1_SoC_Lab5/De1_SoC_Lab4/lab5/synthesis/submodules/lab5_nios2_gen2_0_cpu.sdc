# Legal Notice: (C)2022 Altera Corporation. All rights reserved.  Your
# use of Altera Corporation's design tools, logic functions and other
# software and tools, and its AMPP partner logic functions, and any
# output files any of the foregoing (including device programming or
# simulation files), and any associated documentation or information are
# expressly subject to the terms and conditions of the Altera Program
# License Subscription Agreement or other applicable license agreement,
# including, without limitation, that your use is for the sole purpose
# of programming logic devices manufactured by Altera and sold by Altera
# or its authorized distributors.  Please refer to the applicable
# agreement for further details.

#**************************************************************
# Timequest JTAG clock definition
#   Uncommenting the following lines will define the JTAG
#   clock in TimeQuest Timing Analyzer
#**************************************************************

#create_clock -period 10MHz {altera_reserved_tck}
#set_clock_groups -asynchronous -group {altera_reserved_tck}

#**************************************************************
# Set TCL Path Variables 
#**************************************************************

set 	lab5_nios2_gen2_0_cpu 	lab5_nios2_gen2_0_cpu:*
set 	lab5_nios2_gen2_0_cpu_oci 	lab5_nios2_gen2_0_cpu_nios2_oci:the_lab5_nios2_gen2_0_cpu_nios2_oci
set 	lab5_nios2_gen2_0_cpu_oci_break 	lab5_nios2_gen2_0_cpu_nios2_oci_break:the_lab5_nios2_gen2_0_cpu_nios2_oci_break
set 	lab5_nios2_gen2_0_cpu_ocimem 	lab5_nios2_gen2_0_cpu_nios2_ocimem:the_lab5_nios2_gen2_0_cpu_nios2_ocimem
set 	lab5_nios2_gen2_0_cpu_oci_debug 	lab5_nios2_gen2_0_cpu_nios2_oci_debug:the_lab5_nios2_gen2_0_cpu_nios2_oci_debug
set 	lab5_nios2_gen2_0_cpu_wrapper 	lab5_nios2_gen2_0_cpu_debug_slave_wrapper:the_lab5_nios2_gen2_0_cpu_debug_slave_wrapper
set 	lab5_nios2_gen2_0_cpu_jtag_tck 	lab5_nios2_gen2_0_cpu_debug_slave_tck:the_lab5_nios2_gen2_0_cpu_debug_slave_tck
set 	lab5_nios2_gen2_0_cpu_jtag_sysclk 	lab5_nios2_gen2_0_cpu_debug_slave_sysclk:the_lab5_nios2_gen2_0_cpu_debug_slave_sysclk
set 	lab5_nios2_gen2_0_cpu_oci_path 	 [format "%s|%s" $lab5_nios2_gen2_0_cpu $lab5_nios2_gen2_0_cpu_oci]
set 	lab5_nios2_gen2_0_cpu_oci_break_path 	 [format "%s|%s" $lab5_nios2_gen2_0_cpu_oci_path $lab5_nios2_gen2_0_cpu_oci_break]
set 	lab5_nios2_gen2_0_cpu_ocimem_path 	 [format "%s|%s" $lab5_nios2_gen2_0_cpu_oci_path $lab5_nios2_gen2_0_cpu_ocimem]
set 	lab5_nios2_gen2_0_cpu_oci_debug_path 	 [format "%s|%s" $lab5_nios2_gen2_0_cpu_oci_path $lab5_nios2_gen2_0_cpu_oci_debug]
set 	lab5_nios2_gen2_0_cpu_jtag_tck_path 	 [format "%s|%s|%s" $lab5_nios2_gen2_0_cpu_oci_path $lab5_nios2_gen2_0_cpu_wrapper $lab5_nios2_gen2_0_cpu_jtag_tck]
set 	lab5_nios2_gen2_0_cpu_jtag_sysclk_path 	 [format "%s|%s|%s" $lab5_nios2_gen2_0_cpu_oci_path $lab5_nios2_gen2_0_cpu_wrapper $lab5_nios2_gen2_0_cpu_jtag_sysclk]
set 	lab5_nios2_gen2_0_cpu_jtag_sr 	 [format "%s|*sr" $lab5_nios2_gen2_0_cpu_jtag_tck_path]

#**************************************************************
# Set False Paths
#**************************************************************

set_false_path -from [get_keepers *$lab5_nios2_gen2_0_cpu_oci_break_path|break_readreg*] -to [get_keepers *$lab5_nios2_gen2_0_cpu_jtag_sr*]
set_false_path -from [get_keepers *$lab5_nios2_gen2_0_cpu_oci_debug_path|*resetlatch]     -to [get_keepers *$lab5_nios2_gen2_0_cpu_jtag_sr[33]]
set_false_path -from [get_keepers *$lab5_nios2_gen2_0_cpu_oci_debug_path|monitor_ready]  -to [get_keepers *$lab5_nios2_gen2_0_cpu_jtag_sr[0]]
set_false_path -from [get_keepers *$lab5_nios2_gen2_0_cpu_oci_debug_path|monitor_error]  -to [get_keepers *$lab5_nios2_gen2_0_cpu_jtag_sr[34]]
set_false_path -from [get_keepers *$lab5_nios2_gen2_0_cpu_ocimem_path|*MonDReg*] -to [get_keepers *$lab5_nios2_gen2_0_cpu_jtag_sr*]
set_false_path -from *$lab5_nios2_gen2_0_cpu_jtag_sr*    -to *$lab5_nios2_gen2_0_cpu_jtag_sysclk_path|*jdo*
set_false_path -from sld_hub:*|irf_reg* -to *$lab5_nios2_gen2_0_cpu_jtag_sysclk_path|ir*
set_false_path -from sld_hub:*|sld_shadow_jsm:shadow_jsm|state[1] -to *$lab5_nios2_gen2_0_cpu_oci_debug_path|monitor_go

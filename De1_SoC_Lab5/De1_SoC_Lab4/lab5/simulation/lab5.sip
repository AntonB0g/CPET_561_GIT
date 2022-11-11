set_global_assignment -entity "lab5" -library "lib_lab5" -name IP_TOOL_NAME "Qsys"
set_global_assignment -entity "lab5" -library "lib_lab5" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "lab5" -library "lib_lab5" -name IP_TOOL_ENV "Qsys"
set_global_assignment -library "lib_lab5" -name SPD_FILE [file join $::quartus(sip_path) "../lab5.spd"]
set_global_assignment -library "lib_lab5" -name MISC_FILE [file join $::quartus(sip_path) "../../lab5.qsys"]

set_global_assignment -library "lib_lab5" -name MISC_FILE [file join $::quartus(sip_path) "lab5.vhd"]
set_global_assignment -library "lib_lab5" -name MISC_FILE [file join $::quartus(sip_path) "submodules/lab5_pushbuttons.vhd"]
set_global_assignment -library "lib_lab5" -name MISC_FILE [file join $::quartus(sip_path) "submodules/lab5_onchip_memory2_0.hex"]
set_global_assignment -library "lib_lab5" -name MISC_FILE [file join $::quartus(sip_path) "submodules/lab5_onchip_memory2_0.vhd"]
set_global_assignment -library "lib_lab5" -name MISC_FILE [file join $::quartus(sip_path) "submodules/lab5_nios2_gen2_0.v"]
set_global_assignment -library "lib_lab5" -name MISC_FILE [file join $::quartus(sip_path) "submodules/lab5_jtag_uart_0.vhd"]
set_global_assignment -library "lib_lab5" -name MISC_FILE [file join $::quartus(sip_path) "submodules/lab5_hex0.vhd"]

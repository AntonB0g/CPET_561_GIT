
module nios_system (
	clk_clk,
	reset_reset_n,
	switches_export,
	hex_export,
	pushbuttons_export);	

	input		clk_clk;
	input		reset_reset_n;
	input	[7:0]	switches_export;
	output	[6:0]	hex_export;
	input	[3:0]	pushbuttons_export;
endmodule

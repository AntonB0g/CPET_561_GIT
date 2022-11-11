
module lab5 (
	clk_clk,
	conduit_end_writeresponsevalid_n,
	hex0_export,
	hex1_export,
	hex2_export,
	hex4_export,
	hex5_export,
	pushbuttons_export,
	reset_reset_n,
	switches_export);	

	input		clk_clk;
	output		conduit_end_writeresponsevalid_n;
	output	[6:0]	hex0_export;
	output	[6:0]	hex1_export;
	output	[6:0]	hex2_export;
	output	[6:0]	hex4_export;
	output	[6:0]	hex5_export;
	input	[3:0]	pushbuttons_export;
	input		reset_reset_n;
	input	[7:0]	switches_export;
endmodule

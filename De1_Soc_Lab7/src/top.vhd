--*****************************************************************************
--***************************  VHDL Source Code  ******************************
--*****************************************************************************
--
--  DESIGNER NAME:  Anton Bogovik
--
--       LAB NAME:  Lab7: Memory Lab
--
--      FILE NAME:  top.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--    The technical objective of this laboratory is to use the Component Editor in the QSYS to add custom IP to 
--a Nios II system. The custom IP being added is a RAM module that will utilize the Cyclone V FPGA block 
--RAM. A RAM confidence test, which can be used for board debug, will be developed. The RAM test will 
--run continuously until the user presses KEY1 on the DE1-SoC board, thus generating an interrupt that will 
--terminate the test. 
--
--  REVISION HISTORY
--
--  _______________________________________________________________________
-- |  DATE    | USER | Ver |  Description                                  |
-- |==========+======+=====+================================================
-- |          |      |     |
-- | 11/09/22 | xxx  | 1.0 | Created
-- |          |      |     |
--
--*****************************************************************************
--*****************************************************************************
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY top IS
  PORT(
    CLOCK_50 : IN  std_logic;
    KEY      : IN  std_logic;
    --
    LEDR     : OUT std_logic_vector(7 DOWNTO 0)
    );
END ENTITY top;

ARCHITECTURE arch OF top IS

COMPONENT nios_system_inst IS
		PORT(
			clk_clk            : IN  std_logic                    := 'X';
			leds_export        : OUT std_logic_vector(7 DOWNTO 0);      
			pushbuttons_export : IN  std_logic                    := 'X';
			reset_reset_n      : IN  std_logic                    := 'X'
		);
	END COMPONENT nios_system_inst;
	
	SIGNAL key0_d1 : std_logic;
	SIGNAL key0_d2 : std_logic;
	SIGNAL key0_d3 : std_logic;
	SIGNAL reset_n : std_logic;

BEGIN
	synch_Reses: PROCESS (CLOCK_50) 
	BEGIN
		IF (rising_edge(CLOCK_50)) THEN
			key0_d1 <= KEY;
			key0_d2 <= key0_d1;
			key0_d3 <= key0_d2;
		END IF;
	END PROCESS synch_Reses;
  
   reset_n <= key0_d3;

	top_inst : COMPONENT nios_system_inst
		PORT MAP(
			-- former signals  => inst signals (TOP)
			clk_clk            => CLOCK_50, -- clk.clk
			leds_export        => LEDR,     -- leds.export
			pushbuttons_export => KEY,      -- pushbuttons.export
			reset_reset_n      => reset_n   -- reset.reset_n
		);
END arch;

--*****************************************************************************
--***************************  VHDL Source Code  ******************************
--*****************************************************************************
--
--  DESIGNER NAME:  Anton Bogovik
--
--       LAB NAME:  Custom_Memory_IP
--
--      FILE NAME:  top.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--    This file is a used for compiling file in Quartus so the ENTITY 
--    signals names match the DE1-SOC board pins file names. 
--
--  REVISION HISTORY
--
--  _______________________________________________________________________
-- |  DATE    | USER | Ver |  Description                                  |
-- |==========+======+=====+================================================
-- |          |      |     |
-- | 10/28/22 | xxx  | 1.0 | Created
-- |          |      |     |
--
--*****************************************************************************
--*****************************************************************************
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY top IS
  PORT (
    CLOCK_50 : IN  std_logic;
    KEY      : IN  std_logic;
    --
    LEDR     : OUT std_logic_vector(7 DOWNTO 0)
    );
END ENTITY top;

ARCHITECTURE arch OF top IS

	component nios_system_inst is
		port (
			clk_clk            : in  std_logic                    := 'X';
			leds_export        : out std_logic_vector(7 downto 0);        
			pushbuttons_export : in  std_logic                    := 'X'; 
			reset_reset_n      : in  std_logic                    := 'X'
		);
	end component nios_system_inst;
	
	signal key0_d1 : std_logic;
	signal key0_d2 : std_logic;
	signal key0_d3 : std_logic;
	signal reset_n : std_logic;

BEGIN

  synch_Reses: process (CLOCK_50) begin
    if (rising_edge(CLOCK_50)) then
      key0_d1 <= KEY;
      key0_d2 <= key0_d1;
      key0_d3 <= key0_d2;
    end if;
  end process synch_Reses;
  
  reset_n <= key0_d3;

	top_inst : component nios_system_inst
		port map (
			-- former signals  => inst signals (TOP)
			clk_clk            => CLOCK_50, -- clk.clk
			leds_export        => LEDR,     -- leds.export
			pushbuttons_export => KEY,      -- pushbuttons.export
			reset_reset_n      => reset_n   -- reset.reset_n
		);


END arch;

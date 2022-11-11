--*****************************************************************************
--***************************  VHDL Source Code  ******************************
--*****************************************************************************
--
--  DESIGNER NAME:  Anton Bogovik
--
--       LAB NAME:  Custom_Memory_IP
--
--      FILE NAME:  custom_mem_ip.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--
--    This design will <insert detailed description of design>. 
--
--
-------------------------------------------------------------------------------
--
--  REVISION HISTORY
--
--  _______________________________________________________________________
-- |  DATE    | USER | Ver |  Description                                  |
-- |==========+======+=====+================================================
-- |          |      |     |
-- | 10/27/22 | XXX  | 1.0 | Created
-- |          |      |     |
--
--*****************************************************************************
--*****************************************************************************

------------------------------------------------------------------------------
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
-- ||||                                                                   ||||
-- ||||                    COMPONENT PACKAGE                              ||||
-- ||||                                                                   ||||
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.ALL;
------------------------------------------------------------------------------
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
-- |||| 
-- |||| COMPONENT DESCRIPTION 
-- |||| 
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
------------------------------------------------------------------------------
ENTITY raminfr IS
 PORT(
	clk : IN std_logic;
	reset_n : IN std_logic;
	write_n : IN std_logic;
	address : IN std_logic_vector(11 DOWNTO 0);
	writedata : IN std_logic_vector(31 DOWNTO 0);
	--
	readdata : OUT std_logic_vector(31 DOWNTO 0)
	);
END ENTITY raminfr;

ARCHITECTURE rtl OF raminfr IS
 
 TYPE ram_type IS ARRAY (4095 DOWNTO 0) OF std_logic_vector (31 DOWNTO 0);
 SIGNAL RAM : ram_type;
 SIGNAL read_addr : std_logic_vector(11 DOWNTO 0);
 
BEGIN
	RamBlock : PROCESS(clk)
	BEGIN
	IF (clk'event AND clk = '1') THEN
		IF (reset_n = '0') THEN
			read_addr <= (OTHERS => '0'); 
		ELSIF (write_n = '0') THEN
			RAM(conv_integer(address)) <= writedata;
		END IF;
	read_addr <= address;
	END IF;
	END PROCESS RamBlock;
 
	readdata <= RAM(conv_integer(read_addr));
END ARCHITECTURE rtl;

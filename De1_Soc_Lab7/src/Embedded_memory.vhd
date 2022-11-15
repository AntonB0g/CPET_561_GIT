--*****************************************************************************
--***************************  VHDL Source Code  ******************************
--*****************************************************************************
--
--  DESIGNER NAME:  Anton Bogovik
--
--       LAB NAME:  Embedded Memory
--
--      FILE NAME:  custom_embedded_mem.vhd
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
ENTITY raminfr_be IS
 PORT(
	clk               : IN std_logic;
	reset_n           : IN std_logic;
	address           : IN std_logic_vector (11 DOWNTO 0);
	writedata         : IN std_logic_vector (31 DOWNTO 0);
	writebyteenable_n : IN std_logic_vector (3 downto 0);
	-- outputs --
	readdata          : OUT std_logic_vector (31 DOWNTO 0)
	);
END ENTITY raminfr_be;

ARCHITECTURE rtl OF raminfr_be IS
 
 TYPE ram_type IS ARRAY (4095 DOWNTO 0) OF std_logic_vector (7 DOWNTO 0);
 SIGNAL RAM0 : ram_type;
 SIGNAL RAM1 : ram_type;
 SIGNAL RAM2 : ram_type;
 SIGNAL RAM3 : ram_type;
 SIGNAL read_addr : std_logic_vector(11 DOWNTO 0);
 
BEGIN
	RamBlock0 : PROCESS(clk)
	BEGIN
	IF (clk'event AND clk = '1') THEN
		IF (reset_n = '0') THEN
			read_addr <= (OTHERS => '0'); 
		ELSIF (writebyteenable_n(0) = '0') THEN
			RAM0(conv_integer(address)) <= writedata(7 downto 0);
		END IF;
	read_addr <= address;
	END IF;
	END PROCESS RamBlock0;
	
	RamBlock1 : PROCESS(clk)
	BEGIN
	IF (clk'event AND clk = '1') THEN
		IF (writebyteenable_n(1) = '0') THEN
			RAM1(conv_integer(address)) <= writedata(15 downto 8);
		END IF;
	END IF;
	END PROCESS RamBlock1;
	
	RamBlock2 : PROCESS(clk)
	BEGIN
	IF (clk'event AND clk = '1') THEN
		IF (writebyteenable_n(2) = '0') THEN
			RAM2(conv_integer(address)) <= writedata(23 downto 16);
		END IF;
	END IF;
	END PROCESS RamBlock2;
	
	RamBlock3 : PROCESS(clk)
	BEGIN
	IF (clk'event AND clk = '1') THEN
		IF (writebyteenable_n(3) = '0') THEN
			RAM3(conv_integer(address)) <= writedata(31 downto 24);
		END IF;
	END IF;
	END PROCESS RamBlock3;
	-- I am not sure if this is the right way to do it, but it does not work. What is the purpose of the read_addr?
	readdata <= RAM3(conv_integer(read_addr)) & RAM2(conv_integer(read_addr)) & RAM1(conv_integer(read_addr)) & RAM0(conv_integer(read_addr));
END ARCHITECTURE rtl;

--*****************************************************************************
--***************************  VHDL Source Code  ******************************
--*****************************************************************************
--
--  DESIGNER NAME: Anton Bogovik
--
--       LAB NAME:  lab7; Embedded memory test bench
--
--      FILE NAME:  memory_tb.vhd
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
-- | 08/23/20 | XXX  | 1.0 | Created
-- |          |      |     |
--
--*****************************************************************************
--*****************************************************************************
-------------------------------------------------------------------------------

-- include ieee packages here
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.math_real.ALL;

ENTITY memory_tb IS
END ENTITY memory_tb;
-------------------------------------------------------------------------------

ARCHITECTURE test OF memory_tb IS
	COMPONENT raminfr_be is
	PORT(
		clk               : IN std_logic;
		reset_n           : IN std_logic;
		address           : IN std_logic_vector (11 DOWNTO 0);
		writedata         : IN std_logic_vector (31 DOWNTO 0);
		writebyteenable_n : IN std_logic_vector (3 downto 0);
		-- outputs --
		readdata          : OUT std_logic_vector(31 DOWNTO 0)
		);
    END COMPONENT;

	--CONSTANTS--
	constant period : time := 20 ns; 
    ---------------------------------------------------------------------------
    -- define sigals that you will need to test UUT
    ---------------------------------------------------------------------------
    SIGNAL clk_tb               : std_logic:= '0';
	SIGNAL reset_n_tb           : std_logic:= '0';
	SIGNAL address_tb           : std_logic_vector (11 DOWNTO 0)  := (others => 'X');
	SIGNAL writedata_tb         : std_logic_vector (31 DOWNTO 0)  := X"12345678";
	SIGNAL writebyteenable_n_tb : std_logic_vector (3 downto 0)   := (others => 'X');
	SIGNAL readdata_tb          : std_logic_vector (31 downto 0)  := (others => '0');
	SIGNAL WORD                 : std_logic_vector (31 downto 0)  := X"12345678";
	SIGNAL HALF_WORD1           : std_logic_vector (31 downto 0)  := X"11110000"; -- UPPER Half word
	SIGNAL HALF_WORD2           : std_logic_vector (31 downto 0)  := X"00001111"; -- LOWER Half word
	SIGNAL BYTE0                : std_logic_vector (31 downto 0)  := X"34567812";
	SIGNAL BYTE1                : std_logic_vector (31 downto 0)  := X"56781234";
	SIGNAL BYTE2                : std_logic_vector (31 downto 0)  := X"78123456";
	SIGNAL BYTE3                : std_logic_vector (31 downto 0)  := X"12345678";
	SIGNAL expected_value       : std_logic_vector (31 downto 0)  := (others => '0');
	
BEGIN  -- test
    ---------------------------------------------------------------------------
    -- instantiate the unit under test (UUT)
    ---------------------------------------------------------------------------
    UUT : raminfr_be 
		PORT MAP(        
        -- <connect UUT I/O to testbench signals>
        -- <format: component signal => tb signal> 
		clk      => clk_tb,
		reset_n  => reset_n_tb,
		address  => address_tb,
		writedata => writedata_tb,
		writebyteenable_n => writebyteenable_n_tb,
		readdata => readdata_tb
        );

	-- clock process
	clock: PROCESS
		BEGIN
			clk_tb <= not clk_tb;
			WAIT FOR period/2;
	END PROCESS; 
	
	async_reset: process
		begin
			wait for 2 * period;
			reset_n_tb <= '1';
		wait; -- waits forever
	end process; 
    ---------------------------------------------------------------------------
    -- the process will apply the test vectors to the UUT
    ---------------------------------------------------------------------------
    stimulus : PROCESS
    BEGIN  -- PROCESS stimulus
		wait for 4 * period;
		writebyteenable_n_tb <= "0000";
		FOR i IN 0 TO 4095 LOOP
			address_tb <= std_logic_vector(to_unsigned(i,12));
			expected_value <= WORD;
			wait for 10 ns;
			WORD_test: assert (readdata_tb = writedata_tb) report "wrong data LOL"; --error
			wait for period;
		END LOOP;

		writedata_tb(7 downto 0) <= writedata_tb(31 downto 24);
		writedata_tb(31 downto 8) <= writedata_tb(23 downto 0);
		writebyteenable_n_tb <= "1110";
		FOR i in 0 to 4095 LOOP
			address_tb <= std_logic_vector(to_unsigned(i,12));
			expected_value <= BYTE0;
			wait for 10 ns;
			LOWEST_BYTE0_test : assert (readdata_tb = expected_value) report "wrong data LOL"; --error
			wait for period;
		END LOOP;
		
		writedata_tb(7 downto 0) <= writedata_tb(31 downto 24);
		writedata_tb(31 downto 8) <= writedata_tb(23 downto 0);
		writebyteenable_n_tb <= "1101";
		FOR i in 0 to 4095 LOOP
			address_tb <= std_logic_vector(to_unsigned(i,12));
			expected_value <= BYTE1;
			wait for 10 ns;
			BYTE1_test : assert (readdata_tb = expected_value) report "wrong data LOL"; --error
			wait for period;
		END LOOP;
		
		writedata_tb(7 downto 0) <= writedata_tb(31 downto 24);
		writedata_tb(31 downto 8) <= writedata_tb(23 downto 0);
		writebyteenable_n_tb <= "1011";
		FOR i in 0 to 4095 LOOP
			address_tb <= std_logic_vector(to_unsigned(i,12));
			expected_value <= BYTE2;
			wait for 10 ns;
			BYTE2_test : assert (readdata_tb = expected_value) report "wrong data LOL"; --error
			wait for period;
		END LOOP;
		
		writedata_tb(7 downto 0) <= writedata_tb(31 downto 24);
		writedata_tb(31 downto 8) <= writedata_tb(23 downto 0);
		writebyteenable_n_tb <= "0111";
		FOR i in 0 to 4095 LOOP
			address_tb <= std_logic_vector(to_unsigned(i,12));
			expected_value <= BYTE3;
			wait for 10 ns;
			BYTE3_test : assert (readdata_tb = expected_value) report "wrong data LOL"; --error
			wait for period; 
		END LOOP;
		
		writedata_tb <= HALF_WORD1;
		writebyteenable_n_tb <= "0011";
		FOR i in 0 to 4095 LOOP
			address_tb <= std_logic_vector(to_unsigned(i,12));
			expected_value <= HALF_WORD1 ;
			wait for 10 ns;
			UPPER_HALF_WORD_test : assert (readdata_tb = expected_value) report "wrong data LOL"; --error
			wait for period;
		END LOOP;
		
		writedata_tb <= HALF_WORD2;
		writebyteenable_n_tb <= "1100";
		FOR i in 0 to 4095 LOOP
			address_tb <= std_logic_vector(to_unsigned(i,12));
			expected_value <= HALF_WORD1;
			wait for 10 ns;
			LOWER_HALF_WORD_test : assert (readdata_tb = expected_value) report "wrong data LOL"; --error
			wait for period;
		END LOOP;
        -----------------------------------------------------------------------
        -- stop simulation, wait here forever
        -----------------------------------------------------------------------
        wait;
    END PROCESS stimulus;
END ARCHITECTURE test;

-------------------------------------------------------------------------------

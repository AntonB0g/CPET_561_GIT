--*****************************************************************************
--***************************  VHDL Source Code  ******************************
--*****************************************************************************
--
--  DESIGNER NAME:  Anton Bogovik
--
--       LAB NAME:  lab 8 Filters; test bench for Low Pass filter
--
--      FILE NAME:  low_pass_filter_tb.vhd
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
-- | 11/18/22 | XXX  | 1.0 | Created
-- |          |      |     |
--
--*****************************************************************************
--*****************************************************************************
-------------------------------------------------------------------------------
-- include ieee packages here
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_signed.ALL;
USE ieee.numeric_std.ALL;
USE std.textio.all;

ENTITY low_pass_filter_tb IS
END ENTITY low_pass_filter_tb;
-------------------------------------------------------------------------------
ARCHITECTURE test OF low_pass_filter_tb IS
    COMPONENT low_pass_filter is
        port (
            clk : in std_logic; -- CLOCK_50
            reset_n : in std_logic; -- active low reset
            data_in : in std_logic_vector(15 downto 0); --Audio sample, in 16 bit fixed point format (15 bits of assumed decimal)
            filter_en : in std_logic; --This is enables the internal registers and coincides with a new audio sample
            data_out : out std_logic_vector(15 downto 0) --This is the filtered audio signal out, in 16 bit fixed point format
        );
    END COMPONENT;

    --CONSTANTS--
	constant period : time := 20 ns; 
    ---------------------------------------------------------------------------
    -- define sigals that you will need to test UUT
    ---------------------------------------------------------------------------
    SIGNAL clk_tb               : std_logic:= '0';
	SIGNAL reset_n_tb           : std_logic:= '0';
    SIGNAL data_in_tb           : std_logic_vector (15 downto 0)  := (others => '0');
    SIGNAL filter_en_tb         : std_logic:= '0';
    SIGNAL data_out_tb          : std_logic_vector (15 downto 0)  := (others => 'X');
    type audioSampleArray is array (39 downto 0) of signed (15 downto 0);
    -- <define your signals here> 
    
BEGIN  -- test
    ---------------------------------------------------------------------------
    -- instantiate the unit under test (UUT)
    ---------------------------------------------------------------------------
    UUT : low_pass_filter 
    PORT MAP (
        -- <connect UUT I/O to testbench signals>
        -- <format: component signal => tb signal> 
            clk => clk_tb,
            reset_n => reset_n_tb,
            data_in => data_in_tb,
            filter_en => filter_en_tb,
            data_out => data_out_tb
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
    stimulus : process
        file read_file : text open read_mode is "./src/verification_src/one_cycle_integer.csv";
        file results_file : text open write_mode is "./src/verification_src/output_waveform.csv";
        variable lineIn : line;
        variable lineOut : line;
        variable readValue : integer;
        variable writeValue : integer;
       BEGIN
        wait for 100 ns;
        -- Read data from file into an array
        for i in 0 to 39 loop
        readline(read_file, lineIn);
        read(lineIn, readValue);
        audioSampleArray(i) <= to_signed(readValue, 16);
        wait for 50 ns;
        end loop;
        file_close(read_file);
        
        -- Apply the test data and put the result into an output file
        for i in 1 to 10 loop
            for j in 0 to 39 loop
                data_in_tb(j) <= std_logic_vector(audioSampleArray(j));
                filter_en_tb <= '0';
                wait for period;
                filter_en_tb <= '1';
                wait for period;

                -- Read the data from the array and apply it to Data_In
                -- Remember to provide an enable pulse with each new sample
        
                -- Write filter output to file
                writeValue := to_integer(data_out_tb);
                write(lineOut, writeValue);
                writeline(results_file, lineOut);        
            end loop;
        end loop;
        file_close(results_file);
        -- end simulation
        sim_done <= true;
        wait for 100 ns;
        -- last wait statement needs to be here to prevent the process
        -- sequence from restarting at the beginning
        wait;
       end process stimulus;
END ARCHITECTURE test;

-------------------------------------------------------------------------------

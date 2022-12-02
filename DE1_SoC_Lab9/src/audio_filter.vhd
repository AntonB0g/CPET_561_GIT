--*****************************************************************************
--***************************  VHDL Source Code  ******************************
--*****************************************************************************
--
--      DESIGNER NAME:  Anton Bogovik
--
--      LAB NAME:  Lab9: Audio Filters
--
--      FILE NAME:  audio_filter.vhdl
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

------------------------------------------------------------------------------
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
-- ||||                                                                   ||||
-- ||||                    COMPONENT PACKAGE                              ||||
-- ||||                                                                   ||||
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_signed.ALL;
USE ieee.numeric_std.ALL;
------------------------------------------------------------------------------
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
-- ||||                                                                   ||||
-- ||||                            DESCRIPTION                            ||||
-- ||||                                                                   ||||
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
------------------------------------------------------------------------------
entity low_pass_filter is
  port (
        clk : in std_logic; -- CLOCK_50
		    write: in std_logic;
		    address: in std_logic;
        reset_n : in std_logic; -- active low reset
        writedata : in std_logic_vector(15 downto 0); --Audio sample, in 16 bit fixed point format (15 bits of assumed decimal
        data_out : out std_logic_vector(15 downto 0) --This is the filtered audio signal out, in 16 bit fixed point format
  );
  end low_pass_filter;

ARCHITECTURE rtl OF low_pass_filter  IS

COMPONENT multiplier IS
PORT
(
  dataa		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
  datab		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
  --
  result	: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
);
END COMPONENT;

COMPONENT clkDelay IS
PORT
(
  clk        : IN std_logic;
  enable_n   : IN std_logic; -- active high enable
  signal_in  : IN std_logic_vector(15 downto 0);
  --
  signal_out : OUT std_logic_vector(15 downto 0)
);
END COMPONENT;
    ---------------------------------------------------------------------------
    -- define your signals here
    -- format: signal abc : <type>;
    ---------------------------------------------------------------------------
signal output_1: signed (31 downto 0);
signal switch_reg  : std_logic_vector (15 downto 0);
signal write_reg   : std_logic_vector (15 downto 0);
signal filter_en   : std_logic;

type vector17_16 is array (natural range 0 to 16) of std_logic_vector(15 downto 0);
type vector17_32 is array (natural range 0 to 16) of std_logic_vector(31 downto 0);
type vector17_16_s is array (natural range 0 to 16) of signed(15 downto 0);
signal result_signed : vector17_16_s := (others => (others => '0'));
signal input_signal: vector17_16;
signal res: vector17_32;
type coeff_array is array (16 downto 0) of std_logic_vector(15 downto 0);

constant hpf_coeff : coeff_array := (X"003E", X"FF9A", X"FE9E", X"0000", X"0535", X"05B2", X"F5AB", X"DAB6", X"4C91", 
                                    X"DAB6", X"F5AB", X"05B2", X"0535", X"0000", X"FE9E", X"FF9A", X"003E");

constant lpf_coeff : coeff_array := (X"0051", X"00BA", X"01E1", X"0408", X"071A", X"0AAC", X"0E11", X"107F", X"1161",
                                     X"107F", X"0E11", X"0AAC", X"071A", X"0408", X"01E1", X"00BA", X"0051");
signal filter_coeff: coeff_array := (others => (others => '0'));

BEGIN
input_signal(0) <= writedata; -- first set of data (16 bits) is stored in the 0th location of the input_signal array

-- first select the filter based on the switch register and after the filter is selected write the data to the write_reg.
 
Write_Selection: process(clk)
	begin
	if rising_edge(clk) then
			if reset_n = '0' then
				switch_reg <= (others => '0');
				write_reg <=  (others => '0');
			else 
				if write = '1' then
					if address = '0' then
						write_reg <= writedata;
					else
						switch_reg <= writedata;
					end if;
				else
					switch_reg <= switch_reg;
					write_reg <= write_reg;
				end if;
			end if;
	end if;
	end process;

Filter_Selection: process(clk)
  begin
    if rising_edge(clk) then
			if reset_n = '0' then
				filter_coeff <= (others => (others => '0'));
			else
				if (switch_reg = X"0001") then
					filter_coeff <= hpf_coeff;
				elsif (switch_reg = X"0002") then
					filter_coeff <= lpf_coeff;
				else
					filter_coeff <= filter_coeff;
				end if;
			end if;
	end if;
  end process;

Filter_Enable: process(clk)
 begin
 if rising_edge(clk) then
		if reset_n = '0' then
			filter_en <= '0';
		else
			if(address = '0' and write = '1') then
				filter_en <= '1';
			end if;
		end if;
 end if;
end process;
        
Mult_Gen: for i in 0 to 16 generate
      MultX: multiplier 
      PORT MAP
        (dataa => input_signal(i), 
         datab => filter_coeff(i), 
         result => res(i)
        );
        result_signed(i) <= signed(res(i)(30 downto 15)); -- convert the 32 bit result to 16 bit signed result and store it in the result_signed array
  end generate Mult_Gen;

Delay_Gen: for i in 0 to 15 generate
        DelayX: clkDelay 
        PORT MAP
          (clk => clk,
           enable_n => filter_en,
           signal_in => input_signal(i), 
           signal_out => input_signal(i+1) -- the output of the delay is stored in the next location of the input_signal array
          );
  end generate Delay_Gen;

-- the output of the filter is the signed sum of the 17 results from the multipliers implemented ith using the for loop
addition: process(result_signed)
variable result : signed (31 downto 0) := (others => '0');
begin
  result := (others => '0');
  for i in 0 to 16 loop
      result := result + result_signed(i);
  end loop;
  output_1 <= result;
end process addition;
  -- define your equations/design here
data_out <= std_logic_vector(output_1(15 downto 0));
END rtl;
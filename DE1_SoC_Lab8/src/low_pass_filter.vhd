--*****************************************************************************
--***************************  VHDL Source Code  ******************************
--*****************************************************************************
--
--      DESIGNER NAME:  Anton Bogovik
--
--      LAB NAME:  Lab8: Filters
--
--      FILE NAME:  low_pass_filter.vhdl
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
        reset_n : in std_logic; -- active low reset
        data_in : in std_logic_vector(15 downto 0); --Audio sample, in 16 bit fixed point format (15 bits of assumed decimal)
        filter_en : in std_logic; --This is enables the internal registers and coincides with a new audio sample
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
signal output: std_logic_vector (15 downto 0);
type vector17_16 is array (natural range 0 to 16) of std_logic_vector(15 downto 0);
type vector17_32 is array (natural range 0 to 16) of std_logic_vector(31 downto 0);
signal input_signal: vector17_16;
signal res: vector17_32;
type coeff_array is array (16 downto 0) of std_logic_vector(15 downto 0);
constant signal_coeff: coeff_array := (X"0051", X"00BA", X"01E1", X"0408", X"071A", X"0AAC", X"0E11", X"107F",
                                       X"1161", X"107F", X"0E11", X"0AAC", X"071A", X"0408", X"01E1", X"00BA", X"0051");
BEGIN
input_signal(0) <= data_in; -- first set of data (16 bits) is stored in the 0th location of the input_signal array

Mult_Gen: for i in 0 to 16 generate
      MultX: multiplier 
      PORT MAP
        (dataa => input_signal(i), 
         datab => signal_coeff(i), 
         result => res(i)
        );
  end generate Mult_Gen;

Delay_Gen: for i in 0 to 15 generate
        DelayX: clkDelay 
        PORT MAP
          (clk => clk,
           enable_n => filter_en,
           signal_in => input_signal(i), 
           signal_out => input_signal(i+1)
          );
  end generate Delay_Gen;

addition: process(clk, res)
variable result : signed (33 downto 0) := (others => '0');
begin
    for i in 0 to 16 loop
        result := result + signed(res(i)(30 downto 15));
    end loop;
    output <= std_logic_vector(result(15 downto 0));
end process addition;
    ---------------------------------------------------------------------------
    -- define your equations/design here
    ---------------------------------------------------------------------------
  data_out <= output;
END ARCHITECTURE;

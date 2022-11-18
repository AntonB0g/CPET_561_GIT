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
-- | 08/23/20 | XXX  | 1.0 | Created
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
------------------------------------------------------------------------------
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
-- |||| 
-- |||| COMPONENT DESCRIPTION 
-- |||| 
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
  result		: OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
);
END COMPONENT;
    ---------------------------------------------------------------------------
    -- define your signals here
    -- format: signal abc : <type>;
    ---------------------------------------------------------------------------
type vector16 is array (natural range 0 to 15) of std_logic_vector(15 downto 0);
signal inputA: vector16(15 downto 0);
signal inputB: vector16(15 downto 0);
signal result: vector16(31 downto 0);

BEGIN
  Mult_Gen:
    for i in 0 to 15 generate
      MultX: multiplier PORT MAP
        (inputA(i), inputB(i), result(i)); --https://stackoverflow.com/questions/13194450/is-it-possible-to-create-several-instances-of-the-same-component-using-a-loop
  end generate Multiplier_Generator


    ---------------------------------------------------------------------------
    -- define your equations/design here
    ---------------------------------------------------------------------------

END ARCHITECTURE;

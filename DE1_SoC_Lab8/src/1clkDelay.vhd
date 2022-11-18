--*****************************************************************************
--***************************  VHDL Source Code  ******************************
--*****************************************************************************
--
--      DESIGNER NAME:  Anton Bogovik
--
--      LAB NAME:  Lab8: Filters
--
--      FILE NAME:  1clkDelay.vhdl
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--
--    This design will delay a signal for one clock. 
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
------------------------------------------------------------------------------
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
-- |||| 
-- |||| COMPONENT DESCRIPTION 
-- |||| 
-- |||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
------------------------------------------------------------------------------
ENTITY  clkDelay IS
PORT(
    clk      : IN std_logic;
    enbale_n : IN std _logic;
    signal_in: IN std_logic_vector(15 downto 0);
    --
    signal_out : OUT std _logic_vector(15 downto 0)
);
END clkDelay;

ARCHITECTURE rtl of clkDelay IS
BEGIN
    process(clk)
    begin
        if rising_edge(clk) then
            if enable_n = '0' then
                signal_out <= signal_in;
            end if;
        end if;
    end process;
END rtl;

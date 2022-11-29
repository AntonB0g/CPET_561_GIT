--*****************************************************************************
--***************************  VHDL Source Code  ******************************
--*****************************************************************************
--
--  DESIGNER NAME:  <your name here>
--
--       LAB NAME:  <lab # and name here>; test bench
--
--      FILE NAME:  <filename>.vhd
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

-- include your packages here
LIBRARY work;
USE work.<???>_pkg.ALL;


ENTITY tb_name_detector IS

END ENTITY tb_name_detector;

-------------------------------------------------------------------------------

ARCHITECTURE test OF tb_name_detector IS

    ---------------------------------------------------------------------------
    -- define sigals that you will need to test UUT
    ---------------------------------------------------------------------------

    -- <define your signals here> 
    
BEGIN  -- test


    ---------------------------------------------------------------------------
    -- instantiate the unit under test (UUT)
    ---------------------------------------------------------------------------
    UUT : name_detector 
    PORT MAP (
        
        -- <connect UUT I/O to testbench signals>
        -- <format: component signal => tb signal> 
        
        );


    ---------------------------------------------------------------------------
    -- the process will apply the test vectors to the UUT
    ---------------------------------------------------------------------------
    stimulus : PROCESS
    BEGIN  -- PROCESS stimulus


        -- INSERT YOUR TEST VECTORS HERE
        


        -----------------------------------------------------------------------
        -- stop simulation, wait here forever
        -----------------------------------------------------------------------
        wait;
    END PROCESS stimulus;

END ARCHITECTURE test;

-------------------------------------------------------------------------------

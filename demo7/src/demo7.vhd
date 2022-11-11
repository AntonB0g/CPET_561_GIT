-------------------------------------------------------------------------
-- Anton Bogovik 
-- 11/04/2022
-- TIme Quest Demo
-- Design a simple adder on the DE1-SoC that will allow for a deeper 
-- look into timing failures, analysis, and eventually timing closure. 
-------------------------------------------------------------------------

library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY demo7 IS
	PORT(
			clk : in std_logic;  
			a   : in std_logic_vector (15 downto 0);
			b   : in std_logic_vector (15 downto 0);
			-- output --
			result : out std_logic_vector (15 downto 0)
			);
	END ENTITY demo7;
	
ARCHITECTURE rtl of demo7 is
	
	--Signal declaration section --
	SIGNAL a_beh : std_logic_vector (15 downto 0);
	SIGNAL b_beh : std_logic_vector (15 downto 0);
	
	BEGIN
	
	addition : process(clk)
	BEGIN
			if falling_edge(clk) then 
				a_beh <= a;
				b_beh <= b;
				result <= a_beh + b_beh;
			end if;
	END PROCESS;
END ARCHITECTURE rtl;   
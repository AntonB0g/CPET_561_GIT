-------------------------------------------------------------------------
-- Anton Bogovik 
-- 10/11/2022
-- Lab 4 prelab 
-- This is a testbench for the servo HS-311 driver
-------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ServoController_tb is
end ServoController_tb;

architecture rtl of ServoController_tb is
 component ServoController is
	port(
		clk       : in std_logic; 
		reset_n   : in std_logic; -- active low reset
		write_en  : in std_logic; 
		writedata : in std_logic_vector (31 downto 0); 
		address   : in std_logic; 
		--
		irq       : out std_logic;
		pwm       : out std_logic
	);
	end component;
	
	--CONSTANTS--
	constant period : time := 20 ns; 
	
	--SIGNAL DECLARATION--
	signal clk_tb          : std_logic := '0';
	signal reset_n_tb      : std_logic := '0';
	signal write_en_tb     : std_logic := '0';
	signal writedata_tb    : std_logic_vector (31 downto 0) := (others => '0');
	signal address_tb      : std_logic := '0';
	signal irq_tb          : std_logic := '0';
	signal pwm_tb          : std_logic := '0';
	signal min_angle_val   : std_logic_vector (31 downto 0) := x"0000EA60";
	signal max_angle_val   : std_logic_vector (31 downto 0) := x"00015F90";
	
	
	BEGIN
	
	UUT: ServoController
		port map(
			clk       =>  clk_tb, 
			reset_n   =>  reset_n_tb,
			write_en  =>  write_en_tb,
			writedata =>  writedata_tb,
			address   =>  address_tb,
			--  
		    irq       =>  irq_tb,
	        pwm       =>  pwm_tb
	   );
			
	-- clock process
	clock: process
		begin
			clk_tb <= not clk_tb;
			wait for period/2;
	end process; 
 
	-- reset process
	async_reset: process
		begin
			wait for 2 * period;
			reset_n_tb <= '1';
		wait; -- waits forever
	end process; 
	
	Sequencer: process
	begin
		wait until irq_tb  = '1';
		write_en_tb <= '1';	
		address_tb <= '0';
		writedata_tb <= min_angle_val;
				
		wait until irq_tb  = '1';
		write_en_tb <= '1';	
		address_tb <= '1';
		writedata_tb <= max_angle_val;
	end process;
		
	END rtl;
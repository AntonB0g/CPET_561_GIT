-------------------------------------------------------------------------
-- Anton Bogovik 
-- 09/30/2022
-- Lab 4 + Lab 5 
-- This is a driver for a servo HS-311
-------------------------------------------------------------------------

library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

ENTITY ServoController IS
	PORT(
		clk       : in std_logic; 
		reset_n   : in std_logic; -- active low reset
		write_en  : in std_logic; 
		writedata : in std_logic_vector (31 downto 0); 
		address   : in std_logic; 
		--
		irq       : out std_logic;
		pwm       : out std_logic
		);
END ENTITY ServoController;

ARCHITECTURE rtl of ServoController IS
	
	type s_State is (SWEEP_RIGHT, SWEEP_LEFT, INT_RIGHT, INT_LEFT);
	SIGNAL State : s_State; 
	
	SIGNAL angle_count     : std_logic_vector (31 downto 0) := (others => '0');
	SIGNAL min_angle_count : std_logic_vector (31 downto 0) := x"0000C350"; -- 50000 tics ~ 1ms                        
	SIGNAL max_angle_count : std_logic_vector (31 downto 0) := x"000186A0"; -- 100000 tics ~ 2ms
	SIGNAL neut_angle_count: std_logic_vector (31 downto 0) := x"000124F8"; -- 75000 tics ~ 1.5ms
	SIGNAL period_count    : std_logic_vector (31 downto 0) := (others => '0');
	
	--Verification Signals. Comment them when not using.
	
	--SIGNAL write_en        : std_logic := '1';
	--SIGNAL address         : std_logic := '1';
	--SIGNAL writedata       : std_logic_vector (31 downto 0) := x"000186A0";
	
	BEGIN
	
	--This process creates a counter to count up unitl 20 ms. 20 ms update time of the servo.
	PERIOD_COUNTER: process(clk)
	begin
		if rising_edge(clk) then
			if reset_n = '0' then
				period_count <= (others => '0');
			else
				if period_count < x"000F4240" then  -- 20ms
					period_count <= period_count + 1;
				else
					period_count <= (others => '0');
				end if;
			end if;
		end if;
	end process;
	
	
	--This process counts the angle of the servo arm.
	--There are two Angle change states: SWEEP_LEFT, SWEEP_RIGHT.
	--Only in this states angle of the servo can change.
	ANGLE_COUNTER: process(clk)
	begin
		if rising_edge(clk) then
			if reset_n = '0' then
				angle_count <= min_angle_count;
			else
				if period_count = x"00000000" then
					if State = SWEEP_RIGHT then
						angle_count <= std_logic_vector(unsigned(angle_count) + 500);
						
					elsif State = SWEEP_LEFT then
						angle_count <=  std_logic_vector(unsigned(angle_count) - 500);
							
					else
						angle_count <= angle_count;
					
					end if;
				end if;
			end if;
		end if;
						
				
	end process;
	
	-- FSM--
	FSM: process(clk) is
	begin
		if rising_edge(clk) then
			if reset_n = '0' then
				State <= SWEEP_RIGHT;
				irq <= '0';
				
			else
				case (State) is
					when SWEEP_RIGHT =>
						irq <= '0';
						if angle_count >= max_angle_count then
							State <= INT_RIGHT;
						end if;
					
					when INT_RIGHT =>
						irq <= '1';
						if write_en = '1' then
							State <= SWEEP_LEFT;
						end if;
						
					when SWEEP_LEFT =>
						irq <= '0';
						if angle_count <= min_angle_count then
							State <= INT_LEFT;
						end if; 
						
					when INT_LEFT =>
						irq <= '1';
						if write_en = '1' then
							State <= SWEEP_RIGHT;
						
						end if;
				end case;
			end if;
	end if;
	end process;
						
	REG_WRITE: process(clk)
	begin
	if rising_edge(clk) then
			if reset_n = '0' then
				min_angle_count <= x"0000C350";
				max_angle_count <= x"000186A0";
			else 
				if write_en = '1' then
					if address = '0' then
						min_angle_count <= writedata;
				
					else
						max_angle_count <= writedata;
					
					end if;
				end if;
			end if;
	end if;
	end process;

	--This process sets pwm signal to HIGH until period count does not exceed angle_count.
   --Imagine the timeline of period_count (20ms) and angle count as point on this line.
	--This point determines the wavelenght of PWM.
	OUTPUT_WAVE: process(clk)
   begin
	if rising_edge(clk) then
		if reset_n = '0' then 
			pwm <= '0';
		
		else
			pwm <= '0';
			
			if period_count < angle_count then 
				pwm <= '1';
			
			end if;
		end if;
	end if;
	end process;
	
END ARCHITECTURE rtl;   
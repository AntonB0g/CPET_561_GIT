--*****************************************************************************
--***************************  VHDL Source Code  ******************************
--*****************************************************************************
--
--  DESIGNER NAME:  <enter your name here>
--
--       LAB NAME:  Labx: <name of lab>
--
--      FILE NAME:  top.vhd
--
-------------------------------------------------------------------------------
--
--  DESCRIPTION
--    This file is a used for compiling file in Quartus so the ENTITY 
--    signals names match the DE1-SOC board pins file names. 
--
--  REVISION HISTORY
--
--  _______________________________________________________________________
-- |  DATE    | USER | Ver |  Description                                  |
-- |==========+======+=====+================================================
-- |          |      |     |
-- | 08/01/20 | xxx  | 1.0 | Created
-- |          |      |     |
--
--*****************************************************************************
--*****************************************************************************
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;



ENTITY top IS
  PORT (
    CLOCK_50 : IN  std_logic;
    SW       : IN  std_logic_vector(7 DOWNTO 0);
    KEY      : IN  std_logic_vector(3 DOWNTO 0);
    --
    HEX0     : OUT std_logic_vector(6 DOWNTO 0);
    HEX1     : OUT std_logic_vector(6 DOWNTO 0);
    HEX2     : OUT std_logic_vector(6 DOWNTO 0);
	 HEX4     : out std_logic_vector(6 downto 0);
	 HEX5     : out std_logic_vector(6 downto 0);
	 pwm      : out std_logic
    );
END ENTITY top;

ARCHITECTURE arch OF top IS
	component ServoControlle_NIOS2 is
		port (
			clk_clk                          : in  std_logic                    := 'X';             -- clk
			conduit_end_writeresponsevalid_n : out std_logic;                                       -- writeresponsevalid_n
			hex0_export                      : out std_logic_vector(6 downto 0);                    -- export
			hex1_export                      : out std_logic_vector(6 downto 0);                    -- export
			hex2_export                      : out std_logic_vector(6 downto 0);                    -- export
			hex4_export                      : out std_logic_vector(6 downto 0);                    -- export
			hex5_export                      : out std_logic_vector(6 downto 0);                    -- export
			pushbuttons_export               : in  std_logic_vector(3 downto 0) := (others => 'X'); -- export
			reset_reset_n                    : in  std_logic                    := 'X';             -- reset_n
			switches_export                  : in  std_logic_vector(7 downto 0) := (others => 'X')  -- export
		);
	end component ServoControlle_NIOS2;
	
	signal reset_n : std_logic;
	signal key0_d1 : std_logic_vector(3 downto 0);
	signal key0_d2 : std_logic_vector(3 downto 0);
	signal key0_d3 : std_logic_vector(3 downto 0);
	signal sw_d1   : std_logic_vector(7 downto 0);
	signal sw_d2   : std_logic_vector(7 downto 0);



BEGIN
  synch_Reses: process (CLOCK_50) begin
    if (rising_edge(CLOCK_50)) then
      key0_d1 <= KEY;
      key0_d2 <= key0_d1;
      key0_d3 <= key0_d2;
    end if;
  end process synch_Reses;
  
  reset_n <= key0_d3(0);
  
  synch_user_input: process (CLOCK_50) begin
    if (rising_edge(CLOCK_50)) then
      if (reset_n = '0') then
		  sw_d1 <= x"00";        
		  sw_d2 <= x"00";
      else
        sw_d1 <= SW;
        sw_d2 <= sw_d1;
      end if;
    end if;
  end process synch_user_input;

  top_inst : component ServoControlle_NIOS2
		port map (
			clk_clk                          => CLOCK_50,                          --         clk.clk
			conduit_end_writeresponsevalid_n => pwm, -- conduit_end.writeresponsevalid_n
			hex0_export                      => HEX0,                      --        hex0.export
			hex1_export                      => HEX1,                      --        hex1.export
			hex2_export                      => HEX2,                      --        hex2.export
			hex4_export                      => HEX4,                      --        hex4.export
			hex5_export                      => HEX5,                      --        hex5.export
			pushbuttons_export               => key0_d3,               -- pushbuttons.export
			reset_reset_n                    => reset_n,                    --       reset.reset_n
			switches_export                  => sw_d2                   --    switches.export
		);


END ARCHITECTURE arch;

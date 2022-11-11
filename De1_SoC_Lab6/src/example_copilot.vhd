library library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--counter reset when it reaches 87 and pulses counter_done

entity counter is
    port(
        clk : in std_logic;
        reset: in std_logic;
        count_done : out std_logic;
    );
    end entity;

architecture rtl of counter is
    signal counter: integer range 0 to 127;
begin
    process(clk, reset)
    begin
        

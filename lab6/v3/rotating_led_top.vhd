-- file rotating_led_top.vhd
library ieee;
use ieee.std_logic_1164.all;

entity rotating_led_top is 
port(
  clk: in std_logic;
  cw, pa: in std_logic;
  sw : in std_logic_vector(6 downto 0);
  hex0, hex1, hex2, hex3: out std_logic_vector(7 downto 0)
);
end rotating_led_top;

architecture top_arch of rotating_led_top is 
  signal count1_out, count2_out: std_logic;
  signal count3_out: std_logic_vector(2 downto 0);
begin 
-- counter one
  c1_unit: entity work.counter1
  port map(
    clk => clk,
    tick1 => count1_out,
    reset => '0'
  );
  -- counter two
  c2_unit: entity work.counter2
  port map(
    clk => clk,
    reset => '0',
    tick1 => count1_out,
    sp => sw(1 downto 0),
    tick2 => count2_out
  );
--counter three
  c3_unit: entity work.counter3
  port map(
    clk => clk,
    reset => '0',
    tick2 => count2_out,
    cw => sw(2),
    pa => sw(3),
    q => count3_out
  );
-- hex decoder
  d_unit: entity work.decoder
  port map(
    q => count3_out,
    hex0_o => hex0,
    hex1_o => hex1,
    hex2_o => hex2,
    hex3_o => hex3
  );
end top_arch;
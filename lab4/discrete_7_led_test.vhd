--file discrete_7_led_test.vhd
library ieee;
use ieee.std_logic_1164.all;

entity discrete_7_led_test is 
  port (
  sw : in std_logic_vector(9 downto 0); -- 10 switches
  led : out std_logic_vector(9 downto 0); -- 10 led lights
  hex0 : out std_logic_vector(7 downto 0); -- 7 led pins
  hex1 : out std_logic_vector(7 downto 0); -- 7 led pins
  hex4 : out std_logic_vector(7 downto 0); -- 7 led pins
  hex5 : out std_logic_vector(7 downto 0) -- 7 led pins
  );
  end discrete_7_led_test;

architecture struc_arch of discrete_7_led_test is
signal q_out, r_out : std_logic_vector(4 downto 0); --declaring signals to set for q and r
begin
div : entity work.division(process_arch)
  port map (
    y => sw(9 downto 5),  -- sets inputs to switch
    d => sw(4 downto 0),  -- sets inputs to switch
    q => q_out,           -- applies output to hex input
    r => r_out            -- applies remainder to hex input
  );
  
hex4u : entity work.hex_to_sseg(arch)
  port map (
    hex => q_out(3 downto 0),  -- sets quotient to a hex
    dp => '1',
    sseg => hex4              -- for display
  );
  
  
hex5u : entity work.hex_to_sseg(arch)
  port map (
    hex => "000" & q_out(4),  -- sets quotient to a hex
    dp => '1',
    sseg => hex5              -- for display
  );
  
hex0u : entity work.hex_to_sseg(arch)
  port map (
    hex => r_out(3 downto 0),    -- sets quotient to a hex
    dp => '1',
    sseg => hex0                 -- for display
  );
  
hex1u : entity work.hex_to_sseg(arch)

  port map (
    
    hex => "000" & r_out(4),     -- sets quotient to a hex
    dp => '1',
    sseg => hex1                 -- for display
  );
  
  
  
  end struc_arch;
  
  
  

--file discrete_led_test.vhd
library ieee;
use ieee.std_logic_1164.all;

entity discrete_led_test is 
  port (

    sw : in std_logic_vector(9 downto 0); -- 10 switches
    led : out std_logic_vector(9 downto 0) -- 10 led lights
    );
  end discrete_led_test;

architecture struc_arch of discrete_led_test is
begin
div : entity work.division(process_arch)
  port map (
    y => sw(9 downto 5),           --sets input to switch
    d => sw(4 downto 0),           --sets input to switch
    q => led(9 downto 5),          --sets output to LED
    r => led(4 downto 0)           --sets output to LED
  );
  end struc_arch;

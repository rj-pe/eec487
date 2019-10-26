-- file decoder.vhd
library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder is 
port(
  q: in std_logic_vector(2 downto 0);
  hex0_o, hex1_o, hex2_o, hex3_o: out std_logic_vector(7 downto 0)
);
end decoder;

architecture decode_arch of decoder is
begin
with q select
  hex0_o <=
       "10011100" when "011", -- Displays a circle .
       "10100011" when "100",
       "11111111" when others; -- All led's off.
with q select
  hex1_o <=
       "10011100" when "010", -- Displays a circle .
       "10100011" when "101",
       "11111111" when others; -- All led's off.
with q select
  hex2_o <=
       "10011100" when "001", -- Displays a circle .
       "10100011" when "110",
       "11111111" when others; -- All led's off.
with q select
  hex3_o <=
       "10011100" when "000", -- Displays a circle .
       "10100011" when "111",
       "11111111" when others; -- All led's off. 
end decode_arch;

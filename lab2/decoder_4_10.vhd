library ieee;
use ieee.std_logic_1164.all;

entity decoder_4_10 is
  port(
    a : in std_logic_vector(3 downto 0);
    y : out std_logic_vector(9 downto 0)
  );
end decoder_4_10;

architecture cond_arch of decoder_4_10 is
begin
  y <= "0000000000" when (a = "1111") else
       "0000000001" when (a = "0001") else
       "0000000010" when (a = "0010") else
       "0000000100" when (a = "0011") else
       "0000001000" when (a = "0100") else
       "0000010000" when (a = "0101") else
       "0000100000" when (a = "0110") else
       "0001000000" when (a = "0111") else
       "0010000000" when (a = "1000") else
       "0100000000" when (a = "1001") else
       "1000000000";
end cond_arch;

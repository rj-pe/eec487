library ieee;
use ieee.std_logic_1164.all;

entity prio_encoder is
  port(
    r : in std_logic_vector(10 downto 1);
    pcode : out std_logic_vector(4 downto 0)
  );
end prio_encoder;

architecture cond_arch of prio_encoder is
begin
  pcode <= "1010" when (r(10) = '1') else
           "1001" when (r(9) = '1') else
           "1000" when (r(8) = '1') else
           "0111" when (r(7) = '1') else
           "0110" when (r(6) = '1') else
           "0101" when (r(5) = '1') else
           "0100" when (r(4) = '1') else
           "0011" when (r(3) = '1') else
           "0010" when (r(2) = '1') else
           "0001" when (r(1) = '1') else
           "1111";
end cond_arch;

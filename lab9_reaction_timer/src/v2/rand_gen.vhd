-- file rand_gen.vhd
-- generates a number between 1 and seven when enabled
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rand_gen is
port(
  clk, reset : in std_logic;
  enable : in std_logic; 
  rand : out unsigned(2 downto 0)
);
end rand_gen;

architecture arch of rand_gen is
  signal rand_reg, rand_next : unsigned(2 downto 0);
begin
  process(clk, reset)
  begin
    if (reset='1') then
      rand_reg <= (others => '0');
    elsif (clk'event and clk='1') then
      rand_reg <= rand_next;
    end if;
  end process;
  -- output logic
  rand <= rand_reg;
  -- next state logic
  rand_next <=
              rand_reg + 1 when enable='1' else
              rand_reg;
end arch;

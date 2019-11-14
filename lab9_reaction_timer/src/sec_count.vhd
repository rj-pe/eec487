-- file sec_count.vhd
-- counts up to seven seconds with a one second tick
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sec_count is
port(
  clk, reset : in std_logic;
  enable : in std_logic;
  seconds : out unsigned(2 downto 0)
);
end sec_count;

architecture arch of sec_count is
  constant LIMIT : unsigned(29 downto 0) := unsigned(50000000, 30);
  signal sec_reg, sec_next unsigned(2 downto 0);
  signal nsec_reg, nsec_next unsigned(29 downto 0);
begin
  process(clk, reset)
  if(reset='1') then
    sec_reg <= (others => '0');
    nsec_reg <= (others => '0');
  elsif(clk'event and clk='1') then
    sec_reg <= sec_next;
    nsec_reg <= nsec_next;
  end if;
  end process;
  -- output logic
  seconds <= sec_reg;
  -- next state logic
  sec_next <=
              sec_reg + 1 when nsec_reg=LIMIT and enable='1' else
              (others => '0') when enable='0' else --synchronous "reset"
              sec_reg;
  nsec_next <=
              (others => '0') when nsec_reg=LIMIT and enable='1' else
              nsec_reg + 1 when enable='1' else
              (others => '0') when enable='0' else -- synchronous "reset"
              nsec_reg;
end arch;

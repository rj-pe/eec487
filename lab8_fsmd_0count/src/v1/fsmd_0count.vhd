-- file fsmd_0count.vhd
-- circuit counts the number of 0's of an 8-bit input word
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsmd_0count is 
  port(
   clk, reset : in std_logic;
   start      : in std_logic;                  -- one-bit to initialize counting
   a          : in std_logic_vector(7 downto 0);             -- 8-bit input word
   ready      : out std_logic;          -- one-bit status indicating ready state
   count      : out std_logic_vector(3 downto 0)        -- 4-bit # of 0's in `a`
  );
end fsmd_0count;

architecture arch of fsmd_0count is
  signal a_next, a_reg : std_logic_vector(7 downto 0);
  type state_type is (idle, add, shift);
  signal state_reg, state_next : state_type;
  signal n : unsigned(3 downto 0) := "1000";
  signal n_next, n_reg : unsigned(3 downto 0);
  signal count_next, count_reg : unsigned(3 downto 0);

begin
  --count <= "0000";
-- registers
process(clk, reset)
begin
  if (reset='1') then
    state_reg <= idle;
    count_reg <= "0000";
    a_reg <= "00000000";
    n_reg <= "1000";
  elsif (clk'event and clk='1') then
    state_reg <= state_next;
    n_reg <= n_next;
    a_reg <= a_next;
    count_reg <= count_next;
  end if;
end process;
-- combinational circuit
process(state_reg, state_next, a_reg, n_reg, count_reg, n_next, count_next)
  begin  
  a_next <= a_reg;
  n_next <= n_reg;  
  count_next <= count_reg;
  state_next <=  state_reg;
  --ready <= '0';
  case state_reg is
    when idle =>

	n_next <= n;
	count_next <= "0000";
	a_next <= a;
      if(start = '1') then

        if (a(0) = '0') then
          state_next <= add;
      else
        state_next <= shift;
      end if;
      else
        state_next <= idle;
      end if;
      ready <= '1';
    when add =>
      count_next <= count_reg + 1;
      state_next <= shift;
    when shift =>

      n_next <= n_reg - 1;
      a_next <= '0' & a_reg(7 downto 1);
      if (n_next = "0000") then
        state_next <= idle;
      elsif (a_next(0) = '0') then
        state_next <= add;
      else
        state_next <= shift;
      end if;
  end case;
end process;  
count <= std_logic_vector(count_next);
end arch;

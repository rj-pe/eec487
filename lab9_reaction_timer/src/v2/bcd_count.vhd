-- file bcd_count.vhd
-- 3 digit bcd counter with 1 ms tick

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_count is
port(
  clk, reset : in std_logic;
  enable : in std_logic;
  syn_reset : in std_logic; -- (on reset output "000")
  --output
  count : out std_logic_vector(11 downto 0)
);
end bcd_count;

architecture arch of bcd_count is
constant MS : unsigned(16 downto 0) := to_unsigned(50000, 17);
signal dig0_reg, dig0_next : unsigned(3 downto 0);
signal dig1_reg, dig1_next : unsigned(3 downto 0);
signal dig2_reg, dig2_next : unsigned(3 downto 0);
signal ms_reg, ms_next : unsigned(16 downto 0);
signal ms_tick : std_logic;
begin

process(clk, reset)
begin
  if(reset='1') then
    dig0_reg <= (others => '0');
	 dig1_reg <= (others => '0');
	 dig2_reg <= (others => '0');
	 ms_reg <= (others => '0');
  elsif(clk'event and clk='1') then
    dig0_reg <= dig0_next;
    dig1_reg <= dig1_next;
    dig2_reg <= dig2_next;
	 ms_reg <= ms_next;
  end if;
end process;

--ms_tick
ms_tick <= '1' when ms_reg=MS else '0';
--ms counter
ms_next <= ms_reg + 1 when enable='1' and syn_reset='0' else
           (others => '0') when syn_reset='1' or ms_reg=MS else
			  ms_reg;

-- next state
dig0_next <= dig0_reg + 1 when enable='1' and ms_tick = '1' else
             (others => '0') when syn_reset='1' or dig0_reg = 9 else
		       dig0_reg;
				 
dig1_next <= dig1_reg + 1 when enable='1' and dig0_next = 9 and ms_tick = '1' else
             (others => '0') when syn_reset='1' or dig1_reg = 9 else
		       dig1_reg;
				 
dig2_next <= dig2_reg + 1 when enable='1' and dig1_next = 9 and dig0_next = 9 and ms_tick = '1' else
             (others => '0') when syn_reset='1' or dig2_reg = 9 else
		       dig2_reg;
				 
-- output logic
count <= std_logic_vector(dig2_reg) & std_logic_vector(dig1_reg) & std_logic_vector(dig0_reg);
end arch;
library ieee;
use ieee.std_logic_1164.all;

entity bcd_inc is
  port(
    b2, b1, b0 : in std_logic_vector(3 downto 0);
    y2, y1, y0 : out std_logic_vector(3 downto 0)
  );
end bcd_inc;

architecture sop_arch of bcd_inc is
  signal c0, c1, c2, overflow : std_logic;
begin
  bid0_unit : entity work.bcd_inc_digit_one(sop)
    port map(a => b0, z => y0, cin => '0', cout => c0);
  bid1_unit : entity work.bcd_inc_digit(sop)
    port map(a => b1, z => y1, cin => c0, cout => c1);
  bid2_unit : entity work.bcd_inc_digit(sop)
    port map(a => b2, z => y2, cin => c1, cout => overflow);
end sop_arch;

architecture rtl_arch of bcd_inc is
  signal c0, c1, c2, overflow : std_logic;
begin
  bid0_unit : entity work.bcd_inc_digit_one(rtl_arch)
    port map(a => b0, z => y0, cin => '0', cout => c0);
  bid1_unit : entity work.bcd_inc_digit(rtl_arch)
    port map(a => b1, z => y1, cin => c0, cout => c1);
  bid2_unit : entity work.bcd_inc_digit(rtl_arch)
    port map(a => b2, z => y2, cin => c1, cout => overflow);
end rtl_arch;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_inc_digit is
  port(
    cin : in std_logic;
    cout : out std_logic;
    a : in std_logic_vector(3 downto 0);
    z : out std_logic_vector(3 downto 0)
  );
end bcd_inc_digit;

architecture sop of bcd_inc_digit is
begin
  with cin select
    z(0)   <= not a(0) when '1',
              a(0) when others;
  with cin select              
    z(1)   <= ((not a(3) and not a(1) and a(0)) or (not a(3) and a(1) and not a(0))) when '1',
              a(1) when others;
  with cin select            
    z(2)   <= ((a(2) and not a(1)) or (a(2) and not a(0)) or (not a(2) and a(1) and a(0))) when '1',
              a(2) when others;
  with cin select            
    z(3)   <= ((a(3) and not a(1) and not a(0)) or (a(2) and a(1) and a(0))) when '1',
              a(3) when others;
  with cin select            
    cout <= (a(3) and a(0)) when '1',
              '0' when others;
end sop;

architecture rtl_arch of bcd_inc_digit is
begin
  with cin select 
    z <= std_logic_vector(unsigned(a) + 1) when '1',
	       a when others;
  with cin select
    cout <= (a(3) and a(0)) when '1',
             '0' when others;

end rtl_arch;

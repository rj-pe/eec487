library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity bcd_inc_digit_one is
  port(
    cin : in std_logic;
    cout : out std_logic;
    a : in std_logic_vector(3 downto 0); -- input
    z : out std_logic_vector(3 downto 0) -- output
  );
end bcd_inc_digit_one;

architecture sop of bcd_inc_digit_one is
begin
    z(0)   <= ((not cin) and (not a(0))) or (cin and a(0));
    z(1)   <= (((not cin) and ((not a(3)) and (not a(1)) and a(0))) or (cin and (not a(3)) and (not a(1))));
    z(2)   <= ((not cin) and ((a(2) and (not a(1))) or (a(2) and (not a(0))) or ((not a(2) and a(1) and a(0))))) or (cin and ((a(2) and (not a(1))) or ((not a(2)) and a(1))));
    z(3)   <= ((not cin) and ((a(3) and (not a(0))) or (a(2) and a(1) and a(0)))) or (cin and a(2) and a(1));
    cout   <= ((not cin) and a(3) and a(0)) or ( cin and a(3));
end sop;

architecture rtl_arch of bcd_inc_digit_one is
begin
    z    <= "0000" when unsigned(a) >= 9  and cin = '0' else 
            std_logic_vector(unsigned(a) + 1) when cin = '0' else  
            std_logic_vector(unsigned(a) + 2);
    cout <= '1' when a = "1001" else
            '0';
end rtl_arch;
library ieee;
use ieee.std_logic_1164.all;

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
  z(0)   <= ((not cin) and (not a(0))) or (cin and a(0));
  z(1)   <= (((not cin) and ((not a(3)) and (not a(1)) and a(0))) + (cin and (not a(3)) and (not a(1))));
  z(2)   <= ((not cin) and ((a(2) and (not a(1))) + (a(2) and (not a(0))) + ((not a(2) and a(1) and a(0))))) + (cin and ((a(2) and (not a(1))) + ((not a(2)) and a(1))));
  z(3)   <= ((not cin) and ((a(3) and (not a(0))) + (a(2) and a(1) and a(0)))) + (cin and a(2) and a(1));
  cout <= ((not cin) and a(3) and a(0)) + ( cin and a(3));
end sop;

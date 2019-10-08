-- file: division.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity division is
  port(
      y, d : in std_logic_vector(4 downto 0);
      q, r : out std_logic_vector(4 downto 0)
    );
end division;

architecture process_arch of division is
  signal P5, P4, P3, P2, P1, P0 : std_logic_vector(8 downto 0);
  signal D5, D4, D3, D2, D1 : std_logic_vector(8 downto 0);

begin
  D5 <= d & "0000";
  D4 <= "0" & d & "000";
  D3 <= "00" & d & "00";
  D2 <= "000" & d & "0";
  D1 <= "0000" & d;
  P5 <= "0000" & y;
  comp_sub5_unit : entity work.compare_subtract(process_arch)
    port map(P_in => P5, D_in => D5, P_out => P4, q_out => q(4));
  comp_sub4_unit : entity work.compare_subtract(process_arch)
    port map(P_in => P4, D_in => D4, P_out => P3, q_out => q(3));
  comp_sub3_unit : entity work.compare_subtract(process_arch)
    port map(P_in => P3, D_in => D3, P_out => P2, q_out => q(2));
  comp_sub2_unit : entity work.compare_subtract(process_arch)
    port map(P_in => P2, D_in => D2, P_out => P1, q_out => q(1));
  comp_sub1_unit : entity work.compare_subtract(process_arch)
    port map(P_in => P1, D_in => D1, P_out => P0, q_out => q(0));
  r <= P0(4 downto 0);
end process_arch;

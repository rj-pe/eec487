-- file: compare_subtract.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--
entity compare_subtract is
  port(
    P_in, D_in : in std_logic_vector(8 downto 0);
    P_out : out std_logic_vector(8 downto 0);
    q_out : out std_logic
  	);
end compare_subtract;
architecture process_arch of compare_subtract is
begin
  process(P_in, D_in)
  begin
  P_out <= "000000000";
  q_out <= '0';
    if (unsigned(P_in)) >= (unsigned(D_in)) then
      P_out <= std_logic_vector(unsigned(P_in) - unsigned(D_in));
      q_out <= '1';
    else
      P_out <= P_in;
      q_out <= '0';
    end if;
  end process;
end process_arch;

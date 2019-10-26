-- file counter1.vhd
library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter1 is 
  port(
  clk, reset: in std_logic;     --input
  tick1: out std_logic          --output
  );
end counter1;

architecture syn_arch of counter1 is 
  constant th : unsigned := "1001100010010110100000";
  signal f1_tick, f1_next: unsigned(21 downto 0);
  begin
  process(clk, reset)
  begin
  --reset factor
    if (reset = '1') then
      f1_tick <= (others => '0');
  -- clock factor
    elsif (clk'event and clk = '1') then  
      f1_tick <= f1_next;
    end if;
  end process;
  -- next state
  f1_next <=  (others => '0') when f1_tick = th else
              ( f1_tick + 1 );
  --output logic
  tick1 <=  '1' when ( f1_tick = th ) else
            '0';
  
end syn_arch;
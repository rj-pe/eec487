-- file counter2.vhd
library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter2 is     
port(        
clk, reset: in std_logic;        
tick1: in std_logic;        
sp: in std_logic_vector(1 downto 0);        
tick2: out std_logic      
); 
end counter2; 
architecture count_arch of counter2 is 
  signal th : unsigned(4 downto 0);
  signal f2_reg, f2_next: unsigned(4 downto 0);
  begin
  -- control speed signal
  with sp select th <=     -- comparator/ mux select
    "00010" when "00",  
    "00100" when "01",            
    "01000" when "10",            
    "10000" when others;
  
  -- register
  process(clk, reset)
  begin
  -- put reset factor here
    if (reset = '1') then
      f2_reg <= (others => '0');
  -- clock factor
    elsif (clk'event and clk = '1' and tick1 = '1') then  
      f2_reg <= f2_next;
    end if;
  end process;

  -- next state
  f2_next <= 
              (others => '0') when ( f2_reg = th ) else
              --(others => '0') when ( f2_reg = th and (tick1 = '1') ) else
              --( f2_reg + 1 ) when tick1 = '1' else
              ( f2_reg + 1 );
  --output logic
  tick2 <= '1' when ( f2_reg = th ) else
           '0';
end count_arch;

-- file counter3.vhd
library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity counter3 is    
port(       
clk, reset: in std_logic;       
tick2, cw, pa: in std_logic;       
q: out std_logic_vector(2 downto 0)     
); 
end counter3; 
 
 architecture count_arch of counter3 is 
  signal th : unsigned(2 downto 0);
  signal t_reg, t_next: unsigned(2 downto 0);
  signal go : std_logic_vector(1 downto 0);
  begin

  -- mux for limit of counter based on cw
  th <= "111" when cw = '1' else
        "000";
  --go <= tick2 & pa;

-- register
  process(clk, reset)
  begin
  --reset factor
    if (reset = '1') then
      t_reg <= (others => '0');
  -- clock factor
    elsif (clk'event and clk = '1' and tick2 = '1') then  
      t_reg <= t_next;
    end if;
  end process;

  -- next state logic
  -- clockwise and counterclockwise decision making
  t_next <= 
        ( t_reg + 1 ) when pa = '0' and cw = '1' else
        ( t_reg - 1 ) when pa = '0' and cw = '0' and t_reg /= "000" else
        "111" when pa = '0' and cw = '0' and t_reg = "000" else
        t_reg;

  --output logic
  q <= std_logic_vector( t_reg );
end count_arch;

library ieee;
use ieee.std_logic_1164.all;
entity bcd_inc_tb is
end bcd_inc_tb;

architecture tb_arch of bcd_inc_tb is
   signal b2, b1, b0: std_logic_vector(3 downto 0);
   signal y2, y1, y0: std_logic_vector(3 downto 0) ;
begin
   -- instantiate the circuit under test
   uut : entity work.bcd_inc(rtl_arch) 
      port map(
         b2 => b2, b1 => b1, b0 => b0,
         y2 => y2, y1 => y1, y0 => y0
      );
   -- test vector generator
   process
   begin
      -- test vector 1:  000
      b2 <= "0000"; 
      b1 <= "0000"; 
      b0 <= "0000"; 
      wait for 200 ns;
      -- test vector 2:  123
      b2 <= "0001"; 
      b1 <= "0010"; 
      b0 <= "0011"; 
      wait for 200 ns;
      -- test vector 3:  678
      b2 <= "0110"; 
      b1 <= "0111"; 
      b0 <= "1000"; 
      wait for 200 ns;
      -- test vector 4:  679
      b2 <= "0110"; 
      b1 <= "0111"; 
      b0 <= "1001"; 
      wait for 200 ns;
      -- test vector 5:  699
      b2 <= "0110"; 
      b1 <= "1001";
      b0 <= "1001"; 
      wait for 200 ns;
      -- test vector 6:  999
      b2 <= "1001"; 
      b1 <= "1001";
      b0 <= "1001"; 
      wait for 200 ns;
      -- terminate simulation
      assert false
         report "Simulation Completed"
         severity failure;
   end process;
end tb_arch;
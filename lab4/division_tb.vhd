library ieee;
use ieee.std_logic_1164.all;
entity divison_tb is
end divison_tb;

architecture tb_arch of divison_tb is
   signal y, d: std_logic_vector(4 downto 0);
   signal q, r: std_logic_vector(4 downto 0) ;
begin
   -- instantiate the circuit under test
   uut : entity work.division(process_arch) 
      port map(
         y => y, d => d, 
         q => q, r => r
      );
   -- test vector generator
   process
   begin
      -- test vector 1:  27/1
      y <= "11011"; 
      d <= "00001"; 
      wait for 200 ns;
      -- test vector 2:  27/0
      y <= "11011"; 
      d <= "00000"; 
     wait for 200 ns;
      -- test vector 3:  1/17
      y <= "00001"; 
      d <= "10001"; 
      wait for 200 ns;
      -- test vector 4:  0/17
      y <= "00000"; 
      d <= "10001"; 
      wait for 200 ns;
      -- test vector 5:  27/3
      y <= "11011"; 
      d <= "00011"; 
      wait for 200 ns;
      -- test vector 6:  27/5
      y <= "11011"; 
      d <= "00101"; 
      wait for 200 ns;
      -- test vector 7:  27/17
      y <= "11011"; 
      d <= "10001"; 
      wait for 200 ns;
      -- test vector 8:  27/27
      y <= "11011"; 
      d <= "11011"; 
      wait for 200 ns;
      -- test vector 9:  27/29
      y <= "11011"; 
      d <= "11101"; 
      wait for 200 ns;
      -- test vector 10: 27/31
      y <= "11011"; 
      d <= "11111"; 
      wait for 200 ns;
      -- terminate simulation
      assert false
         report "Simulation Completed"
         severity failure;
   end process;
end tb_arch;
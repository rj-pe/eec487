library ieee;
use ieee.std_logic_1164.all;
entity enhanced_prio_tb is
end enhanced_prio_tb;

architecture tb_arch of enhanced_prio_tb is
   signal r: std_logic_vector(9 downto 0);
   signal fst, snd: std_logic_vector(3 downto 0) ;
begin
   -- instantiate the circuit under test
   uut : entity work.enhanced_prio(rtl_arch) 
   -- uut : entity work.bcd_inc(structure) 
      port map(
         r => r, fst => fst, snd => snd
      );
   -- test vector generator
   process
   begin
      -- test vector 1
      r <= "0000000000"; 
      wait for 200 ns;
      -- test vector 2
      r <= "0000000100"; 
     wait for 200 ns;
      -- test vector 3
      r <= "0000001001"; 
      wait for 200 ns;
      -- test vector 4
      r <= "0000101001"; 
      wait for 200 ns;
      -- test vector 5
      r <= "0001101001"; 
      wait for 200 ns;
      -- test vector 6
      r <= "1101101001"; 
      wait for 200 ns;
      -- test vector 7
      r <= "1111111111"; 
      wait for 200 ns;
      -- test vector 8
      r <= "1000000000";
      wait for 200 ns;
      -- terminate simulation
      assert false
         report "Simulation Completed"
         severity failure;
   end process;
end tb_arch;
library ieee;
use ieee.std_logic_1164.all;

entity fsmd_0count_tb is
end fsmd_0count_tb;

architecture arch of fsmd_0count_tb is
   constant T   : time    := 10 ns; -- clk period
   signal clk   : std_logic;
   signal reset : std_logic;
   signal start : std_logic;
   signal a  : std_logic_vector(7 downto 0);
   signal ready : std_logic;
   signal count  : std_logic_vector(3 downto 0);
begin
   --*****************************************************************
   -- instantiation
   --*****************************************************************
   -- instantiatie the unit under test
   dut : entity work.fsmd_0count
      port map(
         clk   => clk,
         reset => reset,
         start => start,
         a => a,
         ready => ready,
         count => count
      );
   --*****************************************************************
   -- clock
   --*****************************************************************
   -- 10 ns clock running forever
   process
   begin
      clk <= '0';
      wait for T / 2;
      clk <= '1';
      wait for T / 2;
   end process;
   
   --*****************************************************************
   -- reset
   --*****************************************************************
   -- reset asserted for T/2
   reset <= '1', '0' after T / 4;
   
   --*****************************************************************
   -- stimulus
   --*****************************************************************
   process
   begin
      start <= '0';
      a <= "00000000";
      wait until falling_edge(clk);
      -- test 1
      start <= '1'; 
      a <= "01010011";
      wait until falling_edge(clk);
      start <= '0'; 
      for i in 1 to 20 loop             
         wait until falling_edge(clk);
      end loop;
      -- test 2
      start <= '1'; 
      a <= "00011111";
      wait until falling_edge(clk);
      start <= '0'; 
      for i in 1 to 20 loop             
         wait until falling_edge(clk);
      end loop;
      -- test 3
      start <= '1'; 
      a <= "11111111";
      wait until falling_edge(clk);
      start <= '0'; 
      for i in 1 to 20 loop             
         wait until falling_edge(clk);
      end loop;
      -- test 4
      start <= '1'; 
      a <= "00000000";
      wait until falling_edge(clk);
      start <= '0'; 
      for i in 1 to 20 loop             
         wait until falling_edge(clk);
      end loop;
      --**************************************************************
      -- terminate simulation
      --**************************************************************
      assert false
         report "Simulation Completed"
         severity failure;
   end process;
end arch;

-- file: enhanced_pwm.vhd

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity enhanced_pwm is 
	
port(
  clk, reset: in std_logic;
  d, w: in std_logic_vector(3 downto 0);
  pulse: out std_logic

);
end enhanced_pwm;

architecture syn_arch of enhanced_pwm is
  signal f_reg, f_next : std_logic_vector(22 downto 0);
  signal count : integer;
  signal gt: std_logic;
begin
	
	-- input logic
	count <= ((unsigned(d)) + (unsigned(w))-1);
	  -- counter
	  f_next <= "0000000000000000000001";
	  f_next <= std_logic_vector(unsigned(f_reg) + 1) when ((to_integer(unsigned(f_reg)) < count) and (reset = '0')) else
	            "0000000000000000000000";
	  
	  -- comparator
	  gt <= ((unsigned(f_next)) > ((unsigned(d))));
	
	-- D FF
	process(clk)
	begin
		if(clk'event and clk = '1') then
        pulse <= gt;
		  f_reg <= f_next;
		end if;
	end process;
	
	-- output logic
	
	
end syn_arch;

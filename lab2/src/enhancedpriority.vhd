library ieee;
use ieee.std_logic_1164.all;

entity enhancedpriority is 
	port (
		sw : in std_logic_vector(9 downto 0); --10 switches
		led : out std_logic_vector(7 downto 0) --7 led lights

		);
		end enhancedpriority;
		
architecture struc_arch of enhancedpriority is 
begin
priority : entity work.enhanced_prio(struc_arch)
	port map(
		r => sw(9 downto 0),
		fst => led(7 downto 4),
		snd => led(3 downto 0)
	);
end struc_arch;

library ieee;

use ieee.std_logic_1164.all;



entity bcd_inc_wrapping is 

	port (

		sw : in std_logic_vector(9 downto 0); -- 10 switches

		led : out std_logic_vector(7 downto 0); -- 7 led lights
		
		hex0 : out std_logic_vector(7 downto 0); -- output hex display 0
	
		hex1 : out std_logic_vector(7 downto 0); -- output hex display 1
		
		hex2 : out std_logic_vector(7 downto 0) -- output hex display 2	 


		);

		end bcd_inc_wrapping;

		

architecture struc_arch of bcd_inc_wrapping is 
 
 signal y0_out, y1_out, y2_out : std_logic_vector(3 downto 0);
 		

begin

bcd0 : entity work.bcd_inc(rtl_arch)

	port map(

		b0 => sw(3 downto 0),       -- first incrementor input (switch)
		
		b1 => sw(7 downto 4),  	    -- second incrementor input (switch)
		
		b2 => "1001",			  	    -- third incrementor input (no switch)
		
		y0 => y0_out,
		
		y1 => y1_out,
		
		y2 => open
		
		);
		
		                       
hex2sseg0 : entity work.hex_to_sseg(arch)

	port map(
	
      hex => y0_out,
		
	   dp => '1',
		
		sseg => hex0	          -- first incrementor output (LED)

	);
	
hex2sseg1 : entity work.hex_to_sseg(arch)

	port map(
	
      hex => y1_out,
	
      dp => '1',
		
		sseg => hex1             -- second incrementor output (LED)
	);
	
hex2sseg2 : entity work.hex_to_sseg(arch)

	port map(

		hex => y2_out,
		
      dp => '1',
		
		sseg => hex2	          -- third incrementor output (unconnected)
		
	);
	
    led(3 downto 0) <= y0_out;
	 
	 led(7 downto 4) <= y1_out;
	 
end struc_arch;

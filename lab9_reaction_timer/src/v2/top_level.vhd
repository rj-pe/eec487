-- file: top_level.vhd
-- top level wrapping circuit for reaction timer
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
  port(
    clk : in std_logic;
    --sw : in std_logic_vector(2 downto 0);
	 sw : in std_logic_vector(0 downto 0);
	 btn : in std_logic_vector(1 downto 0);
	 led : out std_logic_vector(1 downto 0);
	 hex0 : out std_logic_vector(7 downto 0);
	 hex1 : out std_logic_vector(7 downto 0);
	 hex2 : out std_logic_vector(7 downto 0)
  );
end top_level;

architecture arch of top_level is
  signal bcd_output : std_logic_vector(11 downto 0);
  signal decode_output0 : std_logic_vector(7 downto 0);
  signal decode_output1 : std_logic_vector(7 downto 0);
  signal decode_output2 : std_logic_vector(7 downto 0);
  signal char_output : std_logic_vector(13 downto 0);
  signal sel_o : std_logic;
  signal dbnc_btn0, dbnc_btn1 : std_logic;
  
begin
 dbnc_u0 : entity work.debounce
   port map(
	  clk => clk, reset => '0', btn => btn(0), db_tick => dbnc_btn0 
	);
 dbnc_u1 : entity work.debounce
   port map(
	  clk => clk, reset => '0', btn => btn(1), db_tick => dbnc_btn1 
	);
	
 fsmd_u : entity work.fsmd
   port map(
	  clk => clk,
	  reset => '0',
	  clear => sw(0),
--	  start => sw(1),
--	  stop => sw(2),
     start => dbnc_btn0,
	  stop => dbnc_btn1,
	  ready => led(1),
	  go => led(0),
	  bcd_o => bcd_output,
	  char_o => char_output,
	  sel_o => sel_o
	);
  bcd_decode0 : entity work.hex_to_sseg
   port map(
	-- placeholder
	hex => bcd_output(3 downto 0),
	dp => '1',
	sseg => decode_output0
	); 
  bcd_decode1 : entity work.hex_to_sseg
   port map(
	-- placeholder
	hex => bcd_output(7 downto 4),
	dp => '1',
	sseg => decode_output1
	); 
  bcd_decode2 : entity work.hex_to_sseg
   port map(
   hex => bcd_output(11 downto 8),
	dp => '1',
	sseg => decode_output2
	);
--hex0 <= decode_output0;
--hex1 <= decode_output1;
--hex2 <= decode_output2;	
 hex0 <= decode_output0 when sel_o = '0' else
          (others => '1');
 hex1 <= decode_output1 when sel_o = '0' else
          '1' & char_output(6 downto 0);
 hex2 <= decode_output2 when sel_o = '0' else
          '1' & char_output(13 downto 7);
 
end arch;
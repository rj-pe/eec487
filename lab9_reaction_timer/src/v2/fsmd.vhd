-- file: fsmd.vhd
-- control path examines external commands and status
-- generates control signals to specify operation of sequential ckt
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsmd is
  port(
    -- inputs
    clk, reset : in std_logic;
    clear : in std_logic; -- from slide switch
    start : in std_logic; -- from debounce core 0
    stop : in std_logic; -- from debounce core 1
    -- outputs
    ready : out std_logic; -- led indicating that the ckt is ready
    go : out std_logic; -- led indicating the init. of reaction timer
    bcd_o : out std_logic_vector(11 downto 0); -- bcd reaction time (0 - 999)
    char_o : out std_logic_vector(13 downto 0); -- hex patterns 'CH', 'SL', or 'HI'
    sel_o : out std_logic -- 1 for char, 0 for bcd
  );
end fsmd;

architecture arch of fsmd is
  -- counter enable signals
  signal rand_ce : std_logic; -- random counter enable
  signal wait_ce : std_logic; -- wait counter enable
  signal ract_ce : std_logic; -- react counter enable
  -- counter reset signals
  signal ract_rst : std_logic;
  -- counter output signals
  signal rand_co : unsigned(2 downto 0); -- random interval 1 - 7 sec
  signal wait_co : unsigned(2 downto 0); -- wait time counts upto 7 sec
  signal ract_co : std_logic_vector(11 downto 0); -- reaction time in bcd
  -- character select for hex display
  signal char_se : std_logic_vector(1 downto 0); -- 0:"CH", 1:"SL", 2:"HI" 3:""
  -- state machine signals
  type state_type is (init_s, wait_s, ract_s, stop_s, slow_s, chtr_s);
  signal state_reg, state_next : state_type;

begin
  bcd_o <= ract_co;
  -- 3 bit counter (random number generator)
    -- output -> rand_co
    -- enable -> rand_ce
  rand_u: entity work.rand_gen
    port map(
      clk => clk, reset => reset, enable => rand_ce, rand => rand_co
    );
  -- 30 bit counter with 1 sec tick 
    -- output -> wait_co
    -- enable -> wait_ce
  sec_u: entity work.sec_count
    port map(
      clk => clk, reset => reset, enable => wait_ce, seconds => wait_co
    );
  -- 3 digit bcd counter with 1 ms tick with synchronous reset
    -- output -> ract_co
    -- enable -> ract_ce
    -- reset ->  ract_rst (on reset output "000")
    bcd_count_u: entity work.bcd_count
	   port map(
		  clk => clk, reset => reset, enable => ract_ce, count => ract_co, syn_reset => ract_rst
		);
  -- 2 digit char mux with 2 bit select line
    -- output -> char_o
    -- input  -> char_se
    char_o <= not ("11101100000110") when char_se = "10" else -- HI 1110110, 0000110
              not ("11011010111000") when char_se = "01" else -- SL 0111001, 1110110
              not ("01110011110110") when char_se = "00" else -- CH 1101101, 0111000
				  not ("01111110111111") when char_se = "11"; -- wait state 00

  -- FSMD state & data registers
  process(clk, reset)
  begin
    if (reset='1') then 
      state_reg <= init_s;
    elsif (clk'event and clk='1') then
      state_reg <= state_next;
    end if;
  end process;

  -- FSMD control path next-state logic
  process(state_reg, clear, start, stop, wait_co, ract_co)
  begin
    -- default values
    -- leds off
    ready <= '0';
    go <= '0';
    -- counters not enabled
    rand_ce <= '0';
    wait_ce <= '0';
    ract_ce <= '0';
    -- bcd output selected by default
    sel_o <= '0';
	 -- bcd synchronous reset off by default
	 ract_rst <= '0';
    -- char message is "" empty string
    char_se <= "11";
    -- current state is next state
    state_next <= state_reg;
    -- begin case
    case state_reg is
--/*
-- * init state
-- */
      when init_s =>
        --enable char output
        sel_o <= '1';
        --select "HI"
        char_se <= "10";
        --ready led on
        ready <= '1';
        --random counter enabled
        rand_ce <= '1';
        if (start='1') then -- check start button
          -- go to wait state
          state_next <= wait_s;
        end if;
--/*
-- * wait state
-- */
      when wait_s =>
        --wait counter enabled
        wait_ce <= '1';
        -- hex displays three zero's
        ract_rst <= '1';
        -- check stop button
        if (stop='0') then
          if (clear='0') then -- check clear button
            -- check if we've reached the random interval
            if (wait_co = rand_co) then
              -- go to react state
              state_next <= ract_s;
            end if; -- random interval
          else -- go to init state
            state_next <= init_s;
          end if; -- clear button
        else -- go to cheat state
            state_next <= chtr_s;
        end if; -- stop button
--/*
-- * react state
-- */
      when ract_s =>
        --go led on
        go <= '1';
        --enable reaction counter
        ract_ce <= '1';
        if (stop='0') then -- check stop button
          if (clear='0') then -- check clear button
            if (ract_co = "100110011001") then -- check whether we are slow
              state_next <= slow_s;
            end if; -- slow check
          else -- go to init state
            state_next <= init_s;
          end if; -- clear check
        else -- go to stop state
          state_next <= stop_s;
        end if; -- stop check
--/*
-- * stop state
-- */
      when stop_s =>
        if (clear='1') then -- check clear button
          state_next <= init_s; -- go to init state
        end if;
--/*
-- * cheat state
-- */
      when chtr_s =>
        --enable char output
        sel_o <= '1';
        --select "CH"
        char_se <= "00";
        if (clear='1') then -- check clear button
          state_next <= init_s; -- go to init state
        end if;
--/*
-- * slow state
-- */
      when slow_s =>
        --enable char output
        sel_o <= '1';
        --select "SL"
        char_se <= "01";
        if (clear='1') then -- check clear button
          state_next <= init_s; -- go to init state
        end if;

      end case;  -- end case statement
  end process; --FSMD
end arch;

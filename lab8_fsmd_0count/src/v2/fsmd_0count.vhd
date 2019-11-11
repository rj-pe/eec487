-- file fsmd_0count.vhd
-- circuit counts the number of 0's of an 8-bit input word
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsmd_0count is 
  port(
   clk, reset : in std_logic;
   start      : in std_logic;                  -- one-bit to initialize counting
   a          : in std_logic_vector(7 downto 0);             -- 8-bit input word
   ready      : out std_logic;          -- one-bit status indicating ready state
   count      : out std_logic_vector(3 downto 0)        -- 4-bit # of 0's in `a`
  );
end fsmd_0count;

architecture arch of fsmd_0count is
  constant N : unsigned(3 downto 0) := "1000";
-- states
  type state_type is (idle, counter, shift);
  signal state_reg, state_next : state_type;
-- registers and status signals
  signal word_next, word_reg : std_logic_vector(7 downto 0);
  signal word_shift : std_logic;
  signal index_next, index_reg : unsigned(3 downto 0);
  signal index_dec : std_logic;
  signal count_next, count_reg : unsigned(3 downto 0);
  signal count_inc : std_logic;
  signal ready_reg, ready_next : std_logic;
  signal ready_flag : std_logic;

begin
-- FSMD state and data registers
process(clk, reset)
begin
  if (reset='1') then
    state_reg  <= idle;
    count_reg  <= (others => '0');
    word_reg   <= (others => '0');
    index_reg  <= N;
    ready_reg  <= '1';
  elsif (clk'event and clk='1') then
    state_reg  <=   state_next;
    index_reg  <=   index_next;
    word_reg   <=   word_next;
    count_reg  <=   count_next;
    ready_reg  <=   ready_next;
  end if;
end process;
-- output logic
count <= std_logic_vector(count_reg);
ready <= ready_reg;
-- FSMD data path next-state logic
count_next <= (others => '0') when ready_reg = '1' or start = '1' else
              count_reg + 1   when count_inc = '1' else
              count_reg;
index_next <= N when ready_reg = '1' or start = '1' else
              index_reg - 1   when index_dec = '1' and index_reg /=0 else
              index_reg;
word_next  <= a when ready_reg = '1' or start = '1' else
              '0' & word_reg(7 downto 1) when word_shift = '1' else
              word_reg;
ready_next <= '0' when ready_flag = '0' else
              '1' when start = '1' else
              ready_reg;

-- FSMD control path next-state logic
process(state_reg, start, index_next, word_next)
  begin  
  state_next <= state_reg;
  count_inc <= '0';
  index_dec <= '0';
  word_shift <= '0';
  ready_flag <= '1';
  case state_reg is
    when idle =>
      if(start = '1') then
          state_next <= counter;
      elsif(index_next >= 0) then
        state_next <= shift;
      end if; --start = '1'
    when counter =>
      ready_flag <= '0';
      state_next <= shift;
      if (word_next(0) = '0') then
        count_inc <= '1';
        --index_dec <= '1';
      end if; -- word_next(0) = '0'
    when shift =>
        ready_flag <= '0';
      if (index_next > 0) then
        ready_flag <= '0';
        index_dec <= '1';
        word_shift <= '1';
        state_next <= counter;
      elsif (index_next = 0) then
        ready_flag <= '0';
        index_dec <= '1';
        state_next <= counter;
      else
        index_dec <= '0';
        state_next <= idle;
      end if; -- index_next /= 0
  end case;
end process;
end arch;

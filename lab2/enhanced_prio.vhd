library ieee;
use ieee.std_logic_1164.all;

entity enhanced_prio is
  port(
    r: in std_logic_vector(9 downto 0);
    fst, snd: out std_logic_vector(3 downto 0)
  );
end enhanced_prio;

architecture struc_arch of enhanced_prio is
  signal decode_out, xor_out : std_logic_vector(9 downto 0);
begin
  p_enc0_unit : entity work.prio_encoder(cond_arch)
    port map(
      r => r,
      pcode => fst
    );
  p_enc1_unit : entity work.prio_encoder(cond_arch)
    port map(
      r => xor_out,
      pcode => snd
    );
  decode_unit : entity work.decoder_4_10(cond_arch)
    port map(
      a => fst,
      y => decode_out
    );  
    xor_out <= r xor decode_out;
end struc_arch;

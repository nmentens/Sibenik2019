library ieee;
use ieee.std_logic_1164.all;

entity test_invert is
end test_invert;

architecture arch of test_invert is

  signal a, b: std_logic;

  component invert is
    port( a: in std_logic;
          b: out std_logic);
  end component;

begin

  DUT: invert port map(
    a => a, 
    b => b
  );

  PSTIMULI: process
  begin
    a <= '0';
    wait for 10 ns;
    a <= '1';
    wait for 10 ns;
    wait;
  end process PSTIMULI;

end arch;

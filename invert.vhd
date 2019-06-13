library ieee;
use ieee.std_logic_1164.all;

entity invert is
  port( a: in std_logic;
        b: out std_logic);
end invert;

architecture arch of invert is
begin

  b <= not(a);

end arch;

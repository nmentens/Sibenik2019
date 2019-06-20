----------------------------------------------------------------------------------
-- Summer School on Real-world Crypto & Privacy - Hardware Tutorial 
-- Sibenik, June 17-21, 2019 
-- 
-- Author: Nele Mentens
-- Updated by Pedro Maat Costa Massolino
--  
-- Module Name: modaddn 
-- Description: n-bit modular adder
----------------------------------------------------------------------------------

-- include the STD_LOGIC_1164 package in the IEEE library for basic functionality
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- include the NUMERIC_STD package for arithmetic operations
use IEEE.NUMERIC_STD.ALL;

-- describe the interface of the module
-- sum = (a + b) mod p
entity modaddn is
    generic(
        n: integer := 8);
    port(
        a, b, p: in std_logic_vector(n-1 downto 0);
        sum: out std_logic_vector(n-1 downto 0));
end modaddn;

-- describe the behavior of the module in the architecture
architecture behavioral of modaddn is

begin

end behavioral;
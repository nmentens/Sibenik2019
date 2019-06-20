----------------------------------------------------------------------------------
-- Summer School on Real-world Crypto & Privacy - Hardware Tutorial 
-- Sibenik, June 17-21, 2019 
-- 
-- Author: Nele Mentens
-- Updated by Pedro Maat Costa Massolino
--  
-- Module Name: modadd4 
-- Description: 4-bit modular adder
----------------------------------------------------------------------------------

-- include the STD_LOGIC_1164 package in the IEEE library for basic functionality
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- include the NUMERIC_STD package for arithmetic operations
use IEEE.NUMERIC_STD.ALL;

-- describe the interface of the module
-- sum = (a + b) mod p
entity modadd4 is
    port(
        a, b, p: in std_logic_vector(3 downto 0);
        sum: out std_logic_vector(3 downto 0));
end modadd4;

-- describe the behavior of the module in the architecture
architecture behavioral of modadd4 is

-- declare internal signals
signal a_long, b_long, c, d: std_logic_vector(4 downto 0);

begin

-- extend a and b with one bit because the "+" operator expects the inputs and output to be of equal length
a_long <= '0' & a;
b_long <= '0' & b;

-- add two binary numbers
c <= std_logic_vector(unsigned(a_long) + unsigned(b_long));

-- subtract p from the intermediate result
d <= std_logic_vector(unsigned(c) - unsigned(p));

-- assign d to the sum output if d is a positive number
-- assign c to the sum output if d is a negative number
-- leave the MSB out of the assignment because it is always '0'
mux: process(c, d)
begin
    if d(4) = '0' then
        sum <= d(3 downto 0);
    else
        sum <= c(3 downto 0);
    end if;
end process;

end behavioral;
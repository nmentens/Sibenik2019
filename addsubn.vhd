----------------------------------------------------------------------------------
-- Summer School on Real-world Crypto & Privacy - Hardware Tutorial 
-- Sibenik, June 17-21, 2019 
-- 
-- Author: Nele Mentens
-- Updated by Pedro Maat Costa Massolino
--  
-- Module Name: addsubn
-- Description: n-bit adder/subtracter
----------------------------------------------------------------------------------

-- include the STD_LOGIC_1164 package in the IEEE library for basic functionality
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- include the NUMERIC_STD package for arithmetic operations
use IEEE.NUMERIC_STD.ALL;

-- describe the interface of the module
-- if as = '0': sum = a + b
-- if as = '1': sum = a - b 
entity addsubn is
    generic(
        n: integer := 8);
    port(
        a, b: in std_logic_vector(n-1 downto 0);
        as: in std_logic;
        sum: out std_logic_vector(n-1 downto 0));
end addsubn;

-- describe the behavior of the module in the architecture
architecture behavioral of addsubn is

-- declare internal signals
signal as_vec, b_as: std_logic_vector(n-1 downto 0);

begin

-- assign as to each bit of as_vec
as_vec <= (others => as);

-- perform a bitwise XOR of b and as_vec
-- if as = '0': b_as = b
-- if as = '1': b_as = not(b)
b_as <= b xor as_vec;

-- add a to b or not(b)
-- if as = '1': add 1 to the sum
--
-- we cannot convert std_logic to unsigned, therefore we use the as_vec to be able to get the one bit of as.
sum <= std_logic_vector(unsigned(a) + unsigned(b_as) + unsigned(as_vec(0 downto 0)));

end behavioral;
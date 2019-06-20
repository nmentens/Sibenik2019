----------------------------------------------------------------------------------
-- Summer School on Real-world Crypto & Privacy - Hardware Tutorial 
-- Sibenik, June 17-21, 2019 
-- 
-- Author: Pedro Maat Costa Massolino
--  
-- Module Name: ram_single
-- Description: RAM memory with variable word size and depth.
----------------------------------------------------------------------------------

-- include the STD_LOGIC_1164 package in the IEEE library for basic functionality
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- include the NUMERIC_STD package for arithmetic operations
use IEEE.NUMERIC_STD.ALL;

-- describe the interface of the module
entity ram_single is
    generic( 
        ws: integer := 8; -- data width
        ads: integer := 8); -- address width
    port(
        enable: in std_logic;
        clk: in std_logic;
        din: in std_logic_vector((ws - 1) downto 0);
        address: in std_logic_vector((ads - 1) downto 0);
        rw: in std_logic;
        dout: out std_logic_vector((ws - 1) downto 0));
end ram_single;
    
-- describe the behavior of the module in the architecture
architecture behavioral of ram_single is

-- declare internal signals

-- We can see a memory as a matrix of bits, or an array of memory words.
-- To construct an array of an existing type, we create a new type and this new type will be an array.
-- The size of the array has to be specified during the instantiation of the type.
type ramtype is array(integer range <>) of std_logic_vector((ws - 1) downto 0);

-- Instantiation of the memory itself with 2^(ads) words
signal memory_ram: ramtype(0 to (2**ads-1));

begin

-- The command to_01 is necessary when the address bits have a value that is not 0 or 1 (but e.g. X or Z). In that case, the function will transform the values to 0 or 1.
-- Without the to_01 command, the function to_integer would give an error every time address was not 0 or 1. This can happen e.g. with uninitialized values.
process(clk)
    begin
        if (rising_edge(clk)) then
            if(enable = '1') then
                dout <= memory_ram(to_integer(to_01(unsigned(address))));
                if rw = '1' then
                    memory_ram(to_integer(to_01(unsigned(address)))) <= din;
                end if;
            end if;
        end if;
end process;

end behavioral;
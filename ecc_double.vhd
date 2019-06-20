----------------------------------------------------------------------------------
-- Summer School on Real-world Crypto & Privacy - Hardware Tutorial 
-- Sibenik, June 17-12, 2019 
-- 
-- Author: Nele Mentens
-- Updated by Pedro Maat Costa Massolino
--  
-- Module Name: ecc_double
-- Description: n-bit point doubling architecture
----------------------------------------------------------------------------------

-- include the STD_LOGIC_1164 package in the IEEE library for basic functionality
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- include the NUMERIC_STD package for arithmetic operations
use IEEE.NUMERIC_STD.ALL;

-- describe the interface of the module
-- m_enable: enable the memory to read/write external values
-- m_din: external input to the memory (to write values before the computation starts)
-- m_dout: external output from the memory (to read values after the computation ends)
-- m_rw: read/write signal for reading/writing external values from/to the memory
-- m_address: memory address for external read/write
-- start: start the point doubling after all input values are loaded into the memory
-- rst: reset all internal registers
-- clk: clock input
-- done: signal that becomes high when the point doubling is done and the result can be read out from the memory

-- In order to comply with the testbench, the resulting coordinates (x, y, z) are written to addresses 9, 10 and 11 in the memory.
entity ecc_double is
    generic(n: integer := 8;
            log2n: integer := 3);
    port(
        start: in std_logic;
        rst: in std_logic;
        clk: in std_logic;
        done: out std_logic;
        m_enable: in std_logic;
        m_din: in std_logic_vector(n-1 downto 0);
        m_dout: out std_logic_vector(n-1 downto 0);
        m_rw: in std_logic;
        m_address: in std_logic_vector(4 downto 0));
end modmultn;

-- describe the behavior of the module in the architecture
architecture behavioral of modmultn is

-- declare internal signals
signal a_reg, b_reg, p_reg: std_logic_vector(n-1 downto 0);
signal shift, b_left: std_logic;

begin

-- store the inputs 'a', 'b' and 'p' in the registers 'a_reg', 'b_reg' and 'p_reg', respectively, if start = '1'
-- the registers have an asynchronous reset
-- rotate the content of 'b_reg' one position to the left if shift = '1'
reg_a_b_p: process(rst, clk)
begin
    if rst = '1' then
        a_reg <= (others => '0');
        b_reg <= (others => '0');
        p_reg <= (others => '0');
    elsif rising_edge(clk) = '1' then
        if start = '1' then
            a_reg <= a;
            b_reg <= b;
            p_reg <= p;
        elsif shift = '1' then
            b_reg <= b_reg(n-2 downto 0) & b_reg(n-1);
        end if;
    end if;
end process;

b_left <= b_reg(n-1);

end behavioral;
----------------------------------------------------------------------------------
-- Summer School on Real-world Crypto & Privacy - Hardware Tutorial 
-- Sibenik, June 17-21, 2019 
-- 
-- Author: Nele Mentens
-- Updated by Pedro Maat Costa Massolino
--  
-- Module Name: tb_modaddsubn 
-- Description: testbench for the modaddsubn module
----------------------------------------------------------------------------------

-- include the IEEE library and the STD_LOGIC_1164 package for basic functionality
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- describe the interface of the module: a testbench does not have any inputs or outputs
entity tb_modaddsubn is
    generic(
        width: integer := 8);
end tb_modaddsubn;

architecture behavioral of tb_modaddsubn is

-- declare and initialize internal signals to drive the inputs of modaddsubn
signal a_i, b_i, p_i: std_logic_vector(width-1 downto 0) := (others => '0');
signal as_i: std_logic := '0';

-- declare internal signals to read out the outputs of modaddsubn
signal sum_i: std_logic_vector(width-1 downto 0);

-- declare the expected output from the component under test
signal sum_true: std_logic_vector(width-1 downto 0) := (others => '0');

-- declare a signal to check if values match.
signal error_comp: std_logic := '0';

-- declare the modaddsubn component
component modaddsubn
    generic(
        n: integer := 8);
    port(
        a, b, p: in std_logic_vector(n-1 downto 0);
        as: in std_logic;
        sum: out std_logic_vector(n-1 downto 0));
end component;

begin

-- instantiate the modaddsubn component
-- map the generic parameter in the testbench to the generic parameter in the component  
-- map the signals in the testbench to the ports of the component
inst_modaddsubn: modaddsubn
    generic map(n => width)
    port map(   a => a_i,
                b => b_i,
                p => p_i,
                as => as_i,
                sum => sum_i);

-- stimulus process (without sensitivity list, but with wait statements)
stim: process
begin
    wait for 10 ns;
    
    a_i <= "10110110";
    b_i <= "11000011";
    p_i <= "11111101";
    as_i <= '0';
    sum_true <= "01111100";
    error_comp <= '0';
    
    wait for 10 ns;
    
    if(sum_true /= sum_i) then
        error_comp <= '1';
    else
        error_comp <= '0';
    end if;
    
    wait for 10 ns;
    
    as_i <= '1';
    sum_true <= "11110000";
    error_comp <= '0';
    
    wait for 10 ns;
    
    if(sum_true /= sum_i) then
        error_comp <= '1';
    else
        error_comp <= '0';
    end if;
    
    wait for 10 ns;
    
    a_i <= "10000110";
    b_i <= "00010011";
    p_i <= "11111101";
    as_i <= '0';
    sum_true <= "10011001";
    error_comp <= '0';
    
    wait for 10 ns;
    
    if(sum_true /= sum_i) then
        error_comp <= '1';
    else
        error_comp <= '0';
    end if;
    
            
    wait for 10 ns;
            
    as_i <= '1';
    sum_true <= "01110011";
    error_comp <= '0';
    
    wait for 10 ns;
    
    if(sum_true /= sum_i) then
        error_comp <= '1';
    else
        error_comp <= '0';
    end if;
    
    wait for 10 ns;
            
    wait;
end process;

end behavioral;
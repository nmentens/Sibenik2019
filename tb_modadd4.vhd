----------------------------------------------------------------------------------
-- Summer School on Real-world Crypto & Privacy - Hardware Tutorial 
-- Sibenik, June 17-21, 2019 
-- 
-- Author: Nele Mentens
-- Updated by Pedro Maat Costa Massolino
--  
-- Module Name: tb_modadd4 
-- Description: testbench for the modadd4 module
----------------------------------------------------------------------------------

-- include the IEEE library and the STD_LOGIC_1164 package for basic functionality
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- describe the interface of the module: a testbench does not have any inputs or outputs
entity tb_modadd4 is
end tb_modadd4;

architecture behavioral of tb_modadd4 is

-- declare and initialize internal signals to drive the inputs of modadd4
signal a_i, b_i, p_i: std_logic_vector(3 downto 0) := (others => '0');

-- declare internal signals to read out the outputs of modadd4
signal sum_i: std_logic_vector(3 downto 0) := (others => '0');

-- declare the expected output from the component under test
signal sum_true: std_logic_vector(3 downto 0) := (others => '0');

-- declare a signal to check if values match.
signal error_comp: std_logic := '0';

-- declare the modadd4 component
component modadd4
    port(
        a, b, p: in std_logic_vector(3 downto 0);
        sum: out std_logic_vector(3 downto 0));
end component;
    
begin

-- instantiate the modadd4 module
-- map the signals in the testbench to the ports of the module
inst_modadd4: modadd4
    port map(   a => a_i,
                b => b_i,
                p => p_i,
                sum => sum_i);

-- stimulus process (without sensitivity list, but with wait statements)
stim: process
begin
    wait for 10 ns;
    
    a_i <= "1011";
    b_i <= "1100";
    p_i <= "1101";
    sum_true <= "1010";
    error_comp <= '0';
    
    wait for 10 ns;
    
    if(sum_true /= sum_i) then
        error_comp <= '1';
    else
        error_comp <= '0';
    end if;
    
    wait for 10 ns;
    
    a_i <= "0011";
    b_i <= "1000";
    sum_true <= "1011";
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
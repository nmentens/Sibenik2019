----------------------------------------------------------------------------------
-- Summer School on Real-world Crypto & Privacy - Hardware Tutorial 
-- Sibenik, June 17-21, 2019 
-- 
-- Author: Nele Mentens
-- Updated by Pedro Maat Costa Massolino
--  
-- Module Name: tb_addn 
-- Description: testbench for the addn module
----------------------------------------------------------------------------------

-- include the IEEE library and the STD_LOGIC_1164 package for basic functionality
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- describe the interface of the module: a testbench does not have any inputs or outputs
entity tb_addn is
    generic(
        width: integer := 8);
end tb_addn;

architecture behavioral of tb_addn is

-- declare and initialize internal signals to drive the inputs of addn
signal a_i, b_i: std_logic_vector(width-1 downto 0) := (others => '0');

-- declare internal signals to read out the outputs of addn
signal sum_i: std_logic_vector(width downto 0);

-- declare the expected output from the component under test
signal sum_true: std_logic_vector(width downto 0) := (others => '0');

-- declare a signal to check if values match.
signal error_comp: std_logic := '0';

-- declare the addn component
component addn
    generic(n: integer);
    port(   a, b: in std_logic_vector(n-1 downto 0);
            sum: out std_logic_vector(n downto 0));
end component;

begin

-- instantiate the addn component
-- map the generic parameter in the testbench to the generic parameter in the component  
-- map the signals in the testbench to the ports of the component
inst_addn: addn
    generic map(n => width)
    port map(   a => a_i,
                b => b_i,
                sum => sum_i);

-- stimulus process (without sensitivity list, but with wait statements)
stim: process
begin
    wait for 10 ns;
    
    a_i <= "10110110";
    b_i <= "11000011";
    sum_true <= "101111001";
    error_comp <= '0';
    
    wait for 10 ns;
    
    if(sum_true /= sum_i) then
        error_comp <= '1';
    else
        error_comp <= '0';
    end if;
    
    wait for 10 ns;
            
    a_i <= "01011100";
    b_i <= "10010101";
    sum_true <= "011110001";
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
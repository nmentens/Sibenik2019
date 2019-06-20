----------------------------------------------------------------------------------
-- Summer School on Real-world Crypto & Privacy - Hardware Tutorial 
-- Sibenik, June 17-21, 2019 
-- 
-- Author: Nele Mentens
-- Updated by Pedro Maat Costa Massolino
--  
-- Module Name: tb_modaddn_mult 
-- Description: testbench for the modaddn_mult module
----------------------------------------------------------------------------------

-- include the IEEE library and the STD_LOGIC_1164 package for basic functionality
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- describe the interface of the module: a testbench does not have any inputs or outputs
entity tb_modaddn_mult is
    generic(
        width: integer := 4);
end tb_modaddn_mult;

architecture behavioral of tb_modaddn_mult is

-- declare and initialize internal signals to drive the inputs of modaddn_mult
signal a_i, b_i, p_i: std_logic_vector(width-1 downto 0) := (others => '0');
signal rst_i, clk_i, start_i: std_logic := '0';

-- declare internal signals to read out the outputs of modaddn_mult
signal product_i: std_logic_vector(width-1 downto 0);
signal done_i: std_logic;

-- declare the expected output from the component under test
signal product_true: std_logic_vector(width-1 downto 0) := (others => '0');

-- declare a signal to check if values match.
signal error_comp: std_logic := '0';

-- define the clock period
constant clk_period: time := 10 ns;

-- define signal to terminate simulation
signal testbench_finish: boolean := false;

-- declare the modaddn_mult component
component modaddn_mult
    generic(
        n: integer := 4);
    port(
        a, b, p: in std_logic_vector(n-1 downto 0);
        rst, clk, start: in std_logic;
        product: out std_logic_vector(n-1 downto 0);
        done: out std_logic);
end component;

begin

-- instantiate the modaddn_mult component
-- map the generic parameter in the testbench to the generic parameter in the component  
-- map the signals in the testbench to the ports of the component
inst_modaddn_mult: modaddn_mult
    generic map(n => width)
    port map(   a => a_i,
                b => b_i,
                p => p_i,
                rst => rst_i,
                clk => clk_i,
                start => start_i,
                product => product_i,
                done => done_i);

-- generate the clock with a duty cycle of 50%
gen_clk: process
begin
    while(not testbench_finish) loop
        clk_i <= '0';
        wait for clk_period/2;
        clk_i <= '1';
        wait for clk_period/2;
    end loop;
    wait;
end process;

-- stimulus process (without sensitivity list, but with wait statements)
stim: process
begin
    wait for clk_period;

    rst_i <= '1';

    wait for clk_period;

    rst_i <= '0';

    wait for clk_period;

    a_i <= "1010";
    b_i <= "1001";
    p_i <= "1101";
    start_i <= '1';
    product_true <= "1100";
    error_comp <= '0';
    
    wait for clk_period;

    start_i <= '0';
    
    wait until done_i = '1';
    
    if(product_true /= product_i) then
        error_comp <= '1';
    else
        error_comp <= '0';
    end if;
    
    wait for 3*clk_period/2;

    a_i <= "0111";
    b_i <= "1000";
    p_i <= "1001";
    start_i <= '1';
    product_true <= "0010";
    error_comp <= '0';
    wait for clk_period;
        
    start_i <= '0';

    wait until done_i = '1';
    
    if(product_true /= product_i) then
        error_comp <= '1';
    else
        error_comp <= '0';
    end if;
    
    wait for 3*clk_period/2;
    
    testbench_finish <= true;
    wait;
end process;

end behavioral;
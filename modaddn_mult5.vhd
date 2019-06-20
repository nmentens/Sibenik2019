----------------------------------------------------------------------------------
-- Summer School on Real-world Crypto & Privacy - Hardware Tutorial 
-- Sibenik, June 17-21, 2019 
-- 
-- Author: Nele Mentens
-- Updated by Pedro Maat Costa Massolino
--  
-- Module Name: modaddn_mult5
-- Description: n-bit modular constant multiplier (with constant = 5)
----------------------------------------------------------------------------------

-- include the STD_LOGIC_1164 package in the IEEE library for basic functionality
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- include the NUMERIC_STD package for arithmetic operations
use IEEE.NUMERIC_STD.ALL;

-- describe the interface of the module
-- product = 5*a mod p
entity modaddn_mult5 is
    generic(
        n: integer := 4);
    port(
        a, p: in std_logic_vector(n-1 downto 0);
        rst, clk, start: in std_logic;
        product: out std_logic_vector(n-1 downto 0);
        done: out std_logic);
end modaddn_mult5;

-- describe the behavior of the module in the architecture
architecture behavioral of modaddn_mult5 is

-- create the enumerated type 'my_state' to update and store the state of the FSM
type my_state is (s_idle, s_add, s_done);

-- declare internal signals
signal c, a_reg, p_reg, product_reg: std_logic_vector(n-1 downto 0);
signal state: my_state;
signal ctr: std_logic_vector(2 downto 0);
signal enable: std_logic;

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
-- map the generic parameter in the top design to the generic parameter in the component  
-- map the signals in the top design to the ports of the component
inst_modaddsubn: modaddsubn
    generic map(n => n)
    port map(   a => product_reg,
                b => a_reg,
                p => p_reg,
                as => '0',
                sum => c);

-- store the intermediate sum in the register 'product_reg'
-- the register has an asynchronous reset: 'rst'
-- the register has a synchronous reset: 'done_int'
reg_product: process(rst, clk)
begin
    if rst = '1' then
        product_reg <= (others => '0');
    elsif rising_edge(clk) then
        if start = '1' then
            product_reg <= (others => '0');
        else
            product_reg <= c;
        end if;
    end if;
end process;

-- store the input 'a' in the register 'a_reg' with an asynchronous reset
reg_a_p: process(rst, clk)
begin
    if rst = '1' then
        a_reg <= (others => '0');
        p_reg <= (others => '0');
    elsif rising_edge(clk) then
        if start = '1' then
            a_reg <= a;
            p_reg <= p;
        end if;
    end if;
end process;

-- create a counter that increments when enable = '1'
counter: process(rst, clk)
begin
    if rst = '1' then
        ctr <= std_logic_vector(to_unsigned(0, 3));
    elsif rising_edge(clk) then
        if start = '1' then
            ctr <= std_logic_vector(to_unsigned(0, 3));
        elsif enable = '1' then
            ctr <= std_logic_vector(unsigned(ctr) + to_unsigned(1, 3));
        end if;
    end if;
end process;

-- update and store the state of the FSM
-- stop the calculation when ctr = 4, i.e. when we reach 5*a
-- (we lose 1 cycle by resetting the product register when the start signal comes)
FSM_state: process(rst, clk)
begin
    if rst = '1' then
        state <= s_idle;
    elsif rising_edge(clk) then
        case state is
            when s_idle =>
                if start = '1' then
                    state <= s_add;
                end if;
            when s_add =>
                if ctr = std_logic_vector(to_unsigned(4, 3)) then
                    state <= s_done;
                end if;
            when others =>
                state <= s_idle;
        end case;
    end if;
end process;

FSM_out: process(state)
begin
    case state is
        when s_idle =>
            enable <= '0';
            done <= '0';
        when s_add =>
            enable <= '1';
            done <= '0';
        when others =>
            enable <= '0';
            done <= '1';
    end case;
end process;

product <= product_reg;

end behavioral;
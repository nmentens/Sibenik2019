----------------------------------------------------------------------------------
-- Summer School on Real-world Crypto & Privacy - Hardware Tutorial 
-- Sibenik, June 17-21, 2019 
-- 
-- Author: Pedro Maat Costa Massolino
-- Updated by Nele Mentens
--  
-- Module Name: tb_ecc_double_small 
-- Description: testbench for the ecc_double module
----------------------------------------------------------------------------------

-- include the IEEE library and the STD_LOGIC_1164 package for basic functionality
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- describe the interface of the module: a testbench does not have any inputs or outputs
entity tb_ecc_double_small is
    generic(
        n: integer := 8;
        log2n: integer := 3);
end tb_ecc_double_small;

architecture behavioral of tb_ecc_double_small is

-- declare and initialize internal signals to drive the inputs of ecc_double

constant ecc_prime: std_logic_vector(7 downto 0) := X"7F";
constant ecc_a: std_logic_vector(7 downto 0) := X"7C";
constant ecc_b: std_logic_vector(7 downto 0) := X"05";

constant ecc_p1_x: std_logic_vector(7 downto 0) := X"31";
constant ecc_p1_y: std_logic_vector(7 downto 0) := X"0a";
constant ecc_p1_z: std_logic_vector(7 downto 0) := X"0f";

constant ecc_p1_double_x: std_logic_vector(7 downto 0) := X"0a";
constant ecc_p1_double_y: std_logic_vector(7 downto 0) := X"71";
constant ecc_p1_double_z: std_logic_vector(7 downto 0) := X"70";

signal start_i: std_logic := '0';
signal rst_i: std_logic := '1';
signal clk_i: std_logic := '0';
signal done_i: std_logic;
signal m_enable_i: std_logic := '0';
signal m_din_i: std_logic_vector(n-1 downto 0) := (others => '0');
signal m_dout_i: std_logic_vector(n-1 downto 0);
signal m_rw_i: std_logic := '0';
signal m_address_i: std_logic_vector(4 downto 0) := (others => '0');

-- declare a signal to check if values match.
signal error_comp: std_logic := '0';

-- define the clock period
constant clk_period: time := 10 ns;

-- define signal to terminate simulation
signal testbench_finish: boolean := false;

-- declare the ecc_base component
component ecc_double
    generic(
        n: integer := 8;
        log2n: integer := 3);
    port(
        start: in std_logic;
        rst: in std_logic;
        clk: in std_logic;
        done: out std_logic;
        m_enable: in std_logic;
        m_din:in std_logic_vector(n-1 downto 0);
        m_dout:out std_logic_vector(n-1 downto 0);
        m_rw:in std_logic;
        m_address:in std_logic_vector(4 downto 0));
end component;

begin

-- instantiate the ecc_base component
-- map the generic parameter in the testbench to the generic parameter in the component  
-- map the signals in the testbench to the ports of the component
inst_ecc_double: ecc_double
    generic map(n=>n,
            log2n=>log2n)
    port map(
        start=>start_i,
        rst=>rst_i,
        clk=>clk_i,
        done=>done_i,
        m_enable=>m_enable_i,
        m_din=>m_din_i,
        m_dout=>m_dout_i,
        m_rw=>m_rw_i,
        m_address=>m_address_i
    );

-- generate the clock with a duty cycle of 50%
gen_clk: process
begin
     while(testbench_finish = false) loop
        clk_i <= '0';
        wait for clk_period/2;
        clk_i <= '1';
        wait for clk_period/2;
     end loop;
     wait;
end process;

-- stimulus process (without sensitivity list, but with wait statements)
stim: process
variable i: integer;
begin
    wait for clk_period;
    
    rst_i <= '0';
    
    wait for clk_period;
    -- Fill memory with the ecc constants and points
    m_enable_i <= '1';
    m_din_i <= ecc_prime;
    m_rw_i <= '1';
    m_address_i <= std_logic_vector(to_unsigned(0, 5));
    wait for clk_period;
    m_enable_i <= '1';
    m_din_i <= ecc_a;
    m_rw_i <= '1';
    m_address_i <= std_logic_vector(to_unsigned(1, 5));
    wait for clk_period;
    m_enable_i <= '1';
    m_din_i <= ecc_b;
    m_rw_i <= '1';
    m_address_i <= std_logic_vector(to_unsigned(2, 5));
    wait for clk_period;
    m_enable_i <= '1';
    m_din_i <= ecc_p1_x;
    m_rw_i <= '1';
    m_address_i <= std_logic_vector(to_unsigned(3, 5));
    wait for clk_period;
    m_enable_i <= '1';
    m_din_i <= ecc_p1_y;
    m_rw_i <= '1';
    m_address_i <= std_logic_vector(to_unsigned(4, 5));
    wait for clk_period;
    m_enable_i <= '1';
    m_din_i <= ecc_p1_z;
    m_rw_i <= '1';
    m_address_i <= std_logic_vector(to_unsigned(5, 5));
    wait for clk_period;
    m_enable_i <= '0';
    m_rw_i <= '0';
    m_address_i <= std_logic_vector(to_unsigned(0, 5));
    wait for clk_period;
    -- Perform point doubling
    start_i <= '1';
    wait for clk_period;
    start_i <= '0';
    wait until done_i = '1';
    wait for 3*clk_period/2;
    -- Retrieve value
    wait for clk_period;
    error_comp <= '0';
    m_enable_i <= '1';
    m_din_i <= (others=>'0');
    m_rw_i <= '0';
    m_address_i <= std_logic_vector(to_unsigned(9, 5));
    wait for clk_period;
    if(ecc_p1_double_x /= m_dout_i) then
        error_comp <= '1';
    else
        error_comp <= '0';
    end if;
    wait for clk_period;
    error_comp <= '0';
    m_enable_i <= '1';
    m_din_i <= (others=>'0');
    m_rw_i <= '0';
    m_address_i <= std_logic_vector(to_unsigned(10, 5));
    wait for clk_period;
    if(ecc_p1_double_y /= m_dout_i) then
        error_comp <= '1';
    else
        error_comp <= '0';
    end if;
    wait for clk_period;
    error_comp <= '0';
    m_enable_i <= '1';
    m_din_i <= (others=>'0');
    m_rw_i <= '0';
    m_address_i <= std_logic_vector(to_unsigned(11, 5));
    wait for clk_period;
    if(ecc_p1_double_z /= m_dout_i) then
        error_comp <= '1';
    else
        error_comp <= '0';
    end if;
    wait for 3*clk_period/2;
    testbench_finish <= true;
    wait;
end process;

end behavioral;
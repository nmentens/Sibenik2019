----------------------------------------------------------------------------------
-- Summer School on Real-world Crypto & Privacy - Hardware Tutorial 
-- Sibenik, June 17-21, 2019 
-- 
-- Author: Pedro Maat Costa Massolino
--  
-- Module Name: tb_ram_single 
-- Description: testbench for the ram_single module
----------------------------------------------------------------------------------

-- include the IEEE library and the STD_LOGIC_1164 package for basic functionality
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- include the NUMERIC_STD package for arithmetic operations
use IEEE.NUMERIC_STD.ALL;

-- describe the interface of the module: a testbench does not have any inputs or outputs
entity tb_ram_single is
    generic(
        ws : integer := 8;
        ads: integer := 8);
end tb_ram_single;

architecture behavioral of tb_ram_single is
    
-- declare and initialize internal signals to drive the inputs of ram_single
signal enable_i: std_logic := '0';
signal clk_i: std_logic;
signal din_i: std_logic_vector((ws - 1) downto 0) := (others => '0');
signal address_i: std_logic_vector((ads - 1) downto 0) := (others => '0');
signal rw_i: std_logic := '0';
signal dout_i: std_logic_vector((ws - 1) downto 0) := (others => '0');

-- define the clock period
constant clk_period: time := 10 ns;

-- declare a signal to check if values match.
signal error_test: std_logic := '0';

-- define signal to terminate simulation
signal testbench_finish: boolean := false;

-- declare the ram_single component
component ram_single is
    generic( 
        ws: integer := 8;
        ads: integer := 8);
    port(
        enable: in std_logic;
        clk: in std_logic;
        din: in std_logic_vector((ws - 1) downto 0);
        address: in std_logic_vector((ads - 1) downto 0);
        rw: in std_logic;
        dout: out std_logic_vector((ws - 1) downto 0));
end component;

begin

-- instantiate the ram_single component
-- map the generic parameter in the testbench to the generic parameter in the component  
-- map the signals in the testbench to the ports of the component
inst_ram_single: ram_single
    generic map(
        ws=>ws,
        ads=>ads
    )
    port map(   
        enable=>enable_i,
        clk=>clk_i,
        din=>din_i,
        address=>address_i,
        rw=>rw_i,
        dout=>dout_i
    );
    
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
variable i: integer;
begin
    wait for clk_period;
    -- Fill memory module with simple pattern
    i := 0;
    while(i < 2**ads) loop
        enable_i <= '1';
        din_i <= std_logic_vector(to_unsigned(i, ws));
        address_i <= std_logic_vector(to_unsigned(i, ads));
        rw_i <= '1';
        wait for clk_period;
        i := i + 1;
    end loop;
    wait for clk_period;
    din_i <= std_logic_vector(to_unsigned(0, ws));
    -- Check if pattern is correct
    i := 0;
    while(i < 2**ads) loop
        error_test <= '0';
        enable_i <= '1';
        address_i <= std_logic_vector(to_unsigned(i, ads));
        rw_i <= '0';
        wait for clk_period;
        if(dout_i /= std_logic_vector(to_unsigned(i, ws))) then
            error_test <= '1';
        else
            error_test <= '0';
        end if;
        wait for clk_period;
        error_test <= '0';
        wait for clk_period;
        i := i + 1;
    end loop;
    wait for clk_period;
    -- Try to write with enable turned off
    enable_i <= '0';
    din_i <= std_logic_vector(to_unsigned(0, ws));
    address_i <= std_logic_vector(to_unsigned(15, ads));
    rw_i <= '1';
    wait for clk_period;
    -- Check if it was written
    i := 15;
    enable_i <= '1';
    din_i <= std_logic_vector(to_unsigned(0, ws));
    address_i <= std_logic_vector(to_unsigned(i, ads));
    rw_i <= '0';
    wait for clk_period;
    if(dout_i /= std_logic_vector(to_unsigned(i, ws))) then
        error_test <= '1';
    else
        error_test <= '0';
    end if;
    wait for clk_period;
    error_test <= '0';
    wait for clk_period;
    testbench_finish <= true;
    wait;
end process;

end behavioral;
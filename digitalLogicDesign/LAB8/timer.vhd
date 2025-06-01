library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity timer is
    Port ( clk      : in  STD_LOGIC;
           reset    : in  STD_LOGIC;
           tunit_clk : out STD_LOGIC);
end timer;

architecture Behavioral of timer is
    constant MAX_COUNT : integer := 162_500_000; -- for 3.25s @ 50MHz
    signal counter     : integer := 0;
    signal pulse       : std_logic := '0';
begin
    process(clk, reset)
    begin
        if reset = '1' then
            counter <= 0;
            pulse <= '0';
        elsif rising_edge(clk) then
            if counter = MAX_COUNT - 1 then
                counter <= 0;
                pulse <= '1';
            else
                counter <= counter + 1;
                pulse <= '0';
            end if;
        end if;
    end process;

    tunit_clk <= pulse;
end Behavioral;

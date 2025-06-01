library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity timer1 is
    Port (
        clk       : in  STD_LOGIC;      -- 50 MHz clock
        reset     : in  STD_LOGIC;
        one_sec_pulse : out STD_LOGIC   -- High for 1 clock cycle every second
    );
end timer1;

architecture Behavioral of timer1 is
    constant MAX_COUNT : integer := 50_000_000; -- 1 second @ 50MHz
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
                pulse <= '1';  -- 1 clock cycle pulse every second
            else
                counter <= counter + 1;
                pulse <= '0';
            end if;
        end if;
    end process;

    one_sec_pulse <= pulse;

end Behavioral;

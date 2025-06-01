library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control is
    Port ( tunit_clk : in STD_LOGIC;
			  one_sec_pulse : in STD_LOGIC;
           reset     : in STD_LOGIC;
           red       : out STD_LOGIC;
           yellow    : out STD_LOGIC;
           green     : out STD_LOGIC;
           red1       : out STD_LOGIC;
           yellow1    : out STD_LOGIC;
           green1     : out STD_LOGIC;
           red_timer : out INTEGER range 0 to 16);
end control;

architecture Behavioral of control is
    type state_type is (R, G, Y);
    signal state : state_type := R;
    signal state1 : state_type := G;
    signal count : integer range 0 to 5 := 0;
    signal red_seconds_left : integer range 0 to 16 := 16;
begin
    process(tunit_clk, reset)
    begin
        if reset = '1' then
            state <= R;
            count <= 0;
        elsif rising_edge(tunit_clk) then
            case state is
                when R =>
                    if count = 3 then
                        state1 <= Y;
                    end if;
                    if count = 4 then
                        state <= G;
                        state1 <= R;
                        count <= 0;
                    else
                        count <= count + 1;
                    end if;

                when G =>
                    if count = 3 then
                        state <= Y;
                        count <= 0;
                    else
                        count <= count + 1;
                    end if;

                when Y =>
                    if count = 0 then
                        state <= R;
                        state1 <= G;
                        count <= 0;
                    else
                        count <= count + 1;
                    end if;
            end case;
        end if;
    end process;
	 
	  process(one_sec_pulse, reset)
		 begin
			  if reset = '1' then
					red_seconds_left <= 16;
			  elsif rising_edge(one_sec_pulse) then
					if state = R and red_seconds_left > 0 then
						 red_seconds_left <= red_seconds_left - 1;
						 elsif state = R and red_seconds_left = 0 then
						 red_seconds_left <= 16;
					end if;
			  end if;
		 end process;

    -- Output control
    red     <= '1' when state = R else '0';
    yellow  <= '1' when state = Y else '0';
    green   <= '1' when state = G else '0';
    red1    <= '1' when state1 = R else '0';
    yellow1 <= '1' when state1 = Y else '0';
    green1  <= '1' when state1 = G else '0';

    red_timer <= red_seconds_left;
end Behavioral;

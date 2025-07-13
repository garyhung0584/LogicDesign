library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity lab8 is
    Port ( clk       : in  STD_LOGIC;
           reset     : in  STD_LOGIC;
           red_led   : buffer STD_LOGIC;
           yellow_led: out STD_LOGIC;
           green_led : out STD_LOGIC;
           red_led1   : buffer STD_LOGIC;
           yellow_led1: out STD_LOGIC;
           green_led1 : out STD_LOGIC;
           seg         : out STD_LOGIC_VECTOR(0 to 13);
           seg1         : out STD_LOGIC_VECTOR(0 to 13));
end lab8;

architecture Structural of lab8 is
    signal tunit_clk_sig : STD_LOGIC;
	 signal one_sec_pulse_sig : std_logic;
    signal red_count_sig     : INTEGER range 0 to 16;
    signal red_count_sig1     : INTEGER range 0 to 16;
    signal hex_segments_sig  : STD_LOGIC_VECTOR(13 downto 0);
    signal hex_segments_sig1  : STD_LOGIC_VECTOR(13 downto 0);
	 signal tens_digit  : integer range 0 to 9;
	 signal units_digit : integer range 0 to 9;
	 signal tens_digit1  : integer range 0 to 9;
	 signal units_digit1 : integer range 0 to 9;


begin
   clk_div: entity work.timer
        port map (clk => clk, reset => reset, tunit_clk => tunit_clk_sig);
		  
	sec_timer: entity work.timer1
		port map (
			clk => clk,
			reset => reset,
			one_sec_pulse => one_sec_pulse_sig
		);

    fsm: entity work.control
        port map (
			tunit_clk => tunit_clk_sig,
			one_sec_pulse => one_sec_pulse_sig,
			reset => reset,
			red => red_led, yellow => yellow_led, green => green_led,
			red1 => red_led1, yellow1 => yellow_led1, green1 => green_led1,
			red_timer => red_count_sig, red_timer1 => red_count_sig1);
			
		tens_digit  <= red_count_sig / 10;
		units_digit <= red_count_sig mod 10;
			
    process(units_digit)
    begin
        case units_digit is
            when 0 => hex_segments_sig(13 downto 7) <= "1111110"; -- 0
            when 1 => hex_segments_sig(13 downto 7) <= "0110000"; -- 1
            when 2 => hex_segments_sig(13 downto 7) <= "1101101"; -- 2
            when 3 => hex_segments_sig(13 downto 7) <= "1111001"; -- 3
            when 4 => hex_segments_sig(13 downto 7) <= "0110011"; -- 4
            when 5 => hex_segments_sig(13 downto 7) <= "1011011"; -- 5
            when 6 => hex_segments_sig(13 downto 7) <= "1011111"; -- 6
            when 7 => hex_segments_sig(13 downto 7) <= "1110000"; -- 7
            when 8 => hex_segments_sig(13 downto 7) <= "1111111"; -- 8
            when 9 => hex_segments_sig(13 downto 7) <= "1111011"; -- 9
        end case;
    end process;
	 			
    process(tens_digit)
    begin
        case tens_digit is
            when 0 => hex_segments_sig(6 downto 0) <= "1111110"; -- 0
            when 1 => hex_segments_sig(6 downto 0) <= "0110000"; -- 1
            when others => hex_segments_sig(6 downto 0) <= "0000000";
        end case;
    end process;
	 
		tens_digit1  <= red_count_sig1 / 10;
		units_digit1 <= red_count_sig1 mod 10;
			
    process(units_digit1)
    begin
        case units_digit1 is
            when 0 => hex_segments_sig1(13 downto 7) <= "1111110"; -- 0
            when 1 => hex_segments_sig1(13 downto 7) <= "0110000"; -- 1
            when 2 => hex_segments_sig1(13 downto 7) <= "1101101"; -- 2
            when 3 => hex_segments_sig1(13 downto 7) <= "1111001"; -- 3
            when 4 => hex_segments_sig1(13 downto 7) <= "0110011"; -- 4
            when 5 => hex_segments_sig1(13 downto 7) <= "1011011"; -- 5
            when 6 => hex_segments_sig1(13 downto 7) <= "1011111"; -- 6
            when 7 => hex_segments_sig1(13 downto 7) <= "1110000"; -- 7
            when 8 => hex_segments_sig1(13 downto 7) <= "1111111"; -- 8
            when 9 => hex_segments_sig1(13 downto 7) <= "1111011"; -- 9
            when others => hex_segments_sig1(13 downto 7) <= "0000000"; -- Blank or error
        end case;
    end process;
	 			
    process(tens_digit1)
    begin
        case tens_digit1 is
            when 0 => hex_segments_sig1(6 downto 0) <= "1111110"; -- 0
            when 1 => hex_segments_sig1(6 downto 0) <= "0110000"; -- 1
            when others => hex_segments_sig1(6 downto 0) <= "0000000"; -- Blank or error
        end case;
    end process;
	 
	process(red_led, red_led1) is
	begin
	if red_led = '1' then
		seg <= not hex_segments_sig;
	else
		seg <= (others=>'1');
	end if;
	 
	if red_led1 = '1' then
		seg1 <= not hex_segments_sig1;
	else
		seg1 <= (others=>'1');
	end if;
	end process;
	 
end Structural;

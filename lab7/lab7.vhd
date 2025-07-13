library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
use work.lab7_package.all;


entity lab7 is
	port(
		clk, clear: in std_logic;
		Divisor, Dividend: in std_logic_vector(7 downto 0);
		Remainder: buffer std_logic_vector(7 downto 0);
		states:out std_logic_vector(2 downto 0);
		seg : out std_logic_vector(27 downto 0));
end;

architecture logicfun of lab7 is
	signal w: std_logic;
	signal load: std_logic;
	signal DividendREG: std_logic_vector(7 downto 0);
	signal RemainderREG: std_logic_vector(7 downto 0);
	signal QuotientREG: std_logic_vector(7 downto 0);
	signal state: std_logic_vector(2 downto 0);
	signal count : integer range 0 to 8 := 0;
    signal quotient_bit: std_logic;
    signal done: std_logic;
begin
    done <= '1' when count = 8 else '0';

    process(state, done)
    begin
        w    <= '0';
        load <= '0';
        case state is
            when "000" =>
                w <= '1';
            when "001" =>
                load <= '1';
            when "100" =>
                if done = '1' then
                    w <= '1';
                else
                    w <= '0';
                end if;
            when others =>
                null;
        end case;
    end process;

    stage0: FSM port map(clk, clear, w, state);
    states <= state;

    process(clk)
    begin
        if rising_edge(clk) then
            if state = "001" then
                DividendREG <= Dividend;
                RemainderREG <= (others => '0');
                QuotientREG <= (others => '0');
                count <= 0;
            elsif state = "010" then
                RemainderREG <= RemainderREG(6 downto 0) & DividendREG(7);
                DividendREG <= DividendREG(6 downto 0) & '0';
            elsif state = "011" then
                if unsigned(RemainderREG) >= unsigned(Divisor) then
                    RemainderREG <= std_logic_vector(unsigned(RemainderREG) - unsigned(Divisor));
                    quotient_bit <= '1';
                else
                    quotient_bit <= '0';
                end if;
            elsif state = "100" then
                QuotientREG <= QuotientREG(6 downto 0) & quotient_bit;
                count <= count + 1;
            end if;
        end if;
    end process;

    Remainder <= RemainderREG;
    quotient_low_display: seven_seg_encoder port map(QuotientREG(3 downto 0), seg(6 downto 0));
    quotient_high_display: seven_seg_encoder port map(QuotientREG(7 downto 4), seg(13 downto 7));
    remainder_low_display: seven_seg_encoder port map(RemainderREG(3 downto 0), seg(20 downto 14));
    remainder_high_display: seven_seg_encoder port map(RemainderREG(7 downto 4), seg(27 downto 21));
end;
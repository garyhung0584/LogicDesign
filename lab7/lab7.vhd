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
		seg : out std_logic_vector(6 downto 0));
end;

architecture logicfun of lab7 is
	signal w: std_logic;
	signal Is_Neg: std_logic;
	signal load: std_logic;
	signal DividendREG: std_logic_vector(7 downto 0);
	signal RemainderREG: std_logic_vector(7 downto 0);
	signal QuotientREG: std_logic_vector(7 downto 0);
	signal state: std_logic_vector(2 downto 0);
	signal Result: std_logic_vector(7 downto 0);
	signal signed_Remainder, signed_Divisor, signed_Result : signed(7 downto 0);
	signal count : integer range 0 to 8 := 0;
    signal quotient_bit: std_logic;
    signal done: std_logic;
begin
    signed_Remainder <= signed(RemainderREG);
    signed_Divisor <= signed(Divisor);
    done <= '1' when count = 8 else '0';

    -- FSM control
    process(state, done, Is_Neg)
    begin
        w    <= '0';
        load <= '0';
        case state is
            when "000" => -- IDLE
                w <= '1';
            when "001" => -- LOAD
                load <= '1';
            when "010" => -- SHIFT
                w <= '0';
            when "011" => -- SUB
                w <= '0';
            when "100" => -- CHECK
                if done = '1' then
                    w <= '1';
                else
                    w <= '0';
                end if;
            when "101" => -- DONE
                w <= '0';
            when others =>
                null;
        end case;
    end process;

    stage0: FSM port map(clk, clear, w, state);
    states <= state;

    -- Datapath for restoring division
    -- LOAD: load Dividend into DividendREG, clear RemainderREG
    stage1: SReg port map(clk, clear, load, '1', Dividend, '0', DividendREG);
    stage2: SReg port map(clk, clear, load, '1', (others => '0'), '0', RemainderREG);

    -- SHIFT: shift left RemainderREG & DividendREG
    -- SUB: subtract Divisor from RemainderREG, set quotient bit
    -- CHECK: increment count
    process(clk)
    begin
        if rising_edge(clk) then
            if state = "010" then -- SHIFT
                DividendREG <= DividendREG(6 downto 0) & '0';
                RemainderREG <= RemainderREG(6 downto 0) & DividendREG(7);
            elsif state = "011" then -- SUB
                if signed(RemainderREG) >= signed(Divisor) then
                    RemainderREG <= std_logic_vector(signed(RemainderREG) - signed(Divisor));
                    quotient_bit <= '1';
                else
                    quotient_bit <= '0';
                end if;
            elsif state = "001" then -- LOAD
                count <= 0;
            elsif state = "100" then -- CHECK
                count <= count + 1;
            end if;
        end if;
    end process;

    -- Update QuotientREG
    process(clk)
    begin
        if rising_edge(clk) then
            if state = "011" then -- SUB
                QuotientREG <= QuotientREG(6 downto 0) & quotient_bit;
            elsif state = "001" then -- LOAD
                QuotientREG <= (others => '0');
            end if;
        end if;
    end process;

    -- Output remainder
    Remainder <= RemainderREG;
    outputting: seven_seg_encoder port map(QuotientREG(3 downto 0), seg);
end;
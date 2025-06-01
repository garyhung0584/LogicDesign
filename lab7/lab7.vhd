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
begin
	signed_Remainder <= signed(RemainderREG);
	signed_Divisor <= signed(Divisor);
	process(clk, clear)
	begin
		if clear = '1' then
			count <= 0;
		elsif rising_edge(clk) then
			if state = "100" then
				count <= count + 1;
			end if;
		end if;
	end process;
	process(state, count, Is_Neg)
	begin
		w    <= '0';
		load <= '0';
		case state is
			when "000" =>
				w <= '1';
			when "001" =>
				load <= '1';
				w    <= Is_Neg;
			when "010" | "011" =>
				load <= '0';
				w    <= '0';
			when "100" =>
				if count >= 8 then
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
	 
	 stage1: SReg port map(clk, clear, load,'1',Dividend, '0', DividendREG);
	 
	 stage2: SReg port map(clk, clear, '0','1', "00000000" , DividendREG(7), RemainderREG);
	 
	 signed_Result <= signed_Remainder - signed_Divisor;
	 
	 Result <=std_logic_vector(signed_Result);
	 
	 Is_Neg  <= Result(7);
	 
	 stage3: SReg port map(clk, clear, '0','1', "00000000" , not Is_Neg, QuotientREG);
	 
	 outputting: seven_seg_encoder port map(QuotientREG(3 downto 0) ,seg);
end;
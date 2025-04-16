
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.lab2_package.All;

entity lab2_sub is
	port (
		X: in std_logic_vector(7 downto 0);
		Y: in std_logic_vector(7 downto 0);
		seg:out std_logic_vector(13 downto 0);
		NEG: out std_logic);
end lab2_sub;


ARCHITECTURE adder of lab2_sub is
	signal C: std_logic_vector(7 downto 0);
	signal YNoT: std_logic_vector(7 downto 0);
	signal S: std_logic_vector(7 downto 0);
	signal S_abs: std_logic_vector(7 downto 0);
	signal M: std_logic_vector(7 downto 0);
	
	begin
		YNOT <= not Y;
		
		stage0: fulladd port map('1', X(0), YNOT(0), S(0), C(1));
		stage1: fulladd port map(C(1), X(1), YNOT(1), S(1), C(2));
		stage2: fulladd port map(C(2), X(2), YNOT(2), S(2), C(3));
		stage3: fulladd port map(C(3), X(3), YNOT(3), S(3), C(4));
		stage4: fulladd port map(C(4), X(4), YNOT(4), S(4), C(5));
		stage5: fulladd port map(C(5), X(5), YNOT(5), S(5), C(6));
		stage6: fulladd port map(C(6), X(6), YNOT(6), S(6), C(7));
		stage7: fulladd port map(C(7), X(7), YNOT(7), S(7), C(0));
		
		M <= (others => S(7));
		
		S_abs <= (S xor M) + S(7);
		
		NEG <= S(7);
		
		stage8: hex port map(S_abs(7),S_abs(6),S_abs(5),S_abs(4),S_abs(3),S_abs(2),S_abs(1),S_abs(0),seg(7),seg(8),seg(9),seg(10),seg(11),seg(12),seg(13),seg(0),seg(1),seg(2),seg(3),seg(4),seg(5),seg(6));
	
	end;
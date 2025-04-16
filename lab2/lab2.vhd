
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.lab2_package.All;

entity lab2 is
	port (
		X: in std_logic_vector(0 to 7);
		Y: in std_logic_vector(0 to 7);
		seg:out std_logic_vector(13 downto 0);
		Cout: out std_logic);
end lab2;


ARCHITECTURE adder of lab2 is
	signal C: std_logic_vector(7 downto 0);
	signal S: std_logic_vector(0 to 7);
	begin
		stage0: fulladd port map(C(0), X(0), Y(0), S(0), C(1));
		stage1: fulladd port map(C(1), X(1), Y(1), S(1), C(2));
		stage2: fulladd port map(C(2), X(2), Y(2), S(2), C(3));
		stage3: fulladd port map(C(3), X(3), Y(3), S(3), C(4));
		stage4: fulladd port map(C(4), X(4), Y(4), S(4), C(5));
		stage5: fulladd port map(C(5), X(5), Y(5), S(5), C(6));
		stage6: fulladd port map(C(6), X(6), Y(6), S(6), C(7));
		stage7: fulladd port map(C(7), X(7), Y(7), S(7), Cout);
		
		stage8: hex port map(S(7),S(6),S(5),S(4),S(3),S(2),S(1),S(0),seg(7),seg(8),seg(9),seg(10),seg(11),seg(12),seg(13),seg(0),seg(1),seg(2),seg(3),seg(4),seg(5),seg(6));
	
	end;
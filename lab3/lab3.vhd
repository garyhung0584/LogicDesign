library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use work.lab3_package.ALL;

entity lab3 is
	port (
		X : in std_logic_vector(0 to 7);
		Y : in std_logic_vector(0 to 7);
		seg:out std_logic_vector(13 downto 0);
		overFlow: out std_logic);
end lab3;

ARCHITECTURE adder of lab3 is
	signal C: std_logic_vector(7 downto 0);
	signal S: std_logic_vector(0 to 7);
	signal Carry: std_logic;
	signal C1: std_logic_vector(7 downto 0);
	signal S1: std_logic_vector(0 to 7);
	signal Carry1: std_logic;
	signal Cout: std_logic_vector(0 to 2);
	begin
		stage0: fulladd port map(C(0), X(0), Y(0), S(0), C(1));
		stage1: fulladd port map(C(1), X(1), Y(1), S(1), C(2));
		stage2: fulladd port map(C(2), X(2), Y(2), S(2), C(3));
		stage3: fulladd port map(C(3), X(3), Y(3), S(3), C(4));
		
		Carry <= (S(3) and S(2)) or (S(3) and S(1)) or C(4);
		
		stage4:  fulladd port map( '0',   '0', S(0), S(4), C(5));
		stage5:  fulladd port map(C(5), Carry, S(1), S(5), C(6));
		stage6:  fulladd port map(C(6), Carry, S(2), S(6), C(7));
		stage7:  fulladd port map(C(7),   '0', S(3), S(7), Cout(0));
		
		
		stage8:  fulladd port map(Carry, X(4), Y(4), S1(0), C1(1));
		stage9:  fulladd port map(C1(1), X(5), Y(5), S1(1), C1(2));
		stage10: fulladd port map(C1(2), X(6), Y(6), S1(2), C1(3));
		stage11: fulladd port map(C1(3), X(7), Y(7), S1(3), C1(4));
		
		Carry1 <= (S1(3) and S1(2)) or (S1(3) and S1(1)) or C1(4);
		
		stage12: fulladd port map(  '0',     '0', S1(0), S1(4), C1(5));
		stage13: fulladd port map(C1(5), Carry1,  S1(1), S1(5), C1(6));
		stage14: fulladd port map(C1(6), Carry1,  S1(2), S1(6), C1(7));
		stage15: fulladd port map(C1(7),    '0',  S1(3), S1(7), Cout(1));
		
		overflow <= Carry1;
		
		
		stage16: hex port map(S(7),S(6),S(5),S(4),S1(7),S1(6),S1(5),S1(4),seg(0),seg(1),seg(2),seg(3),seg(4),seg(5),seg(6),seg(7),seg(8),seg(9),seg(10),seg(11),seg(12),seg(13));
	end adder;
	
	
	
	
	
	
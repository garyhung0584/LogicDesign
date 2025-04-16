library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.lab4_package.all;

entity lab4 is
	port (
		A, B: in std_logic_vector(6 downto 0);
		op: in std_logic_vector(3 downto 0);
		seg: out std_logic_vector(13 downto 0);
		overFlow: out std_logic);
end lab4;

architecture ALU of lab4 is
	signal less: std_logic_vector(6 downto 0);
	signal Cin: std_logic_vector(6 downto 0);
	signal result: std_logic_vector(6 downto 0);
	signal set: std_logic_vector(6 downto 0);
	signal Cout: std_logic_vector(6 downto 0);
begin

	stage0: FOR i in 0 to 6 generate
			stage1: if i = 0 generate
				bit0: ALU1bit port map(A(i), B(i), set(6), op(2), op, result(i), set(i), Cout(i));
			end generate;
			stage2: if i = 6 generate
				bit6: ALU1bit port map(A(i), B(i), '0', Cout(i - 1), op, result(i), set(i), Cout(i));
			end generate;
			stage3: if (i > 0 and i < 6) generate
				bit1: ALU1bit port map(A(i), B(i), '0', Cout(i - 1), op, result(i), set(i), Cout(i));
			end generate;
		end generate;
		
		overFlow <= Cout(6);
	
	out1: hex port map(result(3),result(2), result(1), result(0),seg(0), seg(1), seg(2), seg(3), seg(4), seg(5), seg(6));
	out2: hex port map('0', result(6), result(5), result(4), seg(7),seg(8), seg(9), seg(10), seg(11), seg(12), seg(13));

end ALU;
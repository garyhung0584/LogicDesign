
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
package lab4_package is
	component fulladd
		port (Cin, X, Y: in std_logic;
				s,Cout: out std_logic);
	end component fulladd;

	component hex
	port (
		W,X,Y,Z: IN	STD_LOGIC;
		a,b,c,d,e,f,g: OUT STD_LOGIC);
	END component hex;
	
	component ALU1bit
	port (
		A, B, less, Cin: in std_logic;
		op: in std_logic_vector(3 downto 0);
		result, set, Cout : out std_logic);
	END component ALU1bit;
	
end lab4_package;
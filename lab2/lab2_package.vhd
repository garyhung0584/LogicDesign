
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
package lab2_package is
	component fulladd
		port (Cin, X, y: in std_logic;
				s,Cout: out std_logic);
	end component fulladd;

	component hex
	port (
		W,X,Y,Z, w1, x1, y1, z1: IN	STD_LOGIC;
		a,b,c,d,e,f,g,a1,b1,c1,d1,e1,f1,g1: OUT STD_LOGIC);
	END component hex;

end lab2_package;
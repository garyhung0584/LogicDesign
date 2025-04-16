
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
package lab3_package is
	component fulladd
		port (Cin, X, y: in std_logic;
				s,Cout: out std_logic);
	end component fulladd;

	component hex
	port (
		W,X,Y,Z, w1, x1, y1, z1: IN	STD_LOGIC;
		a,b,c,d,e,f,g,a1,b1,c1,d1,e1,f1,g1: OUT STD_LOGIC);
	END component hex;
	
	component adder4 is
		port( Cin: in std_logic;
				A,B  : in std_logic_vector(3 downto 0);
				R  : out std_logic_vector(3 downto 0);
				Cout : out std_logic);
	END component adder4;
	
	component lab3 is
		port( Cin: in std_logic;
				A,B  : in std_logic_vector(3 downto 0);
				R  : out std_logic_vector(3 downto 0);
				Cout : out std_logic);
	END component lab3;

end lab3_package;
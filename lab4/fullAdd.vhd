
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity fullAdd is
		port (Cin, X, Y: in std_logic;
				s,Cout: out std_logic);
end fullAdd;

ARCHITECTURE func of fullAdd is
begin
	S <= X xor Y xor Cin;
	Cout <= (X and Y) or (X and Cin) or (Y and Cin);
end func;
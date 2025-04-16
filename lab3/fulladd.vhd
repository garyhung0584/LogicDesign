
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity fulladd is
		port (Cin, X, y: in std_logic;
				s,Cout: out std_logic);
end fulladd;

ARCHITECTURE func of fulladd is
begin
	S <= X xor Y xor Cin;
	Cout <= (X and Y) or (X and Cin) or (Y and Cin);
end func;
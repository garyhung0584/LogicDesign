Library ieee;
USE ieee.std_logic_1164.all;

entity hex IS
port (
	W,X,Y,Z: IN	STD_LOGIC;
	a,b,c,d,e,f,g: OUT STD_LOGIC);
END hex;

ARCHITECTURE Digit OF hex IS
BEGIN
    a <= (W and X and not Y) or (X and not Y and not Z) or (W and not X and Y and Z) or (not W and not X and not Y and Z);
    b <= (W and Y and Z) or (W and X and not Z) or (X and Y and not Z) or (not W and X and not Y and Z);
    c <= (not W and not X and Y and not Z) or (W and X and not Z) or (W and X and Y);
    d <= (not X and not Y and Z) or (not W and X and not Y and not Z) or (X and Y and Z) or (W and not X and Y and not Z);
    e <= (not W and Z) or (not W and X and not Y) or (not X and not Y and Z);
    f <= (not W and not X and Z) or (not W and not X and Y) or (not W and Y and Z) or (W and X and not Y);
    g <= (not W and not X and not Y) or (not W and X and Y and Z);
	 
END Digit;


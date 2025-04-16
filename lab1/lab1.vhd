Library ieee;
USE ieee.std_logic_1164.all;

entity lab1 IS
port (
	W,X,Y,Z, w1, x1, y1, z1, w2, x2, y2, z2: IN	STD_LOGIC;
	a,b,c,d,e,f,g,a1,b1,c1,d1,e1,f1,g1,a2,b2,c2,d2,e2,f2,g2: OUT STD_LOGIC);
END lab1;

ARCHITECTURE Digit OF lab1 IS
BEGIN
    a <= (W and X and not Y) or (X and not Y and not Z) or (W and not X and Y and Z) or (not W and not X and not Y and Z);
    b <= (W and Y and Z) or (W and X and not Z) or (X and Y and not Z) or (not W and X and not Y and Z);
    c <= (not W and not X and Y and not Z) or (W and X and not Z) or (W and X and Y);
    d <= (not X and not Y and Z) or (not W and X and not Y and not Z) or (X and Y and Z) or (W and not X and Y and not Z);
    e <= (not W and Z) or (not W and X and not Y) or (not X and not Y and Z);
    f <= (not W and not X and Z) or (not W and not X and Y) or (not W and Y and Z) or (W and X and not Y);
    g <= (not W and not X and not Y) or (not W and X and Y and Z);
	 
	 
    a1 <= (w1 and x1 and not y1) or (x1 and not y1 and not z1) or (w1 and not x1 and y1 and z1) or (not w1 and not x1 and not y1 and z1);
    b1 <= (w1 and y1 and z1) or (w1 and x1 and not z1) or (x1 and y1 and not z1) or (not w1 and x1 and not y1 and z1);
    c1 <= (not w1 and not x1 and y1 and not z1) or (w1 and x1 and not z1) or (w1 and x1 and y1);
    d1 <= (not x1 and not y1 and z1) or (not w1 and x1 and not y1 and not z1) or (x1 and y1 and z1) or (w1 and not x1 and y1 and not z1);
    e1 <= (not w1 and z1) or (not w1 and x1 and not y1) or (not x1 and not y1 and z1);
    f1 <= (not w1 and not x1 and z1) or (not w1 and not x1 and y1) or (not w1 and y1 and z1) or (w1 and x1 and not y1);
    g1 <= (not w1 and not x1 and not y1) or (not w1 and x1 and y1 and z1);
	 
	 
    a2 <= (w2 and x2 and not y2) or (x2 and not y2 and not z2) or (w2 and not x2 and y2 and z2) or (not w2 and not x2 and not y2 and z2);
    b2 <= (w2 and y2 and z2) or (w2 and x2 and not z2) or (x2 and y2 and not z2) or (not w2 and x2 and not y2 and z2);
    c2 <= (not w2 and not x2 and y2 and not z2) or (w2 and x2 and not z2) or (w2 and x2 and y2);
    d2 <= (not x2 and not y2 and z2) or (not w2 and x2 and not y2 and not z2) or (x2 and y2 and z2) or (w2 and not x2 and y2 and not z2);
    e2 <= (not w2 and z2) or (not w2 and x2 and not y2) or (not x2 and not y2 and z2);
    f2 <= (not w2 and not x2 and z2) or (not w2 and not x2 and y2) or (not w2 and y2 and z2) or (w2 and x2 and not y2);
    g2 <= (not w2 and not x2 and not y2) or (not w2 and x2 and y2 and z2);
END Digit;


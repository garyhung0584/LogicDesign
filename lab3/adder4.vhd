
library ieee;
use ieee.std_logic_1164.all;
use work.lab3_package.all;

entity adder4 is
   port( Cin: in std_logic;
          A,B  : in std_logic_vector(0 to 3);
          R  : out std_logic_vector(0 to 3);
          Cout : out std_logic);
end adder4;
 
architecture struct of adder4 is
	signal C1, C2, C3, C4: std_logic;
	signal TMP: std_logic_vector(0 to 3);
 
begin
	FA0:fulladd port map(Cin, A(0),B(0), R(0),C1);
	FA1:fulladd port map(C1, A(1),B(1), R(1),C2);
	FA2:fulladd port map(C2, A(2),B(2), R(2),C3);
	FA3:fulladd port map(C3, A(3),B(3), R(3),C4);

	Cout <= C4;

end struct;

library ieee;
use ieee.std_logic_1164.all;

entity hex is 
port( input: in std_logic_vector(3 downto 0);
		output: out std_logic_vector(6 downto 0));
end hex;

architecture func of hex is
begin
		output(0) <=  ((not input(3)) and (not input(2)) and (not input(1))  and (input(0))) or ((not input(3)) and (input(2)) and (not input(1))  and (not input(0)))  or ((input(3)) and (not input(2)) and (input(1))  and (input(0))) or ((input(3)) and (input(2)) and (not input(1))  and (not input(0))) or ((input(3)) and (input(2)) and (not input(1))  and (input(0)));
		output(1) <=  ((not input(3)) and (input(2)) and (not input(1))  and (input(0))) or ((not input(3)) and (input(2)) and (input(1))  and (not input(0)))  or ((input(3)) and (not input(2)) and (input(1))  and (input(0))) or ((input(3)) and (input(2)) and (not input(1))  and (not input(0))) or ((input(3)) and (input(2)) and (input(1))  and (not input(0))) or ((input(3)) and (input(2)) and (input(1))  and (input(0)));
		output(2) <=  ((not input(3)) and (not input(2)) and (input(1))  and (not input(0))) or ((input(3)) and (input(2)) and (not input(0))) or ((input(3)) and (input(2)) and (input(1)));
		output(3) <=  ((not input(2)) and (not input(1))  and (input(0))) or ((not input(3)) and (input(2)) and (not input(1))  and (not input(0))) or ((input(2)) and (input(1))  and (input(0))) or ((input(3)) and (not input(2)) and (input(1))  and (not input(0)));
		output(4) <=  ((not input(3)) and (input(0))) or ((not input(3)) and (input(2)) and (not input(1))) or ((not input(2)) and (not input(1))  and (input(0)));
		output(5) <=  ((not input(3)) and (not input(2)) and (input(0))) or ((not input(3)) and (not input(2)) and (input(1))) or ((not input(3)) and (input(1))  and (input(0))) or ((input(3)) and (input(2)) and (not input(1)));
		output(6) <=  ((not input(3)) and (not input(2)) and (not input(1))) or ((not input(3)) and (input(2)) and (input(1))  and (input(0)));
		
END func;

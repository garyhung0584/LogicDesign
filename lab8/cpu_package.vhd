library ieee;
use ieee.std_logic_1164.all;

package cpu_package is

	component hex
		port( input: in std_logic_vector(3 downto 0);
				output: out std_logic_vector(6 downto 0));
	end component hex;
	
end cpu_package;
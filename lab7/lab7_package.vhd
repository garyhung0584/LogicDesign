library ieee;
use ieee.std_logic_1164.all;

package lab7_package is
	component FSM is
		port(
			clk, reset, w: in std_logic;
			output: out std_logic_vector(2 downto 0)
		);
	end component FSM;
	
	component SReg is
		generic (N: INTEGER := 8);
		port(
			clk    : in std_logic;
			clear  : in std_logic;
			load   : in std_logic;
			lr_sel : in std_logic;
			di     : in std_logic_vector(N-1 downto 0);
			sdi    : in std_logic;
			qo     : buffer std_logic_vector(N-1 downto 0)
			);
	end component SReg;
	
	component divider is
		port(
			clk, clear: in std_logic;
			Divisor, Dividend: in std_logic_vector(7 downto 0);
			Remainder: buffer std_logic_vector(16 downto 0)
		);
	end component divider;
	
	component seven_seg_encoder is
		port (
			hex : in  std_logic_vector(3 downto 0);
			seg : out std_logic_vector(6 downto 0)
		);
	end component seven_seg_encoder;
end package;
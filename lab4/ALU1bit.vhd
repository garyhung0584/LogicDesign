library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.lab4_package.all;

entity ALU1bit is
port (
	A, B, less, Cin: in std_logic;
	op: in std_logic_vector(3 downto 0);
	result, set, Cout : out std_logic);
end entity;

architecture ALU of ALU1bit is
    signal AInvert, BNegate : std_logic;
    signal AIN, BIN         : std_logic;
    signal ResultAND        : std_logic;
    signal ResultOR         : std_logic;
    signal ResultAdd        : std_logic;
	 
	begin
	
	AInvert <= not A;
	BNegate <= not B;
	
	AIN <= A when op(3) = '0' else AInvert;
	BIN <= B when op(2) = '0' else BNegate;
	
	ResultAND <= AIN and BIN;
	ResultOR <= AIN or BIN;

	set <= ResultAdd;
	
	stage0: fullAdd port map(Cin, AIN, BIN, ResultAdd, Cout);
	
	result <= ResultAND when op(1 downto 0) = "00" else
				 ResultOR when op (1 downto 0) = "01" else
				 ResultAdd when op (1 downto 0) = "10" else
				 less when op (1 downto 0) = "11";


	end ALU;
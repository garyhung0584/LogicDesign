library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use work.lab3_package.all;

entity lab3_sub is
    port (
        X   : in std_logic_vector(0 to 7);
        Y   : in std_logic_vector(0 to 7);
		  overFlow:out std_logic;
        seg : out std_logic_vector(0 to 13)
    );
end lab3_sub;

architecture subtractor of lab3_sub is
    signal C       : std_logic_vector(0 to 7);
    signal S       : std_logic_vector(0 to 7);
    signal temp    : std_logic_vector(0 to 7);

    signal Borrow  : std_logic;
    signal Borrow1  : std_logic;
    signal borrower  : std_logic_vector(0 to 3);
    signal BorrowN  : std_logic_vector(0 to 3);
	 
    signal YNOT   : std_logic_vector(0 to 7);
begin
	YNOT <= not Y;
	
	stage1: adder4 port map('1', X(0 to 3), YNOT(0 to 3), temp(0 to 3), C(2));
	stage2: adder4 port map('1', X(4 to 7), YNOT(4 to 7), borrower(0 to 3), C(3));
	
	Borrow  <= (temp(3) and temp(2)) or (temp(3) and temp(1)) or not C(2);
	Borrow1 <= (temp(7) and temp(6)) or (temp(7) and temp(5)) or not C(3);
	BorrowN <= not Borrow & "111";
	
	stage3: adder4 port map('1', BorrowN, borrower(0 to 3), temp(4 to 7), C(4));

	stage4: adder4 port map('0', ( '0' & Borrow & '0' & Borrow), temp(0 to 3), S(0 to 3), C(5));
	stage5: adder4 port map('0', ( '0' & Borrow1 & '0' & Borrow1), temp(4 to 7), S(4 to 7), C(6));
	
	overFlow <= Borrow1;
	
	
    -- Output to 7-segment display
    stage7: hex port map(
        S(3), S(2), S(1), S(0), S(7), S(6), S(5), S(4),
        seg(0), seg(1), seg(2), seg(3), seg(4), seg(5), seg(6), seg(7),
        seg(8), seg(9), seg(10), seg(11), seg(12), seg(13)
    );

end subtractor;

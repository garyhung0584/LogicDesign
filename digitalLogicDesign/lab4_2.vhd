library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity lab4_2 is 
    port (
        X   : in std_logic_vector(3 downto 0);
        Y   : in std_logic_vector(3 downto 0);
        seg : out std_logic_vector(13 downto 0)
    );
end lab4_2;

architecture multiplier of lab4_2 is
    signal Output : std_logic_vector(7 downto 0);
	 signal enable : std_logic;

    component hex
        port (
            W, X, Y, Z, en : in std_logic;
            a, b, c, d, e, f, g : out std_logic
        );
    end component;
    
    signal product  : unsigned(7 downto 0);
    signal tens     : unsigned(3 downto 0);
    signal ones     : unsigned(3 downto 0);

begin

    process(X, Y)
        variable UX, UY : unsigned(3 downto 0);
        variable result : unsigned(7 downto 0);
        variable temp   : integer;
    begin
        UX := unsigned(X);
        UY := unsigned(Y);
        result := UX * UY;
        temp := to_integer(result);

        ones <= to_unsigned(temp mod 10, 4);
        tens <= to_unsigned(temp / 10, 4);

        Output(3 downto 0) <= std_logic_vector(ones);
        Output(7 downto 4) <= std_logic_vector(tens);
    end process;
	 
	 enable <= Output(7) or Output(6) or Output(5) or Output(4);
	 
    segment0: hex port map(
        Output(3), Output(2), Output(1), Output(0), '1',
        seg(0), seg(1), seg(2), seg(3), seg(4), seg(5), seg(6)
    );

    segment1: hex port map(
        Output(7), Output(6), Output(5), Output(4), enable,
        seg(7), seg(8), seg(9), seg(10), seg(11), seg(12), seg(13)
    );

end multiplier;

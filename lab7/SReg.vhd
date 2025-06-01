library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SReg is 
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
end SReg;

architecture shifter of SReg is
    signal q : std_logic_vector(N-1 downto 0);
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if load = '1' then
                q <= di;
            elsif clear = '1' then
                q <= (others => '0');
            elsif lr_sel = '1' then
                for i in N-1 downto 1 loop
                    q(i) <= q(i-1);
                end loop;
                q(0) <= sdi;
            else
                for i in 0 to N-2 loop
                    q(i) <= q(i+1);
                end loop;
                q(N-1) <= sdi;
            end if;
        end if;
    end process;

    qo <= q;
end shifter;

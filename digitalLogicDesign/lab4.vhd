library ieee;
use ieee.std_logic_1164.all;

entity lab4 is
	port(
		X:in std_logic_vector(0 to 7);
		seg: out std_logic_vector(0 to 6));
	end lab4;
	
ARCHITECTURE priority_encoder of lab4 is
	signal Output: std_logic_vector(3 downto 0);
	signal enable: std_logic;
	
	 component hex
        port(
            W,X,Y,Z,en: in std_logic;
            a,b,c,d,e,f,g: out std_logic);
    end component;
 begin
    process (X)
		begin
        if X(7) = '1' then
            Output <= "0111";
            enable <= '1';
        elsif X(6) = '1' then
            Output <= "0110";
            enable <= '1';
        elsif X(5) = '1' then
            Output <= "0101";
            enable <= '1';
        elsif X(4) = '1' then 
            Output <= "0100";
            enable <= '1';
        elsif X(3) = '1' then
            Output <= "0011";
            enable <= '1';
        elsif X(2) = '1' then
            Output <= "0010";
            enable <= '1';
        elsif X(1) = '1' then
            Output <= "0001";
            enable <= '1';
        elsif X(0) = '1' then
            Output <= "0000";
            enable <= '1';
        else
				output <= "0000";
            enable <= '0';
        end if;
		  
    end process;
		  
		  stage0: hex port map(Output(3),Output(2),Output(1),Output(0), enable,seg(0),seg(1),seg(2),seg(3),seg(4),seg(5),seg(6));

		  
  end ARCHITECTURE;
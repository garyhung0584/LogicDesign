library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity FSM is
	port(
		clk, reset, w: in std_logic;
		output: out std_logic_vector(2 downto 0)
	);
end;

architecture logicfun of FSM is
	type state_type is (S0, S1, S2a, S2b, S3, S4);
	signal state, next_state: state_type;
begin
	process(clk, reset)
	begin
		if reset = '1' then
			state <= S0;
		elsif rising_edge(clk) then
			state <= next_state;
		end if;
	end process;

	process(state, w)
	begin
		case state is
			when S0 =>
				if w = '1' then
					next_state <= S1;
				else
					next_state <= S0;
				end if;

			when S1 =>
				if w = '0' then
					next_state <= S2a;
				else
					next_state <= S2b;
				end if;

			when S2a =>
				next_state <= S3;

			when S2b =>
				next_state <= S3;

			when S3 =>
				if w = '1' then
					next_state <= S4;
				else
					next_state <= S1;
				end if;
			when S4 =>
					next_state <= S4;
			when others =>
				null;
		end case;
	end process;
	
	process(state)
	begin
		case state is
			when S0 => output <= "000";
			when S1 => output <= "001";
			when S2a => output <= "010";
			when S2b => output <= "011";
			when S3 => output <= "100";
			when S4 => output <= "101";
			when others => output <= "000";
		end case;
	end process;

end logicfun;
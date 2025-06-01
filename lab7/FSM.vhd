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
	type state_type is (IDLE, LOAD, SHIFT, SUB, CHECK, DONE);
	signal state, next_state: state_type;
begin
	process(clk, reset)
	begin
		if reset = '1' then
			state <= IDLE;
		elsif rising_edge(clk) then
			state <= next_state;
		end if;
	end process;

	process(state, w)
	begin
		case state is
			when IDLE =>
				if w = '1' then
					next_state <= LOAD;
				else
					next_state <= IDLE;
				end if;
			when LOAD =>
				next_state <= SHIFT;
			when SHIFT =>
				next_state <= SUB;
			when SUB =>
				next_state <= CHECK;
			when CHECK =>
				if w = '1' then -- w=1 means done (count reached)
					next_state <= DONE;
				else
					next_state <= SHIFT;
				end if;
			when DONE =>
				if w = '0' then -- w=0 means reset
					next_state <= IDLE;
				else
					next_state <= DONE;
				end if;
			when others =>
				next_state <= IDLE;
		end case;
	end process;

	process(state)
	begin
		case state is
			when IDLE   => output <= "000";
			when LOAD   => output <= "001";
			when SHIFT  => output <= "010";
			when SUB    => output <= "011";
			when CHECK  => output <= "100";
			when DONE   => output <= "101";
			when others => output <= "000";
		end case;
	end process;

end logicfun;
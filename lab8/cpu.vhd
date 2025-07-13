LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_signed.all;
USE ieee.numeric_std.all;
USE work.cpu_package.all;

ENTITY cpu IS
	PORT(	Clock	:IN	STD_LOGIC;
			Fetch_led, ID_led, Execution_led, WriteBack_led, Hazard	:OUT	STD_LOGIC;
			data				:IN	STD_LOGIC_VECTOR(7 downto 0);
			opcode			:IN	STD_LOGIC_VECTOR(3 downto 0);
			codeRS, codeRT	:IN	STD_LOGIC_VECTOR(1 downto 0);
			hex0, hex1, hex2, hex3, hex4, hex5:OUT STD_LOGIC_VECTOR(6 downto 0);
			RS, RT:BUFFER STD_LOGIC_VECTOR(7 downto 0);
			LEDR : OUT STD_LOGIC_VECTOR(7 downto 0)
			);
END cpu;

ARCHITECTURE Behavior OF cpu IS
	signal R0, R1, R2, R3: STD_LOGIC_VECTOR(7 downto 0);
	
	TYPE State_type2 IS(Fetch,ID,Execution,WriteBack);
	SIGNAL register1,register2,register3,register4 : State_type2;
	signal RS1, RT1, RS2, RT2, RS3, RT3, RS4, RT4: STD_LOGIC_VECTOR(7 downto 0);
	signal data1, data2, data3, data4 : STD_LOGIC_VECTOR(7 downto 0);
	signal codeRS1, codeRT1, codeRS2, codeRT2, codeRS3, codeRT3, codeRS4, codeRT4: STD_LOGIC_VECTOR(1 downto 0);
	signal opcode1, opcode2, opcode3, opcode4: STD_LOGIC_VECTOR(3 downto 0);
	
BEGIN
	PROCESS(Clock, RS, RT)
	BEGIN
		IF(Clock'EVENT AND Clock='1')THEN
			IF(opcode="1110") THEN -- Reset condition
				register1<=Fetch;
				register2<=WriteBack;
				register3<=Execution;
				register4<=ID;
				opcode1 <= "1111";
				opcode2 <= "1111";
				opcode3 <= "1111";
				opcode4 <= "1111";
								
			ELSE
				CASE register1 IS
					WHEN Fetch=>
						opcode1<=opcode;
						codeRS1<=codeRS;
						codeRT1<=codeRT;
						register1<=ID;
						register2<=Fetch;
						data1<=data;
						
						IF(opcode = "1111")THEN
							Fetch_led <= '0';
						ELSE
							Fetch_led <= '1';
						END IF;
					WHEN ID=>
							
						IF(opcode4 /= "1111" AND opcode1 /= "1111" AND (codeRS1 = codeRS4 or codeRT1 = codeRS4))THEN
							Hazard <= '1';
							IF(codeRS1 = codeRS4 AND codeRT1 = codeRS4)THEN
								CASE opcode4 IS
									WHEN "0000" =>
										RS1 <= data4;
										RT1 <= data4;
									WHEN "0001" =>
										RS1 <= RT4;
										RT1 <= RT4;
									WHEN "0010" =>
										RS1 <= (RS4 + RT4);
										RT1 <= (RS4 + RT4);
									WHEN "0011" => -- AND
										RS1 <= (RS4 AND RT4);
										RT1 <= (RS4 AND RT4);
									WHEN "0100" => -- SLT
										IF(RS4<RT4)THEN
											RS1 <= "00000001";
											RT1 <= "00000001";
										ELSE
											RS1 <= "00000000";
											RT1 <= "00000000";
										END IF;
									WHEN "0101" => -- SUB
										RS1 <= (RS4 - RT4);
										RT1 <= (RS4 - RT4);
									WHEN "0110" => -- NOR
										RS1 <= (RS4 NOR RT4);
										RT1 <= (RS4 NOR RT4);
									WHEN OTHERS =>
								END CASE;
							
							ELSIF(codeRS1 = codeRS4)THEN
								
								CASE opcode4 IS
									WHEN "0000" => RS1 <= data4;
									WHEN "0001" => RS1 <= RT4;
									WHEN "0010" => RS1 <= (RS4 + RT4);
									WHEN "0011" => RS1 <= (RS4 AND RT4);
									WHEN "0100" => -- SLT
										IF(RS4<RT4)THEN
											RS1 <= "00000001";
										ELSE
											RS1 <= "00000000";
										END IF;
									WHEN "0101" => RS1 <= (RS4 - RT4);
									WHEN "0110" => RS1 <= (RS4 NOR RT4);
									WHEN OTHERS =>
								END CASE;
								
								CASE codeRT1 IS
									WHEN "00" => RT1 <= R0;
									WHEN "01" => RT1 <= R1;
									WHEN "10" => RT1 <= R2;
									WHEN "11" => RT1 <= R3;
								END CASE;
							
							ELSIF(codeRT1 = codeRS4)THEN
								
								CASE opcode4 IS
									WHEN "0000" => RT1 <= data4;
									WHEN "0001" => RT1 <= RT4;
									WHEN "0010" => RT1 <= (RS4 + RT4);
									WHEN "0011" => RT1 <= (RS4 AND RT4);
									WHEN "0100" => -- SLT
										IF(RS4<RT4)THEN
											RT1 <= "00000001";
										ELSE
											RT1 <= "00000000";
										END IF;
									WHEN "0101" => RT1 <= (RS4 - RT4);
									WHEN "0110" => RT1 <= (RS4 NOR RT4);
									WHEN OTHERS =>
								END CASE;
								
								CASE codeRS1 IS
									WHEN "00" => RS1 <= R0;
									WHEN "01" => RS1 <= R1;
									WHEN "10" => RS1 <= R2;
									WHEN "11" => RS1 <= R3;
								END CASE;
							END IF;
							
						ELSE
							Hazard <= '0';
							CASE codeRS1 IS
								WHEN "00" => RS1 <= R0;
								WHEN "01" => RS1 <= R1;
								WHEN "10" => RS1 <= R2;
								WHEN "11" => RS1 <= R3;
							END CASE;

							CASE codeRT1 IS
								WHEN "00" => RT1 <= R0;
								WHEN "01" => RT1 <= R1;
								WHEN "10" => RT1 <= R2;
								WHEN "11" => RT1 <= R3;
							END CASE;
						END IF;
						
						IF(opcode1 = "1111")THEN
							ID_led <= '0';
						ELSE
							ID_led <= '1';
						END IF;
						register1<=Execution;
					WHEN Execution=>
						
						IF(opcode /= "1111" AND opcode1 /= "1111" AND (codeRS = codeRS1 or codeRT = codeRS1))THEN
							CASE opcode1 IS
								WHEN "0000" =>
									CASE codeRS1 IS
										WHEN "00" => R0 <= data1;
										WHEN "01" => R1 <= data1;
										WHEN "10" => R2 <= data1;
										WHEN "11" => R3 <= data1;
									END CASE;
								WHEN "0001" =>
									CASE codeRS1 IS
										WHEN "00" => R0 <= RT1;
										WHEN "01" => R1 <= RT1;
										WHEN "10" => R2 <= RT1;
										WHEN "11" => R3 <= RT1;
									END CASE;
								WHEN "0010" =>
									CASE codeRS1 IS
										WHEN "00" => R0 <= (RS1+RT1);
										WHEN "01" => R1 <= (RS1+RT1);
										WHEN "10" => R2 <= (RS1+RT1);
										WHEN "11" => R3 <= (RS1+RT1);
									END CASE;
								WHEN "0011" => -- AND
									CASE codeRS1 IS
										WHEN "00" => R0 <= (RS1 AND RT1);
										WHEN "01" => R1 <= (RS1 AND RT1);
										WHEN "10" => R2 <= (RS1 AND RT1);
										WHEN "11" => R3 <= (RS1 AND RT1);
									END CASE;
								WHEN "0100" => -- SLT
									IF(RS1<RT1)THEN
										CASE codeRS1 IS
											WHEN "00" => R0 <= "00000001";
											WHEN "01" => R1 <= "00000001";
											WHEN "10" => R2 <= "00000001";
											WHEN "11" => R3 <= "00000001";
										END CASE;
									ELSE
										CASE codeRS1 IS
											WHEN "00" => R0 <= "00000000";
											WHEN "01" => R1 <= "00000000";
											WHEN "10" => R2 <= "00000000";
											WHEN "11" => R3 <= "00000000";
										END CASE;
									END IF;
								WHEN "0101" => -- SUB
									CASE codeRS1 IS
										WHEN "00" => R0 <= (RS1 - RT1);
										WHEN "01" => R1 <= (RS1 - RT1);
										WHEN "10" => R2 <= (RS1 - RT1);
										WHEN "11" => R3 <= (RS1 - RT1);
									END CASE;
								WHEN "0110" => -- NOR
									CASE codeRS1 IS
										WHEN "00" => R0 <= (RS1 NOR RT1);
										WHEN "01" => R1 <= (RS1 NOR RT1);
										WHEN "10" => R2 <= (RS1 NOR RT1);
										WHEN "11" => R3 <= (RS1 NOR RT1);
									END CASE;
								WHEN OTHERS =>
							END CASE;
						END IF;
						
						CASE opcode1 IS
							WHEN "0000" => RS1 <= data1;
							WHEN "0001" => RS1 <= RT1;
							WHEN "0010" => RS1 <= (RS1+RT1);
							WHEN "0011" => RS1 <= (RS1 AND RT1); -- AND
							WHEN "0100" => -- SLT
								IF(RS1<RT1)THEN
									RS1 <= "00000001";
								ELSE
									RS1 <= "00000000";
								END IF;
							WHEN "0101" => RS1 <= (RS1 - RT1); -- SUB
							WHEN "0110" => RS1 <= (RS1 NOR RT1); -- NOR
							WHEN OTHERS =>
						END CASE;
						
						LEDR <= RS1;
						
						IF(opcode1 = "1111")THEN
							Execution_led <= '0';
						ELSE
							Execution_led <= '1';
						END IF;
						register1<=WriteBack;
					WHEN WriteBack=>
						IF(opcode1 /= "1111")THEN
							CASE codeRS1 IS
								WHEN "00" => R0 <= RS1;
								WHEN "01" => R1 <= RS1;
								WHEN "10" => R2 <= RS1;
								WHEN "11" => R3 <= RS1;
							END CASE;
						END IF;
						
						IF(opcode1 = "1111")THEN
							WriteBack_led <= '0';
						ELSE
							WriteBack_led <= '1';
						END IF;
				END CASE;
				
				CASE register2 IS
					WHEN Fetch=>
						opcode2<=opcode;
						codeRS2<=codeRS;
						codeRT2<=codeRT;
						register2<=ID;
						register3<=Fetch;
						data2<=data;
						
						IF(opcode = "1111")THEN
							Fetch_led <= '0';
						ELSE
							Fetch_led <= '1';
						END IF;
					WHEN ID=>
						
						IF(opcode1 /= "1111"  AND opcode2 /= "1111" AND (codeRS2 = codeRS1 or codeRT2 = codeRS1))THEN
							Hazard <= '1';
							IF(codeRS2 = codeRS1 AND codeRT2 = codeRS1)THEN
								CASE opcode1 IS
									WHEN "0000" => RS2 <= data1; RT2 <= data1;
									WHEN "0001" => RS2 <= RT1; RT2 <= RT1;
									WHEN "0010" => RS2 <= (RS1+RT1); RT2 <= (RS1+RT1);
									WHEN "0011" => RS2 <= (RS1 AND RT1); RT2 <= (RS1 AND RT1);
									WHEN "0100" => IF(RS1<RT1)THEN RS2 <= "00000001"; RT2 <= "00000001"; ELSE RS2 <= "00000000"; RT2 <= "00000000"; END IF;
									WHEN "0101" => RS2 <= (RS1 - RT1); RT2 <= (RS1 - RT1);
									WHEN "0110" => RS2 <= (RS1 NOR RT1); RT2 <= (RS1 NOR RT1);
									WHEN OTHERS =>
								END CASE;
								
							ELSIF(codeRS2 = codeRS1)THEN
								CASE opcode1 IS
									WHEN "0000" => RS2 <= data1;
									WHEN "0001" => RS2 <= RT1;
									WHEN "0010" => RS2 <= (RS1+RT1);
									WHEN "0011" => RS2 <= (RS1 AND RT1);
									WHEN "0100" => IF(RS1<RT1)THEN RS2 <= "00000001"; ELSE RS2 <= "00000000"; END IF;
									WHEN "0101" => RS2 <= (RS1 - RT1);
									WHEN "0110" => RS2 <= (RS1 NOR RT1);
									WHEN OTHERS =>
								END CASE;
								
								CASE codeRT2 IS
									WHEN "00" => RT2 <= R0;
									WHEN "01" => RT2 <= R1;
									WHEN "10" => RT2 <= R2;
									WHEN "11" => RT2 <= R3;
								END CASE;
							
							ELSIF(codeRT2 = codeRS1)THEN
								CASE opcode1 IS
									WHEN "0000" => RT2 <= data1;
									WHEN "0001" => RT2 <= RT1;
									WHEN "0010" => RT2 <= (RS1+RT1);
									WHEN "0011" => RT2 <= (RS1 AND RT1);
									WHEN "0100" => IF(RS1<RT1)THEN RT2 <= "00000001"; ELSE RT2 <= "00000000"; END IF;
									WHEN "0101" => RT2 <= (RS1 - RT1);
									WHEN "0110" => RT2 <= (RS1 NOR RT1);
									WHEN OTHERS =>
								END CASE;
								
								CASE codeRS2 IS
									WHEN "00" => RS2 <= R0;
									WHEN "01" => RS2 <= R1;
									WHEN "10" => RS2 <= R2;
									WHEN "11" => RS2 <= R3;
								END CASE;
							END IF;
							
						ELSE
							Hazard <= '0';
							CASE codeRS2 IS
								WHEN "00" => RS2 <= R0;
								WHEN "01" => RS2 <= R1;
								WHEN "10" => RS2 <= R2;
								WHEN "11" => RS2 <= R3;
							END CASE;

							CASE codeRT2 IS
								WHEN "00" => RT2 <= R0;
								WHEN "01" => RT2 <= R1;
								WHEN "10" => RT2 <= R2;
								WHEN "11" => RT2 <= R3;
							END CASE;
						END IF;
						
						IF(opcode2 = "1111")THEN
							ID_led <= '0';
						ELSE
							ID_led <= '1';
						END IF;
						register2<=Execution;
					WHEN Execution=>
						
						IF(opcode /= "1111" AND opcode2 /= "1111" AND (codeRS = codeRS2 or codeRT = codeRS2))THEN
							CASE opcode2 IS
								WHEN "0000" => CASE codeRS2 IS WHEN "00"=>R0<=data2; WHEN "01"=>R1<=data2; WHEN "10"=>R2<=data2; WHEN "11"=>R3<=data2; END CASE;
								WHEN "0001" => CASE codeRS2 IS WHEN "00"=>R0<=RT2; WHEN "01"=>R1<=RT2; WHEN "10"=>R2<=RT2; WHEN "11"=>R3<=RT2; END CASE;
								WHEN "0010" => CASE codeRS2 IS WHEN "00"=>R0<=(RS2+RT2); WHEN "01"=>R1<=(RS2+RT2); WHEN "10"=>R2<=(RS2+RT2); WHEN "11"=>R3<=(RS2+RT2); END CASE;
								WHEN "0011" => CASE codeRS2 IS WHEN "00"=>R0<=(RS2 AND RT2); WHEN "01"=>R1<=(RS2 AND RT2); WHEN "10"=>R2<=(RS2 AND RT2); WHEN "11"=>R3<=(RS2 AND RT2); END CASE;
								WHEN "0100" => IF(RS2<RT2)THEN CASE codeRS2 IS WHEN "00"=>R0<="00000001"; WHEN "01"=>R1<="00000001"; WHEN "10"=>R2<="00000001"; WHEN "11"=>R3<="00000001"; END CASE; ELSE CASE codeRS2 IS WHEN "00"=>R0<="00000000"; WHEN "01"=>R1<="00000000"; WHEN "10"=>R2<="00000000"; WHEN "11"=>R3<="00000000"; END CASE; END IF;
								WHEN "0101" => CASE codeRS2 IS WHEN "00"=>R0<=(RS2-RT2); WHEN "01"=>R1<=(RS2-RT2); WHEN "10"=>R2<=(RS2-RT2); WHEN "11"=>R3<=(RS2-RT2); END CASE;
								WHEN "0110" => CASE codeRS2 IS WHEN "00"=>R0<=(RS2 NOR RT2); WHEN "01"=>R1<=(RS2 NOR RT2); WHEN "10"=>R2<=(RS2 NOR RT2); WHEN "11"=>R3<=(RS2 NOR RT2); END CASE;
								WHEN OTHERS =>
							END CASE;
						END IF;
						
						CASE opcode2 IS
							WHEN "0000" => RS2 <= data2;
							WHEN "0001" => RS2 <= RT2;
							WHEN "0010" => RS2 <= (RS2+RT2);
							WHEN "0011" => RS2 <= (RS2 AND RT2);
							WHEN "0100" => IF(RS2<RT2)THEN RS2 <= "00000001"; ELSE RS2 <= "00000000"; END IF;
							WHEN "0101" => RS2 <= (RS2 - RT2);
							WHEN "0110" => RS2 <= (RS2 NOR RT2);
							WHEN OTHERS =>
						END CASE;
						
						LEDR <= RS2;
						
						IF(opcode2 = "1111")THEN
							Execution_led <= '0';
						ELSE
							Execution_led <= '1';
						END IF;
						register2<=WriteBack;
						
					WHEN WriteBack=>
						IF(opcode2 /= "1111")THEN
							CASE codeRS2 IS
								WHEN "00" => R0 <= RS2;
								WHEN "01" => R1 <= RS2;
								WHEN "10" => R2 <= RS2;
								WHEN "11" => R3 <= RS2;
							END CASE;
						END IF;
						
						IF(opcode2 = "1111")THEN
							WriteBack_led <= '0';
						ELSE
							WriteBack_led <= '1';
						END IF;
				END CASE;
				
				
				CASE register3 IS
					WHEN Fetch=>
						opcode3<=opcode;
						codeRS3<=codeRS;
						codeRT3<=codeRT;
						register3<=ID;
						register4<=Fetch;
						data3<=data;
						
						IF(opcode = "1111")THEN
							Fetch_led <= '0';
						ELSE
							Fetch_led <= '1';
						END IF;
					WHEN ID=>
						
						IF(opcode2 /= "1111" AND opcode3 /= "1111" AND (codeRS3 = codeRS2 or codeRT3 = codeRS2))THEN
							Hazard <= '1';
							IF(codeRS3 = codeRS2 AND codeRT3 = codeRS2)THEN
								CASE opcode2 IS
									WHEN "0000" => RS3 <= data2; RT3 <= data2;
									WHEN "0001" => RS3 <= RT2; RT3 <= RT2;
									WHEN "0010" => RS3 <= (RS2+RT2); RT3 <= (RS2+RT2);
									WHEN "0011" => RS3 <= (RS2 AND RT2); RT3 <= (RS2 AND RT2);
									WHEN "0100" => IF(RS2<RT2)THEN RS3 <= "00000001"; RT3 <= "00000001"; ELSE RS3 <= "00000000"; RT3 <= "00000000"; END IF;
									WHEN "0101" => RS3 <= (RS2 - RT2); RT3 <= (RS2 - RT2);
									WHEN "0110" => RS3 <= (RS2 NOR RT2); RT3 <= (RS2 NOR RT2);
									WHEN OTHERS =>
								END CASE;
							
							ELSIF(codeRS3 = codeRS2)THEN
								
								CASE opcode2 IS
									WHEN "0000" => RS3 <= data2;
									WHEN "0001" => RS3 <= RT2;
									WHEN "0010" => RS3 <= (RS2+RT2);
									WHEN "0011" => RS3 <= (RS2 AND RT2);
									WHEN "0100" => IF(RS2<RT2)THEN RS3 <= "00000001"; ELSE RS3 <= "00000000"; END IF;
									WHEN "0101" => RS3 <= (RS2 - RT2);
									WHEN "0110" => RS3 <= (RS2 NOR RT2);
									WHEN OTHERS =>
								END CASE;
								
								CASE codeRT3 IS
									WHEN "00" => RT3 <= R0;
									WHEN "01" => RT3 <= R1;
									WHEN "10" => RT3 <= R2;
									WHEN "11" => RT3 <= R3;
								END CASE;
							
							ELSIF(codeRT3 = codeRS2)THEN
								
								CASE opcode2 IS
									WHEN "0000" => RT3 <= data2;
									WHEN "0001" => RT3 <= RT2;
									WHEN "0010" => RT3 <= (RS2+RT2);
									WHEN "0011" => RT3 <= (RS2 AND RT2);
									WHEN "0100" => IF(RS2<RT2)THEN RT3 <= "00000001"; ELSE RT3 <= "00000000"; END IF;
									WHEN "0101" => RT3 <= (RS2 - RT2);
									WHEN "0110" => RT3 <= (RS2 NOR RT2);
									WHEN OTHERS =>
								END CASE;
								
								CASE codeRS3 IS
									WHEN "00" => RS3 <= R0;
									WHEN "01" => RS3 <= R1;
									WHEN "10" => RS3 <= R2;
									WHEN "11" => RS3 <= R3;
								END CASE;
								
							END IF;
							
						ELSE
							Hazard <= '0';
							CASE codeRS3 IS
								WHEN "00" => RS3 <= R0;
								WHEN "01" => RS3 <= R1;
								WHEN "10" => RS3 <= R2;
								WHEN "11" => RS3 <= R3;
							END CASE;

							CASE codeRT3 IS
								WHEN "00" => RT3 <= R0;
								WHEN "01" => RT3 <= R1;
								WHEN "10" => RT3 <= R2;
								WHEN "11" => RT3 <= R3;
							END CASE;
						END IF;
						
						IF(opcode3 = "1111")THEN
							ID_led <= '0';
						ELSE
							ID_led <= '1';
						END IF;
						register3<=Execution;
					WHEN Execution=>
						
						IF(opcode /= "1111" AND opcode3 /= "1111" AND (codeRS = codeRS3 or codeRT = codeRS3))THEN
							CASE opcode3 IS
								WHEN "0000" => CASE codeRS3 IS WHEN "00"=>R0<=data3; WHEN "01"=>R1<=data3; WHEN "10"=>R2<=data3; WHEN "11"=>R3<=data3; END CASE;
								WHEN "0001" => CASE codeRS3 IS WHEN "00"=>R0<=RT3; WHEN "01"=>R1<=RT3; WHEN "10"=>R2<=RT3; WHEN "11"=>R3<=RT3; END CASE;
								WHEN "0010" => CASE codeRS3 IS WHEN "00"=>R0<=(RS3+RT3); WHEN "01"=>R1<=(RS3+RT3); WHEN "10"=>R2<=(RS3+RT3); WHEN "11"=>R3<=(RS3+RT3); END CASE;
								WHEN "0011" => CASE codeRS3 IS WHEN "00"=>R0<=(RS3 AND RT3); WHEN "01"=>R1<=(RS3 AND RT3); WHEN "10"=>R2<=(RS3 AND RT3); WHEN "11"=>R3<=(RS3 AND RT3); END CASE;
								WHEN "0100" => IF(RS3<RT3)THEN CASE codeRS3 IS WHEN "00"=>R0<="00000001"; WHEN "01"=>R1<="00000001"; WHEN "10"=>R2<="00000001"; WHEN "11"=>R3<="00000001"; END CASE; ELSE CASE codeRS3 IS WHEN "00"=>R0<="00000000"; WHEN "01"=>R1<="00000000"; WHEN "10"=>R2<="00000000"; WHEN "11"=>R3<="00000000"; END CASE; END IF;
								WHEN "0101" => CASE codeRS3 IS WHEN "00"=>R0<=(RS3-RT3); WHEN "01"=>R1<=(RS3-RT3); WHEN "10"=>R2<=(RS3-RT3); WHEN "11"=>R3<=(RS3-RT3); END CASE;
								WHEN "0110" => CASE codeRS3 IS WHEN "00"=>R0<=(RS3 NOR RT3); WHEN "01"=>R1<=(RS3 NOR RT3); WHEN "10"=>R2<=(RS3 NOR RT3); WHEN "11"=>R3<=(RS3 NOR RT3); END CASE;
								WHEN OTHERS =>
							END CASE;
						END IF;
						
						CASE opcode3 IS
							WHEN "0000" => RS3 <= data3;
							WHEN "0001" => RS3 <= RT3;
							WHEN "0010" => RS3 <= (RS3+RT3);
							WHEN "0011" => RS3 <= (RS3 AND RT3);
							WHEN "0100" => IF(RS3<RT3)THEN RS3 <= "00000001"; ELSE RS3 <= "00000000"; END IF;
							WHEN "0101" => RS3 <= (RS3 - RT3);
							WHEN "0110" => RS3 <= (RS3 NOR RT3);
							WHEN OTHERS =>
						END CASE;
						
						LEDR <= RS3;
						
						IF(opcode3 = "1111")THEN
							Execution_led <= '0';
						ELSE
							Execution_led <= '1';
						END IF;
						register3<=WriteBack;
						
					WHEN WriteBack=>
						IF(opcode3 /= "1111")THEN
							CASE codeRS3 IS
								WHEN "00" => R0 <= RS3;
								WHEN "01" => R1 <= RS3;
								WHEN "10" => R2 <= RS3;
								WHEN "11" => R3 <= RS3;
							END CASE;
						END IF;
						
						IF(opcode3 = "1111")THEN
							WriteBack_led <= '0';
						ELSE
							WriteBack_led <= '1';
						END IF;
				END CASE;
				
				
				CASE register4 IS
					WHEN Fetch=>
						opcode4<=opcode;
						codeRS4<=codeRS;
						codeRT4<=codeRT;
						register4<=ID;
						register1<=Fetch;
						data4<=data;
						
						IF(opcode = "1111")THEN
							Fetch_led <= '0';
						ELSE
							Fetch_led <= '1';
						END IF;
					WHEN ID=>
						
						IF(opcode3 /= "1111"  AND opcode4 /= "1111" AND (codeRS4 = codeRS3 or codeRT4 = codeRS3))THEN
							Hazard <= '1';
							IF(codeRS4 = codeRS3 AND codeRT4 = codeRS3)THEN
								CASE opcode3 IS
									WHEN "0000" => RS4 <= data3; RT4 <= data3;
									WHEN "0001" => RS4 <= RT3; RT4 <= RT3;
									WHEN "0010" => RS4 <= (RS3+RT3); RT4 <= (RS3+RT3);
									WHEN "0011" => RS4 <= (RS3 AND RT3); RT4 <= (RS3 AND RT3);
									WHEN "0100" => IF(RS3<RT3)THEN RS4 <= "00000001"; RT4 <= "00000001"; ELSE RS4 <= "00000000"; RT4 <= "00000000"; END IF;
									WHEN "0101" => RS4 <= (RS3 - RT3); RT4 <= (RS3 - RT3);
									WHEN "0110" => RS4 <= (RS3 NOR RT3); RT4 <= (RS3 NOR RT3);
									WHEN OTHERS =>
								END CASE;
							
							ELSIF(codeRS4 = codeRS3)THEN
								
								CASE opcode3 IS
									WHEN "0000" => RS4 <= data3;
									WHEN "0001" => RS4 <= RT3;
									WHEN "0010" => RS4 <= (RS3+RT3);
									WHEN "0011" => RS4 <= (RS3 AND RT3);
									WHEN "0100" => IF(RS3<RT3)THEN RS4 <= "00000001"; ELSE RS4 <= "00000000"; END IF;
									WHEN "0101" => RS4 <= (RS3 - RT3);
									WHEN "0110" => RS4 <= (RS3 NOR RT3);
									WHEN OTHERS =>
								END CASE;
							
								CASE codeRT4 IS
									WHEN "00" => RT4 <= R0;
									WHEN "01" => RT4 <= R1;
									WHEN "10" => RT4 <= R2;
									WHEN "11" => RT4 <= R3;
								END CASE;
							
							ELSIF(codeRT4 = codeRS3)THEN
								
								CASE opcode3 IS
									WHEN "0000" => RT4 <= data3;
									WHEN "0001" => RT4 <= RT3;
									WHEN "0010" => RT4 <= (RS3+RT3);
									WHEN "0011" => RT4 <= (RS3 AND RT3);
									WHEN "0100" => IF(RS3<RT3)THEN RT4 <= "00000001"; ELSE RT4 <= "00000000"; END IF;
									WHEN "0101" => RT4 <= (RS3 - RT3);
									WHEN "0110" => RT4 <= (RS3 NOR RT3);
									WHEN OTHERS =>
								END CASE;
							
								CASE codeRS4 IS
									WHEN "00" => RS4 <= R0;
									WHEN "01" => RS4 <= R1;
									WHEN "10" => RS4 <= R2;
									WHEN "11" => RS4 <= R3;
								END CASE;
							
							END IF;
							
						ELSE
							Hazard <= '0';
							CASE codeRS4 IS
								WHEN "00" => RS4 <= R0;
								WHEN "01" => RS4 <= R1;
								WHEN "10" => RS4 <= R2;
								WHEN "11" => RS4 <= R3;
							END CASE;

							CASE codeRT4 IS
								WHEN "00" => RT4 <= R0;
								WHEN "01" => RT4 <= R1;
								WHEN "10" => RT4 <= R2;
								WHEN "11" => RT4 <= R3;
							END CASE;
						END IF;
						
						IF(opcode4 = "1111")THEN
							ID_led <= '0';
						ELSE
							ID_led <= '1';
						END IF;
						register4<=Execution;
					WHEN Execution=>
						
						IF(opcode /= "1111" AND opcode4 /= "1111" AND (codeRS = codeRS4 or codeRT = codeRS4))THEN
							CASE opcode4 IS
								WHEN "0000" => 
									CASE codeRS4 IS
										WHEN "00"=>R0<=data4; 
										WHEN "01"=>R1<=data4; 
										WHEN "10"=>R2<=data4; 
										WHEN "11"=>R3<=data4; 
									END CASE;
									WHEN "0001" => 
										CASE codeRS4 IS 
											WHEN "00"=>R0<=RT4; 
											WHEN "01"=>R1<=RT4; 
											WHEN "10"=>R2<=RT4; 
											WHEN "11"=>R3<=RT4; 
										END CASE;
									WHEN "0010" => 
										CASE codeRS4 IS 
											WHEN "00"=>R0<=(RS4+RT4); 
											WHEN "01"=>R1<=(RS4+RT4);
											WHEN "10"=>R2<=(RS4+RT4); 
											WHEN "11"=>R3<=(RS4+RT4); 
										END CASE;
									WHEN "0011" => 
										CASE codeRS4 IS 
											WHEN "00"=>R0<=(RS4 AND RT4);
											WHEN "01"=>R1<=(RS4 AND RT4); 
											WHEN "10"=>R2<=(RS4 AND RT4); 
											WHEN "11"=>R3<=(RS4 AND RT4); 
										END CASE;
									WHEN "0100" => 
										IF(RS4<RT4)THEN
											CASE codeRS4 IS 
												WHEN "00"=>R0<="00000001";
												WHEN "01"=>R1<="00000001";
												WHEN "10"=>R2<="00000001";
												WHEN "11"=>R3<="00000001";
											END CASE; 
										ELSE 
											CASE codeRS4 IS 
												WHEN "00"=>R0<="00000000";
												WHEN "01"=>R1<="00000000";
												WHEN "10"=>R2<="00000000";
												WHEN "11"=>R3<="00000000"; 
											END CASE; 
									END IF;
										WHEN "0101" => 
										CASE codeRS4 IS 
											WHEN "00"=>R0<=(RS4-RT4); 
											WHEN "01"=>R1<=(RS4-RT4);
											WHEN "10"=>R2<=(RS4-RT4); 
											WHEN "11"=>R3<=(RS4-RT4); 
										END CASE;
									WHEN "0110" => 
										CASE codeRS4 IS
											WHEN "00"=>R0<=(RS4 NOR RT4); 
											WHEN "01"=>R1<=(RS4 NOR RT4); 
											WHEN "10"=>R2<=(RS4 NOR RT4); 
											WHEN "11"=>R3<=(RS4 NOR RT4);
										END CASE;
									WHEN OTHERS =>
							END CASE;
						END IF;
						
						CASE opcode4 IS
							WHEN "0000" => RS4 <= data4;
							WHEN "0001" => RS4 <= RT4;
							WHEN "0010" => RS4 <= (RS4+RT4);
							WHEN "0011" => RS4 <= (RS4 AND RT4);
							WHEN "0100" => IF(RS4<RT4)THEN RS4 <= "00000001"; ELSE RS4 <= "00000000"; END IF;
							WHEN "0101" => RS4 <= (RS4 - RT4);
							WHEN "0110" => RS4 <= (RS4 NOR RT4);
							WHEN OTHERS =>
						END CASE;
						
						LEDR <= RS4;
						
						IF(opcode4 = "1111")THEN
							Execution_led <= '0';
						ELSE
							Execution_led <= '1';
						END IF;
						register4<=WriteBack;
					WHEN WriteBack=>
						IF(opcode4 /= "1111")THEN
							CASE codeRS4 IS
								WHEN "00" => R0 <= RS4;
								WHEN "01" => R1 <= RS4;
								WHEN "10" => R2 <= RS4;
								WHEN "11" => R3 <= RS4;
							END CASE;
						END IF;
						
						IF(opcode4 = "1111")THEN
							WriteBack_led <= '0';
						ELSE
							WriteBack_led <= '1';
						END IF;
				END CASE;
			END IF;
		END IF;
	END PROCESS;
	
	PROCESS(RS, RT)
	BEGIN
		CASE codeRS IS
			WHEN "00" =>
				RS <= R0;
			WHEN "01" =>
				RS <= R1;
			WHEN "10" =>
				RS <= R2;
			WHEN "11" =>
				RS <= R3;
		END CASE;

		CASE codeRT IS
			WHEN "00" =>
				RT <= R0;
			WHEN "01" =>
				RT <= R1;
			WHEN "10" =>
				RT <= R2;
			WHEN "11" =>
				RT <= R3;
		END CASE;
	END PROCESS;
	stage0: hex port map(data(3 downto 0),hex0);
	stage1: hex port map(data(7 downto 4),hex1);
	stage2: hex port map(RS(3 downto 0),hex2);
	stage3: hex port map(RS(7 downto 4),hex3);
	stage4: hex port map(RT(3 downto 0),hex4);
	stage5: hex port map(RT(7 downto 4),hex5);
END Behavior;
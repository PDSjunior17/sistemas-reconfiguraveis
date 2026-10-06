LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY Exercicio1 IS
PORT (
	a: IN STD_LOGIC_VECTOR(2 DOWNTO 0);-- seleção
	ne1, ne2, e3: IN STD_LOGIC; -- enable
	no: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE arch1 OF Exercicio1 IS
	SIGNAL aux : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
		
	WITH a SELECT
		aux <= "00000001" WHEN "000",
			   "00000010" WHEN "001",
			   "00000100" WHEN "010",
			   "00001000" WHEN "011",
			   "00010000" WHEN "100",
			   "00100000" WHEN "101",
			   "01000000" WHEN "110",
			   "10000000" WHEN "111",
			   "00000000" WHEN OTHERS;
			   
		no <= aux WHEN ne1 = '0' AND ne2 = '0' AND e3 = '1' ELSE
			"00000000";
		
END arch1;			 
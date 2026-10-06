LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY enc_4x2 IS
	PORT (
		i: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		ei: IN STD_LOGIC;
		gs: OUT STD_LOGIC;
		eo: OUT STD_LOGIC;
		a: OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END ENTITY;
ARCHITECTURE arch OF prio_enc IS
BEGIN 
	a <= "000" WHEN i(7) = '0' ELSE
		 "001" WHEN i(6) = '0' ELSE
		 "010" WHEN i(5) = '0' ELSE
		 "011" WHEN i(4) = '0' ELSE
		 "100" WHEN i(3) = '0' ELSE
		 "101" WHEN i(2) = '0' ELSE
		 "110" WHEN i(1) = '0' ELSE
		 "111";
	gs: <= '1' WHEN ei = '1' ELSE
		   '1' WHEN ei = '0' AND i = "11111111" ELSE
		   '0';
	eo: <= '1' WHEN ei = '1' ELSE
		   '0' WHEN ei = '0' AND i = "11111111" ELSE
		   '1';
END arch;
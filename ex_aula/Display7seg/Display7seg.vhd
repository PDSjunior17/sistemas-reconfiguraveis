LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Display7seg IS
	GENERIC (
		active_level : STRING := "low"
	);
	PORT (
		i: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		y: OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE Display7seg OF Display7seg IS
 SIGNAL aux: STD_LOGIC_VECTOR(6 DOWNTO 0);
BEGIN

WITH i SELECT
		-- gfedcba
	 aux <= "0111111" WHEN "0000",
		    "0000110" WHEN "0001",
		    "1011011" WHEN "0010",
		    "1001111" WHEN "0011",
		    "1100110" WHEN "0100",
		    "1101101" WHEN "0101",
		    "1111101" WHEN "0110",
		    "0000111" WHEN "0111",
		    "1111111" WHEN "1000",
		    "1101111" WHEN "1001",
		    "0111111" WHEN OTHERS;
		  

	ASSERT active_level = "low" OR active_level = "high"
	REPORT "OK"
	SEVERITY error;
	
	y <= aux WHEN active_level = "high" ELSE
		 NOT aux WHEN active_level = "low";
	
END Display7seg;
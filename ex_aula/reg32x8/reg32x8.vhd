LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;
-------------------------------------------------------
ENTITY reg32x8 IS
	PORT (
		nclr : IN STD_LOGIC;
		clk : IN STD_LOGIC;
		wr_en : IN STD_LOGIC;
		d : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		addr : IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		q : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END ENTITY;
-------------------------------------------------------
ARCHITECTURE arch1 OF reg32x8 IS
	TYPE mem_type IS ARRAY(0 TO 31) OF
	STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL mem_reg : mem_type;
	SIGNAL addr_int : INTEGER RANGE 0 TO 31;
BEGIN
	----------- Conversão:
	addr_int <= TO_INTEGER(UNSIGNED(addr));
	----------- Escrita:
	PROCESS(nclr, clk)
	BEGIN
		IF nclr = '0' THEN
			mem_reg <= (OTHERS => (OTHERS => '0'));
		ELSIF RISING_EDGE(clk) THEN
			IF wr_en = '1' THEN
				mem_reg(addr_int) <= d;
			END IF;
		END IF;
	END PROCESS;
	----------- Leitura:
	q <= mem_reg(addr_int);
END arch1;
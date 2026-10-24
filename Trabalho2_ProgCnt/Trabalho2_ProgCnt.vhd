LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Trabalho2_ProgCnt IS
	PORT(
		nrst        : IN STD_LOGIC; -- Entrada de reset assíncrono
		clk_in      : IN STD_LOGIC; -- Entrada de clock para incremento ou carga do contador
		pc_ctrl     : IN STD_LOGIC_VECTOR(1 DOWNTO 0) := "00"; -- Controle: 00 mantém, 01 carrega from_stack, 10 carrega new_pc_in, 11 incrementa
		new_pc_in   : IN STD_LOGIC_VECTOR(10 DOWNTO 0) := (OTHERS => '0'); -- Entrada para carga no contador quando pc_ctrl = "10"
		from_stack  : IN STD_LOGIC_VECTOR(10 DOWNTO 0) := (OTHERS => '0'); -- Entrada para carga no contador quando pc_ctrl = "01"
		next_pc_out : OUT STD_LOGIC_VECTOR(10 DOWNTO 0); -- Saída do próximo valor do contador (combinacional)
		pc_out      : OUT STD_LOGIC_VECTOR(10 DOWNTO 0) -- Saída do contador
	);
END ENTITY Trabalho2_ProgCnt;

ARCHITECTURE Prog_Cnt OF Trabalho2_ProgCnt IS

	SIGNAL pc      : STD_LOGIC_VECTOR(10 DOWNTO 0); -- Saída dos flip-flops do contador
	SIGNAL next_pc : STD_LOGIC_VECTOR(10 DOWNTO 0); -- Entrada dos flip-flops do contador

BEGIN

	-- Parte combinacional: calcula o valor a ser carregado na próxima borda de subida do clock
	-- como o vetor tem 11 bits, o incremento de 2047 volta naturalmente para 0 (módulo 2048)
	Combinacional : PROCESS(pc_ctrl, pc, new_pc_in, from_stack)
	BEGIN
		CASE pc_ctrl IS
			WHEN "01"   => next_pc <= from_stack;
			WHEN "10"   => next_pc <= new_pc_in;
			WHEN "11"   => next_pc <= STD_LOGIC_VECTOR(UNSIGNED(pc) + 1);
			WHEN OTHERS => next_pc <= pc;
		END CASE;
	END PROCESS Combinacional;

	-- Parte sequencial: registra o próximo valor na borda de subida do clock
	Sequencial : PROCESS(nrst, clk_in)
	BEGIN
		IF nrst = '0' THEN
			pc <= (OTHERS => '0');
		ELSIF RISING_EDGE(clk_in) THEN
			pc <= next_pc;
		END IF;
	END PROCESS Sequencial;

	next_pc_out <= next_pc;
	pc_out <= pc;

END ARCHITECTURE Prog_Cnt;

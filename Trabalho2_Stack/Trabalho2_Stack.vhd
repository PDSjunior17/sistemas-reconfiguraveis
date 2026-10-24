LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY Trabalho2_Stack IS
	PORT(
		nrst       : IN STD_LOGIC; -- Entrada de reset assincrono
		clk_in     : IN STD_LOGIC; -- Entrada de clock para escrita nos registradores
		stack_in   : IN STD_LOGIC_VECTOR(10 DOWNTO 0) := (OTHERS => '0'); -- Entrada para a pilha
		stack_push : IN STD_LOGIC := '0'; -- Entrada de habilitação para colocar valores na pilha (tem preferência sobre o pop)
		stack_pop  : IN STD_LOGIC := '0'; -- Entrada de habilitação para retirar valores da pilha
		stack_out  : OUT STD_LOGIC_VECTOR(10 DOWNTO 0) -- Saída correspondente à primeira posição (topo) da pilha
	);
END ENTITY Trabalho2_Stack;

ARCHITECTURE Stack OF Trabalho2_Stack IS

	-- Tipo que representa os 8 registradores de 11 bits da pilha, pilha(0) é o topo
	TYPE tipo_pilha IS ARRAY (0 TO 7) OF STD_LOGIC_VECTOR(10 DOWNTO 0);
	SIGNAL pilha : tipo_pilha;

BEGIN

	Stack : PROCESS(nrst, clk_in)
	BEGIN
		IF nrst = '0' THEN
			pilha <= (OTHERS => (OTHERS => '0'));
		ELSIF RISING_EDGE(clk_in) THEN
			IF stack_push = '1' THEN
				-- push: o valor de entrada vai para o topo e cada registrador recebe o conteudo do anterior
				-- o conteudo do oitavo registrador e perdido (stack overflow)
				pilha(0) <= stack_in;
				FOR i IN 1 TO 7 LOOP
					pilha(i) <= pilha(i-1);
				END LOOP;
			ELSIF stack_pop = '1' THEN
				-- pop: cada registrador recebe o conteudo do seguinte e o oitavo recebe zero
				FOR i IN 0 TO 6 LOOP
					pilha(i) <= pilha(i+1);
				END LOOP;
				pilha(7) <= (OTHERS => '0');
			END IF;
		END IF;
	END PROCESS Stack;

	stack_out <= pilha(0);

END ARCHITECTURE Stack;
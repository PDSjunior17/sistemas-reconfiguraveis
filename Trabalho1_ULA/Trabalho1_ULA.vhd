LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

ENTITY Trabalho1_ULA IS
	PORT(
		entrada1, entrada2: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		carry: IN STD_LOGIC;                                  
		operacao: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		saida: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		flags: OUT STD_LOGIC_VECTOR(4 DOWNTO 0)
	);
END ENTITY;

ARCHITECTURE ula OF Trabalho1_ULA IS
	SIGNAL resultado: STD_LOGIC_VECTOR(7 downto 0);
	SIGNAL pass_b: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL op_or: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL op_xor: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL op_and: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL op_addc: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL op_add: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL op_subc: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL op_sub: STD_LOGIC_VECTOR(7 DOWNTO 0);
	--sinais das operacoes logicas, de deslocamento e de rotacao
	SIGNAL op_not: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL op_sra: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL op_srl: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL op_sll: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL op_rrc: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL op_rlc: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL op_rr: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL op_rl: STD_LOGIC_VECTOR(7 DOWNTO 0);
	--carry das operacoes de deslocamento e rotacao
	SIGNAL carry_flag_sra, carry_flag_srl, carry_flag_sll: STD_LOGIC;
	SIGNAL carry_flag_rrc, carry_flag_rlc, carry_flag_rr, carry_flag_rl: STD_LOGIC;
	--flags
	SIGNAL carry_flag, halfcarry_flag, overflow_flag: STD_LOGIC;
	--auxiliares para a operacao de soma com carry
	SIGNAL aux_somac_1: STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL aux_somac_2: STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL aux_carry_1: STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL aux_carry_2: STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL carry_flag_addc, halfcarry_flag_addc, overflow_flag_addc: STD_LOGIC;
	--auxiliares para a operacao de soma sem carry
	SIGNAL aux_soma_1: STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL aux_soma_2: STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL carry_flag_add, halfcarry_flag_add, overflow_flag_add: STD_LOGIC;
	--auxiliares para a operacao de subtracao com carry
	SIGNAL aux_subc_1: STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL aux_subc_2: STD_LOGIC_VECTOR(4 DOWNTO 0);
	--como a operacao de add com carry ja tem auxiliares para o carry, podemos reaproveitar
	SIGNAL carry_flag_subc, halfcarry_flag_subc, overflow_flag_subc: STD_LOGIC;
	--auxiliares para a operacao de subtracao sem carry
	SIGNAL aux_sub_1: STD_LOGIC_VECTOR(8 DOWNTO 0);
	SIGNAL aux_sub_2: STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL carry_flag_sub, halfcarry_flag_sub, overflow_flag_sub: STD_LOGIC;

BEGIN

	--primeira operacao 0000 entrada de B vai para a saida
	pass_b <= entrada2;
	
	--segunda operacao 0001 a saida e A or B
	op_or <= entrada1 OR entrada2;
	
	--terceira operacao 0010 a saida e A xor B
	op_xor <= entrada1 XOR entrada2;
	
	--quarta operacao 0011 a saida e A and B
	op_and <= entrada1 AND entrada2;
	
	--quinta operacao 0100 a saida e A+B+carry 
	--primeiramente precisamos estender o tamanho do sinal de carry para podermos somar
	aux_carry_1 <= "00000000" & carry;
	aux_carry_2 <= "0000" & carry;
	-- operandos estendidos com '0' & para o carry nao se perder
	aux_somac_1 <= STD_LOGIC_VECTOR(UNSIGNED('0' & entrada1)+UNSIGNED('0' & entrada2)+UNSIGNED(aux_carry_1));
	aux_somac_2 <= STD_LOGIC_VECTOR(UNSIGNED('0' & entrada1(3 DOWNTO 0))+UNSIGNED('0' & entrada2(3 DOWNTO 0))+UNSIGNED(aux_carry_2));
	op_addc <= aux_somac_1(7 DOWNTO 0);
	carry_flag_addc <= aux_somac_1(8);
	halfcarry_flag_addc <= aux_somac_2(4);
	overflow_flag_addc <= (entrada1(7) and entrada2(7) and not op_addc(7)) or (not entrada1(7) and not entrada2(7) and op_addc(7));
	--fim soma com carry

	--soma sem carry
	aux_soma_1 <= STD_LOGIC_VECTOR(UNSIGNED('0' & entrada1)+UNSIGNED('0' & entrada2));
	aux_soma_2 <= STD_LOGIC_VECTOR(UNSIGNED('0' & entrada1(3 DOWNTO 0))+UNSIGNED('0' & entrada2(3 DOWNTO 0)));
	op_add <= aux_soma_1(7 DOWNTO 0);
	carry_flag_add <= aux_soma_1(8);
	halfcarry_flag_add <= aux_soma_2(4);
	overflow_flag_add <= (entrada1(7) and entrada2(7) and not op_add(7)) or (not entrada1(7) and not entrada2(7) and op_add(7));
	--fim soma sem carry
	
	--subtracao com carry
	aux_subc_1 <= STD_LOGIC_VECTOR(UNSIGNED('0' & entrada1)-UNSIGNED('0' & entrada2)-UNSIGNED(aux_carry_1));
	aux_subc_2 <= STD_LOGIC_VECTOR(UNSIGNED('0' & entrada1(3 DOWNTO 0))-UNSIGNED('0' & entrada2(3 DOWNTO 0))-UNSIGNED(aux_carry_2));
	op_subc <= aux_subc_1(7 DOWNTO 0);
	carry_flag_subc <= aux_subc_1(8);
	halfcarry_flag_subc <= aux_subc_2(4);
	overflow_flag_subc <= (entrada1(7) and not entrada2(7) and not op_subc(7)) or (not entrada1(7) and entrada2(7) and op_subc(7));
	--fim subtracao com carry
	
	--subtracao sem carry
	aux_sub_1 <= STD_LOGIC_VECTOR(UNSIGNED('0' & entrada1)-UNSIGNED('0' & entrada2));
	aux_sub_2 <= STD_LOGIC_VECTOR(UNSIGNED('0' & entrada1(3 DOWNTO 0))-UNSIGNED('0' & entrada2(3 DOWNTO 0)));
	op_sub <= aux_sub_1(7 DOWNTO 0);
	carry_flag_sub <= aux_sub_1(8);
	halfcarry_flag_sub <= aux_sub_2(4);
	overflow_flag_sub <= (entrada1(7) and not entrada2(7) and not op_sub(7)) or (not entrada1(7) and entrada2(7) and op_sub(7));
	--fim subtracao sem carry
	
	--nona operacao 1000 a saida e NOT A (carry = '0')
	op_not <= NOT entrada1;
	
	--decima operacao 1001 SRA: deslocamento aritmetico para a direita
	--o bit 7 e repetido e o bit 0 vai para o carry
	op_sra <= entrada1(7) & entrada1(7 DOWNTO 1);
	carry_flag_sra <= entrada1(0);
	
	--decima primeira operacao 1010 SRL: deslocamento logico para a direita
	--entra '0' no bit 7 e o bit 0 vai para o carry
	op_srl <= '0' & entrada1(7 DOWNTO 1);
	carry_flag_srl <= entrada1(0);
	
	--decima segunda operacao 1011 SLL: deslocamento logico para a esquerda
	--entra '0' no bit 0 e o bit 7 vai para o carry
	op_sll <= entrada1(6 DOWNTO 0) & '0';
	carry_flag_sll <= entrada1(7);
	
	--decima terceira operacao 1100 RRC: rotacao para a direita atraves do carry
	--o carry de entrada vai para o bit 7 e o bit 0 vai para o carry de saida
	op_rrc <= carry & entrada1(7 DOWNTO 1);
	carry_flag_rrc <= entrada1(0);
	
	--decima quarta operacao 1101 RLC: rotacao para a esquerda atraves do carry
	--o carry de entrada vai para o bit 0 e o bit 7 vai para o carry de saida
	op_rlc <= entrada1(6 DOWNTO 0) & carry;
	carry_flag_rlc <= entrada1(7);
	
	--decima quinta operacao 1110 RR: rotacao para a direita
	--o bit 0 vai para o bit 7 e tambem para o carry
	op_rr <= entrada1(0) & entrada1(7 DOWNTO 1);
	carry_flag_rr <= entrada1(0);
	
	--decima sexta operacao 1111 RL: rotacao para a esquerda
	--o bit 7 vai para o bit 0 e tambem para o carry
	op_rl <= entrada1(6 DOWNTO 0) & entrada1(7);
	carry_flag_rl <= entrada1(7);
	
	WITH operacao SELECT
		resultado <= pass_b WHEN "0000",
					 op_or WHEN "0001",
					 op_xor WHEN "0010",
					 op_and WHEN "0011",
					 op_addc WHEN "0100",
					 op_add WHEN "0101",
					 op_subc WHEN "0110",
					 op_sub WHEN "0111", 
					 op_not WHEN "1000",
					 op_sra WHEN "1001",
					 op_srl WHEN "1010",
					 op_sll WHEN "1011",
					 op_rrc WHEN "1100",
					 op_rlc WHEN "1101",
					 op_rr WHEN "1110",
					 op_rl WHEN "1111",
					 "00000000" WHEN OTHERS;
	
	--nas operacoes logicas (0000 a 0011 e 1000) o carry e '0'
	WITH operacao SELECT
		carry_flag <= carry_flag_addc WHEN "0100",
					  carry_flag_add WHEN "0101",
					  carry_flag_subc WHEN "0110",
					  carry_flag_sub WHEN "0111",
					  carry_flag_sra WHEN "1001",
					  carry_flag_srl WHEN "1010",
					  carry_flag_sll WHEN "1011",
					  carry_flag_rrc WHEN "1100",
					  carry_flag_rlc WHEN "1101",
					  carry_flag_rr WHEN "1110",
					  carry_flag_rl WHEN "1111",
					  '0' WHEN OTHERS;
		
	--halfcarry: so tem significado nas operacoes aritmeticas (nas demais e don't care, usamos '0')
	WITH operacao SELECT
		halfcarry_flag <= halfcarry_flag_addc WHEN "0100",
						  halfcarry_flag_add WHEN "0101",
						  halfcarry_flag_subc WHEN "0110",
						  halfcarry_flag_sub WHEN "0111",
						  '0' WHEN OTHERS;
		
	--overflow: so tem significado nas operacoes aritmeticas (nas demais e don't care, usamos '0')
	WITH operacao SELECT
		overflow_flag <= overflow_flag_addc WHEN "0100",
						 overflow_flag_add WHEN "0101",
						 overflow_flag_subc WHEN "0110",
						 overflow_flag_sub WHEN "0111",
						 '0' WHEN OTHERS;
						 
	saida <= resultado;
	
	flags(0) <= resultado(7);                             -- negative
	flags(1) <= overflow_flag;                            -- overflow
	flags(2) <= '1' WHEN resultado = "00000000" ELSE '0'; -- zero
	flags(3) <= halfcarry_flag;                           -- half carry / borrow
	flags(4) <= carry_flag;                               -- carry / borrow

END ula;

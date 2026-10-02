# Exemplos de Lógica Combinacional

A lógica combinacional tem saídas que dependem apenas das entradas atuais, sem memória ou feedback.

## Portas Lógicas Básicas

### Porta AND
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity and_gate is
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           Y : out STD_LOGIC );
end and_gate;

architecture Behavioral of and_gate is
begin
    Y <= A and B;
end Behavioral;
```

### Porta OR
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity or_gate is
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           Y : out STD_LOGIC );
end or_gate;

architecture Behavioral of or_gate is
begin
    Y <= A or B;
end Behavioral;
```

### Porta NOT (Inversor)
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity not_gate is
    Port ( A : in  STD_LOGIC;
           Y : out STD_LOGIC );
end not_gate;

architecture Behavioral of not_gate is
begin
    Y <= not A;
end Behavioral;
```

### Porta NAND
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nand_gate is
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           Y : out STD_LOGIC );
end nand_gate;

architecture Behavioral of nand_gate is
begin
    Y <= not (A and B);
end Behavioral;
```

### Porta NOR
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity nor_gate is
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           Y : out STD_LOGIC );
end nor_gate;

architecture Behavioral of nor_gate is
begin
    Y <= not (A or B);
end Behavioral;
```

### Porta XOR
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity xor_gate is
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           Y : out STD_LOGIC );
end xor_gate;

architecture Behavioral of xor_gate is
begin
    Y <= A xor B;
end Behavioral;
```

## Multiplexadores (MUX)

### MUX 2-para-1
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux2to1 is
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           S : in  STD_LOGIC;  -- Linha de seleção
           Y : out STD_LOGIC );
end mux2to1;

architecture Behavioral of mux2to1 is
begin
    Y <= A when S = '0' else B;
end Behavioral;
```

### MUX 4-para-1 usando Quando/Senão
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux4to1 is
    Port ( A0, A1, A2, A3 : in  STD_LOGIC;
           S : in  STD_LOGIC_VECTOR(1 downto 0);  -- Seleção de 2 bits
           Y : out STD_LOGIC );
end mux4to1;

architecture Behavioral of mux4to1 is
begin
    Y <= A0 when S = "00" else
         A1 when S = "01" else
         A2 when S = "10" else
         A3;
end Behavioral;
```

### MUX 4-para-1 com Processo
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux4to1_proc is
    Port ( A0, A1, A2, A3 : in  STD_LOGIC;
           S : in  STD_LOGIC_VECTOR(1 downto 0);
           Y : out STD_LOGIC );
end mux4to1_proc;

architecture Behavioral of mux4to1_proc is
begin
    process (A0, A1, A2, A3, S)
    begin
        case S is
            when "00" => Y <= A0;
            when "01" => Y <= A1;
            when "10" => Y <= A2;
            when "11" => Y <= A3;
            when others => Y <= '0';  -- Caso padrão
        end case;
    end process;
end Behavioral;
```

## Decodificadores

### Decodificador 2-para-4
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder2to4 is
    Port ( A : in  STD_LOGIC_VECTOR(1 downto 0);
           Y : out STD_LOGIC_VECTOR(3 downto 0) );
end decoder2to4;

architecture Behavioral of decoder2to4 is
begin
    with A select
        Y <= "0001" when "00",
             "0010" when "01",
             "0100" when "10",
             "1000" when "11",
             "0000" when others;
end Behavioral;
```

## Codificadores

### Codificador de Prioridade (4-para-2)
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity priority_encoder4to2 is
    Port ( A : in  STD_LOGIC_VECTOR(3 downto 0);
           Y : out STD_LOGIC_VECTOR(1 downto 0);
           V : out STD_LOGIC );  -- Indicador de validade
end priority_encoder4to2;

architecture Behavioral of priority_encoder4to2 is
begin
    process (A)
    begin
        if A(3) = '1' then
            Y <= "11";
            V <= '1';
        elsif A(2) = '1' then
            Y <= "10";
            V <= '1';
        elsif A(1) = '1' then
            Y <= "01";
            V <= '1';
        elsif A(0) = '1' then
            Y <= "00";
            V <= '1';
        else
            Y <= "00";
            V <= '0';
        end if;
    end process;
end Behavioral;
```

## Somadores

### Meio Somador
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity half_adder is
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           S : out STD_LOGIC;      -- Soma
           C : out STD_LOGIC );    -- Transporte
end half_adder;

architecture Behavioral of half_adder is
begin
    S <= A xor B;
    C <= A and B;
end Behavioral;
```

### Somador Completo
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity full_adder is
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           Cin : in  STD_LOGIC;
           S : out STD_LOGIC;      -- Soma
           Cout : out STD_LOGIC ); -- Transporte de saída
end full_adder;

architecture Behavioral of full_adder is
begin
    S <= A xor B xor Cin;
    Cout <= (A and B) or (B and Cin) or (A and Cin);
end Behavioral;
```

### Somador de Transporte em Série (4 bits)
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ripple_carry_adder4 is
    Port ( A : in  STD_LOGIC_VECTOR(3 downto 0);
           B : in  STD_LOGIC_VECTOR(3 downto 0);
           Cin : in  STD_LOGIC;
           S : out STD_LOGIC_VECTOR(3 downto 0);
           Cout : out STD_LOGIC );
end ripple_carry_adder4;

architecture Behavioral of ripple_carry_adder4 is
    signal C : STD_LOGIC_VECTOR(4 downto 0);  -- Cadeia interna de transporte
begin
    C(0) <= Cin;
    S <= A xor B xor C(3 downto 0);  -- Simplificado - implementação real precisa por bit
    
    -- Implementação correta de transporte em série:
    gen: for i in 0 to 3 generate
        full_adder_i: entity work.full_adder
            port map (
                A => A(i),
                B => B(i),
                Cin => C(i),
                S => S(i),
                Cout => C(i+1)
            );
    end generate;
    
    Cout <= C(4);
end Behavioral;
```

## Comparadores

### Comparador de Igualdade
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity equality_comparator is
    Port ( A : in  STD_LOGIC_VECTOR(3 downto 0);
           B : in  STD_LOGIC_VECTOR(3 downto 0);
           A_eq_B : out STD_LOGIC );
end equality_comparator;

architecture Behavioral of equality_comparator is
begin
    A_eq_B <= '1' when A = B else '0';
end Behavioral;
```

### Comparador de Magnitude (A > B)
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity magnitude_comparator is
    Port ( A : in  STD_LOGIC_VECTOR(3 downto 0);
           B : in  STD_LOGIC_VECTOR(3 downto 0);
           A_gt_B : out STD_LOGIC );
end magnitude_comparator;

architecture Behavioral of magnitude_comparator is
begin
    process (A, B)
    begin
        if A > B then
            A_gt_B <= '1';
        else
            A_gt_B <= '0';
        end if;
    end process;
end Behavioral;
```

## Considerações Importantes para Lógica Combinacional

### Listas de Sensibilidade Completas
Todos os sinais lidos em um processo combinacional devem estar na lista de sensibilidade para evitar latches.

### Evitando Latches
Garanta que cada caminho através de um processo atribua um valor a todos os sinais de saída para evitar latches não intencionais.

### Usando Quando/Senão e Select
Essas declarações concorrentes são frequentemente mais claras para lógica combinacional simples do que processos.

No próximo arquivo, exploraremos lógica sequencial com flip-flops e registros.
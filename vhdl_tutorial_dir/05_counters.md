# Projetos de Contadores

Contadores são circuitos sequenciais fundamentais que ciclam através de uma sequência de estados.

## Contadores Binários

### Contador Binário Síncrono com Carregamento
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity binary_counter_load is
    Generic ( WIDTH : integer := 8 );
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;  -- Reset síncrono
           LOAD : in  STD_LOGIC;   -- Carregamento síncrono
           ENABLE : in  STD_LOGIC;
           D : in  STD_LOGIC_VECTOR(WIDTH-1 downto 0);  -- Valor de carregamento
           Q : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
           TC : out STD_LOGIC );   -- Contagem terminal (todos uns)
end binary_counter_load;

architecture Behavioral of binary_counter_load is
    signal count : UNSIGNED(WIDTH-1 downto 0) := (others => '0');
begin
    process (CLK)
    begin
        if rising_edge(CLK) then
            if RESET = '1' then
                count <= (others => '0');
            elsif LOAD = '1' then
                count <= UNSIGNED(D);
            elsif ENABLE = '1' then
                if count = TO_UNSIGNED(2**WIDTH-1, WIDTH) then
                    count <= (others => '0');
                else
                    count <= count + 1;
                end if;
            end if;
        end if;
    end process;
    
    Q <= STD_LOGIC_VECTOR(count);
    TC <= '1' when count = TO_UNSIGNED(2**WIDTH-1, WIDTH) else '0';
end Behavioral;
```

### Contador Binário com Habilitação e Direção
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bidirectional_binary_counter is
    Generic ( WIDTH : integer := 8 );
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           ENABLE : in  STD_LOGIC;
           UP : in  STD_LOGIC;     -- '1' = contar para cima, '0' = contar para baixo
           LOAD : in  STD_LOGIC;
           D : in  STD_LOGIC_VECTOR(WIDTH-1 downto 0);
           Q : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
           TC : out STD_LOGIC );   -- Contagem terminal
end bidirectional_binary_counter;

architecture Behavioral of bidirectional_binary_counter is
    signal count : UNSIGNED(WIDTH-1 downto 0) := (others => '0');
begin
    process (CLK)
    begin
        if rising_edge(CLK) then
            if RESET = '1' then
                count <= (others => '0');
            elsif LOAD = '1' then
                count <= UNSIGNED(D);
            elsif ENABLE = '1' then
                if UP = '1' then  -- Contar para cima
                    if count = TO_UNSIGNED(2**WIDTH-1, WIDTH) then
                        count <= (others => '0');
                    else
                        count <= count + 1;
                    end if;
                else  -- Contar para baixo
                    if count = 0 then
                        count <= TO_UNSIGNED(2**WIDTH-1, WIDTH);
                    else
                        count <= count - 1;
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    Q <= STD_LOGIC_VECTOR(count);
    -- TC é alto quando na contagem terminal em qualquer direção
    TC <= '1' when ((UP = '1' and count = TO_UNSIGNED(2**WIDTH-1, WIDTH)) or
                   (UP = '0' and count = 0)) else '0';
end Behavioral;
```

## Contadores de Anel

### Contador de Anel Padrão (Registrador de Deslocamento com Feedback)
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ring_counter is
    Generic ( WIDTH : integer := 4 );
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           ENABLE : in  STD_LOGIC;
           Q : out STD_LOGIC_VECTOR(WIDTH-1 downto 0) );
end ring_counter;

architecture Behavioral of ring_counter is
    signal Q_int : STD_LOGIC_VECTOR(WIDTH-1 downto 0) := (others => '0');
begin
    process (CLK, RESET)
    begin
        if RESET = '1' then
            Q_int <= "0001";  -- Inicializar com único '1' no LSB
        elsif rising_edge(CLK) then
            if ENABLE = '1' then
                -- Rotacionar para a direita: MSB <- LSB, outros deslocam para a direita
                Q_int(WIDTH-1 downto 1) <= Q_int(WIDTH-2 downto 0);
                Q_int(0) <= Q_int(WIDTH-1);
            end if;
        end if;
    end process;
    
    Q <= Q_int;
end Behavioral;
```

### Contador de Anel Torto (Contador Johnson)
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity johnson_counter is
    Generic ( WIDTH : integer := 4 );
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           ENABLE : in  STD_LOGIC;
           Q : out STD_LOGIC_VECTOR(WIDTH-1 downto 0) );
end johnson_counter;

architecture Behavioral of johnson_counter is
    signal Q_int : STD_LOGIC_VECTOR(WIDTH-1 downto 0) := (others => '0');
begin
    process (CLK, RESET)
    begin
        if RESET = '1' then
            Q_int <= (others => '0');
        elsif rising_edge(CLK) then
            if ENABLE = '1' then
                -- Anel torto: inverter MSB e deslocar para a direita
                Q_int(WIDTH-1 downto 1) <= Q_int(WIDTH-2 downto 0);
                Q_int(0) <= not Q_int(WIDTH-1);
            end if;
        end if;
    end process;
    
    Q <= Q_int;
end Behavioral;
```

## LFSR (Registrador de Deslocamento com Realimentação Linear)

### LFSR de Fibonacci
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lfsr_fibonacci is
    Generic ( WIDTH : integer := 8 );
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           ENABLE : in  STD_LOGIC;
           Q : out STD_LOGIC_VECTOR(WIDTH-1 downto 0) );
end lfsr_fibonacci;

architecture Behavioral of lfsr_fibonacci is
    signal Q_int : STD_LOGIC_VECTOR(WIDTH-1 downto 0) := (others => '0');
begin
    process (CLK, RESET)
    begin
        if RESET = '1' then
            Q_int <= (others => '0');
        elsif rising_edge(CLK) then
            if ENABLE = '1' then
                -- Feedback usando XOR de taps específicos (para WIDTH=8: taps [7,5,4,3])
                Q_int(WIDTH-1 downto 1) <= Q_int(WIDTH-2 downto 0);
                Q_int(0) <= Q_int(WIDTH-1) xor Q_int(WIDTH-3) xor Q_int(WIDTH-4) xor Q_int(WIDTH-5);
            end if;
        end if;
    end process;
    
    Q <= Q_int;
end Behavioral;
```

### LFSR de Galois
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity lfsr_galois is
    Generic ( WIDTH : integer := 8 );
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           ENABLE : in  STD_LOGIC;
           Q : out STD_LOGIC_VECTOR(WIDTH-1 downto 0) );
end lfsr_galois;

architecture Behavioral of lfsr_galois is
    signal Q_int : STD_LOGIC_VECTOR(WIDTH-1 downto 0) := (others => '0');
begin
    process (CLK, RESET)
    begin
        if RESET = '1' then
            Q_int <= (others => '0');
        elsif rising_edge(CLK) then
            if ENABLE = '1' then
                -- Estrutura de Galois: aplicar XOR em estágios onde os taps são 1
                -- Para WIDTH=8 com polinômio x^8 + x^6 + x^5 + x^4 + 1 (taps em 6,5,4)
                Q_int(0) <= Q_int(WIDTH-1);
                Q_int(1) <= Q_int(0) xor Q_int(WIDTH-1);
                Q_int(2) <= Q_int(1);
                Q_int(3) <= Q_int(2) xor Q_int(WIDTH-1);
                Q_int(4) <= Q_int(3) xor Q_int(WIDTH-1);
                Q_int(5 downto 4) <= Q_int(4 downto 3);
                Q_int(6) <= Q_int(5) xor Q_int(WIDTH-1);
                Q_int(WIDTH-1) <= Q_int(6);
            end if;
        end if;
    end process;
    
    Q <= Q_int;
end Behavioral;
```

## Contadores Decimais (BCD)

### Contador BCD (0-9)
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bcd_counter is
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           ENABLE : in  STD_LOGIC;
           Q : out STD_LOGIC_VECTOR(3 downto 0);
           TC : out STD_LOGIC );  -- Contagem terminal (alcançou 9)
end bcd_counter;

architecture Behavioral of bcd_counter is
    signal count : UNSIGNED(3 downto 0) := (others => '0');
begin
    process (CLK, RESET)
    begin
        if RESET = '1' then
            count <= (others => '0');
        elsif rising_edge(CLK) then
            if ENABLE = '1' then
                if count = 9 then
                    count <= 0;
                else
                    count = count + 1;
                end if;
            end if;
        end if;
    end process;
    
    Q <= STD_LOGIC_VECTOR(count);
    TC <= '1' when count = 9 else '0';
end Behavioral;
```

### Contador BCD de 2 Dígitos (00-99)
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bcd_counter_2digit is
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           ENABLE : in  STD_LOGIC;
           Q : out STD_LOGIC_VECTOR(7 downto 0);  -- [7:4] = dezenas, [3:0] = unidades
           TC : out STD_LOGIC );  -- Contagem terminal (alcançou 99)
end bcd_counter_2digit;

architecture Behavioral of bcd_counter_2digit is
    signal units : UNSIGNED(3 downto 0) := (others => '0');
    signal tens : UNSIGNED(3 downto 0) := (others => '0');
    signal units_tc : STD_LOGIC;
begin
    -- Contador de unidades (0-9)
    process (CLK, RESET)
    begin
        if RESET = '1' then
            units <= (others => '0');
        elsif rising_edge(CLK) then
            if ENABLE = '1' then
                if units = 9 then
                    units <= 0;
                else
                    units <= units + 1;
                end if;
            end if;
        end if;
    end process;
    
    units_tc <= '1' when units = 9 else '0';
    
    -- Contador de dezenas (incrementa quando as unidades fazem overflow)
    process (CLK, RESET)
    begin
        if RESET = '1' then
            tens <= (others => '0');
        elsif rising_edge(CLK) then
            if ENABLE = '1' and units_tc = '1' then
                if tens = 9 then
                    tens <= 0;
                else
                    tens <= tens + 1;
                end if;
            end if;
        end if;
    end process;
    
    Q <= STD_LOGIC_VECTOR(tens & units);
    TC <= '1' when (tens = 9 and units = 9) else '0';
end Behavioral;
```

## Divisores de Relógio (Baseados em Contadores)

### Divisor de Relógio Programmável
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity programmable_clock_divider is
    Generic ( WIDTH : integer := 8 );  -- Largura do contador
    Port ( CLK_IN : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           ENABLE : in  STD_LOGIC;
           DIVISOR : in  STD_LOGIC_VECTOR(WIDTH-1 downto 0);  -- Fator de divisão
           CLK_OUT : out STD_LOGIC );
end programmable_clock_divider;

architecture Behavioral of programmable_clock_divider is
    signal count : UNSIGNED(WIDTH-1 downto 0) := (others => '0');
    signal clk_int : STD_LOGIC := '0';
begin
    process (CLK_IN, RESET)
    begin
        if RESET = '1' then
            count <= (others => '0');
            clk_int <= '0';
        elsif rising_edge(CLK_IN) then
            if ENABLE = '1' then
                if count = UNSIGNED(DIVISOR) - 1 then
                    count <= (others => '0');
                    clk_int <= not clk_int;
                else
                    count += count + 1;
                end if;
            end if;
        end if;
    end process;
    
    CLK_OUT <= clk_int;
end Behavioral;
```

## Aplicações de Contadores

### Divisor de Frequência
Use contadores para derivar relógios de frequência menor a partir de um relógio de referência.

### Contadores de Eventos
Conte ocorrências de eventos (por exemplo, pulsos em um sinal de entrada).

### Temporizadores
Conte ciclos de relógio para medir intervalos de tempo.

### Geradores de Endereço
Gere endereços sequenciais para acesso à memória.

### Sequenciadores de Controle
Gere sequências de sinais de controle para máquinas de estado.

## Considerações Importantes para Projeto de Contadores

### Reset Síncrono vs Assíncrono
- Reset síncrono é preferido para contadores para evitar metastabilidade
- Reset assíncrono pode causar erros de contagem se liberado perto da borda do relógio

### Sinal de Habilitação
Use habilitações de relógio em vez de portas de relógio para melhores características de timing.

### Detecção de Contagem Terminal
Decodifique a contagem terminal usando comparação de igualdade em vez de depender do transporte para melhor clareza e para evitar problemas de timing.

### Parâmetros de Largura
Torne a largura do contador genérica para permitir reutilização para diferentes tamanhos.

### Inicialização
Garanta que os contadores inicializem em um estado conhecido (especialmente importante para contadores de anel e LFSRs).

No próximo arquivo, exploraremos projetos de Máquina de Estado Finitas (FSM).
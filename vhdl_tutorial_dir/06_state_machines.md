# Exemplos de Máquina de Estado Finitas (FSM)

Máquinas de Estado Finitas são circuitos sequenciais que transicionam entre um número finito de estados com base nas entradas.

## Estilos de Projeto de FSM

### Máquina de Moore
Saídas dependem apenas do estado atual.

### Máquina de Mealy
Saídas dependem tanto do estado atual quanto das entradas.

## Controlador de Semáforo (Máquina de Moore)

### Diagrama de Estado
```
Vermelho -> VermelhoAmarelo -> Verde -> Amarelo -> Vermelho
```

### Implementação em VHDL
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity traffic_light_moore is
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           -- Saídas: Luzes Vermelha, Amarela, Verde para direções NS e EW
           NS_RED, NS_YELLOW, NS_GREEN : out STD_LOGIC;
           EW_RED, EW_YELLOW, EW_GREEN : out STD_LOGIC );
end traffic_light_moore;

architecture Behavioral of traffic_light_moore is
    type state_type is (RED_RED, RED_YELLOW, GREEN_RED, YELLOW_RED,
                       RED_GREEN, RED_YELLOW_EW);  -- Usando nomes descritivos
    signal state, next_state : state_type;
begin
    -- Registro de estado
    process (CLK, RESET)
    begin
        if RESET = '1' then
            state <= RED_RED;
        elsif rising_edge(CLK) then
            state <= next_state;
        end if;
    end process;
    
    -- Lógica de próximo estado
    process (state)
    begin
        case state is
            when RED_RED =>      -- NS Vermelho, EW Vermelho
                next_state <= RED_YELLOW;
            when RED_YELLOW =>   -- NS Vermelho+Amarelo, EW Vermelho
                next_state <= GREEN_RED;
            when GREEN_RED =>    -- NS Verde, EW Vermelho
                next_state <= YELLOW_RED;
            when YELLOW_RED =>   -- NS Amarelo, EW Vermelho
                next_state <= RED_GREEN;
            when RED_GREEN =>    -- NS Vermelho, EW Verde
                next_state <= RED_YELLOW_EW;
            when RED_YELLOW_EW => -- NS Vermelho, EW Amarelo+Vermelho
                next_state <= RED_RED;
            when others =>
                next_state <= RED_RED;
        end case;
    end process;
    
    -- Lógica de saída (Moore: saídas dependem apenas do estado)
    process (state)
    begin
        -- Padrão: todas as luzes apagadas
        NS_RED <= '0'; NS_YELLOW <= '0'; NS_GREEN <= '0';
        EW_RED <= '0'; EW_YELLOW <= '0'; EW_GREEN <= '0';
        
        case state is
            when RED_RED =>
                NS_RED <= '1'; EW_RED <= '1';
            when RED_YELLOW =>
                NS_RED <= '1'; NS_YELLOW <= '1'; EW_RED <= '1';
            when GREEN_RED =>
                NS_GREEN <= '1'; EW_RED <= '1';
            when YELLOW_RED =>
                NS_YELLOW <= '1'; EW_RED <= '1';
            when RED_GREEN =>
                NS_RED <= '1'; EW_GREEN <= '1';
            when RED_YELLOW_EW =>
                NS_RED <= '1'; EW_YELLOW <= '1'; EW_RED <= '1';
            when others =>
                -- Padrão (não deveria chegar aqui)
                NS_RED <= '1'; EW_RED <= '1';
        end case;
    end process;
end Behavioral;
```

## Receptor UART (Máquina de Mealy)

### Receptor UART Simplificado (8N1: 8 bits de dados, sem paridade, 1 bit de parada)
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uart_receiver is
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           RX : in  STD_LOGIC;  -- Entrada serial
           DATA_OUT : out STD_LOGIC_VECTOR(7 downto 0);
           DATA_VALID : out STD_LOGIC );
end uart_receiver;

architecture Behavioral of uart_receiver is
    type state_type is (IDLE, START_BIT, DATA_BITS, STOP_BIT);
    signal state, next_state : state_type;
    signal bit_count : INTEGER range 0 to 7 := 0;
    signal shift_reg : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    -- Assumimos que estamos amostrando em 16x taxa de baud para simplificação
    -- Na prática, você precisaria de um gerador de taxa de baud
begin
    -- Registro de estado
    process (CLK, RESET)
    begin
        if RESET = '1' then
            state <= IDLE;
        elsif rising_edge(CLK) then
            state <= next_state;
        end if;
    end process;
    
    -- Lógica de próximo estado (Mealy: depende do estado e entrada)
    process (state, RX, bit_count)
    begin
        case state is
            when IDLE =>
                if RX = '0' then  -- Bit de início detectado
                    next_state <= START_BIT;
                else
                    next_state <= IDLE;
                end if;
            when START_BIT =>
                next_state <= DATA_BITS;
            when DATA_BITS =>
                if bit_count = 7 then
                    next_state <= STOP_BIT;
                else
                    next_state <= DATA_BITS;
                end if;
            when STOP_BIT =>
                if RX = '1' then  -- Bit de parada válido
                    next_state <= IDLE;
                else
                    next_state <= IDLE;  -- Poderia adicionar estado de erro
                end if;
            when others =>
                next_state <= IDLE;
        end case;
    end process;
    
    -- Lógica de saída e interna
    process (CLK, RESET)
    begin
        if RESET = '1' then
            bit_count <= 0;
            shift_reg <= (others => '0');
            DATA_VALID <= '0';
        elsif rising_edge(CLK) then
            case state is
                when IDLE =>
                    DATA_VALID <= '0';
                when START_BIT =>
                    bit_count <= 0;  -- Resetar contador de bits
                    shift_reg <= (others => '0');
                when DATA_BITS =>
                    -- Deslocar bit recebido (LSB primeiro)
                    shift_reg <= RX & shift_reg(7 downto 1);
                    bit_count <= bit_count + 1;
                when STOP_BIT =>
                    if RX = '1' then
                        DATA_VALID <= '1';  -- Dados válidos recebidos
                        DATA_OUT <= shift_reg;
                    end if;
                when others =>
                    null;
            end case;
        end if;
    end process;
end Behavioral;
```

## Controlador de Máquina de Venda (Moore com Múltiplas Entradas)

### Máquina de Venda Simplificada
- Aceita nickels (5¢) e dimes (10¢)
- Item custa 15¢
- Retorna troco se pago a mais
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity vending_machine is
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           NICKEL : in  STD_LOGIC;  -- Moeda de 5¢
           DIME : in  STD_LOGIC;    -- Moeda de 10¢
           ITEM : out STD_LOGIC;    -- Dispensar item
           CHANGE_5C : out STD_LOGIC; -- Retornar 5¢
           CHANGE_10C : out STD_LOGIC ); -- Retornar 10¢
end vending_machine;

architecture Behavioral of vending_machine is
    type state_type is (ZERO, FIVE_CENT, TEN_CENT, FIFTEEN_CENT, 
                       TWENTY_CENT, TWENTY_FIVE_CENT);
    signal state, next_state : state_type;
begin
    -- Registro de estado
    process (CLK, RESET)
    begin
        if RESET = '1' then
            state <= ZERO;
        elsif rising_edge(CLK) then
            state <= next_state;
        end if;
    end process;
    
    -- Lógica de próximo estado
    process (state, NICKEL, DIME)
    begin
        -- Padrão: permanecer no estado atual
        next_state <= state;
        
        case state is
            when ZERO =>
                if NICKEL = '1' then
                    next_state <= FIVE_CENT;
                elsif DIME = '1' then
                    next_state <= TEN_CENT;
                end if;
            when FIVE_CENT =>
                if NICKEL = '1' then
                    next_state <= TEN_CENT;
                elsif DIME = '1' then
                    next_state <= FIFTEEN_CENT;
                end if;
            when TEN_CENT =>
                if NICKEL = '1' then
                    next_state <= FIFTEEN_CENT;
                elsif DIME = '1' then
                    next_state <= TWENTY_CENT;
                end if;
            when FIFTEEN_CENT =>
                -- Item comprado, reset para próxima transação
                next_state <= ZERO;
            when TWENTY_CENT =>
                if NICKEL = '1' then
                    next_state <= TWENTY_FIVE_CENT;
                elsif DIME = '1' then
                    next_state <= ZERO;  -- 20+10=30, dar item de 15¢ + 15¢ de troco (simplificado)
                end if;
            when TWENTY_FIVE_CENT =>
                next_state <= ZERO;  -- 25¢: dar item + 10¢ de troco
            when others =>
                next_state <= ZERO;
        end case;
    end process;
    
    -- Lógica de saída (Moore)
    process (state)
    begin
        ITEM <= '0';
        CHANGE_5C <= '0';
        CHANGE_10C <= '0';
        
        case state is
            when FIFTEEN_CENT =>
                ITEM <= '1';  -- Dispensar item
            when TWENTY_FIVE_CENT =>
                ITEM <= '1';  -- Dispensar item
                CHANGE_10C <= '1';  -- Retornar 10¢
            when TWENTY_CENT =>
                -- Em uma máquina real, poderia retornar 5¢ + verificar se outro item pode ser dispensado
                -- Para simplificação, vamos apenas esperar pela entrada de moeda para resetar
                null;
            when others =>
                null;
        end case;
    end process;
end Behavioral;
```

## Diretrizes de Codificação de FSM

### Codificação de Estado
- **Codificação binária**: Menos flip-flops, mas pode causar falhas
- **Código de Gray**: Apenas um bit muda entre estados (reduz consumo/falhas)
- **Codificação one-hot**: Um flip-flop por estado (decodificação mais simples, mais flip-flops)
- Para FSMs pequenas (<10 estados), one-hot é frequentemente preferido em FPGAs

### Declaração de Estado
```vhdl
type state_type is (S0, S1, S2, S3);
signal state, next_state : state_type;
```

### FSM de Três Processos (Recomendado)
1. **Processo de registro de estado** (com relógio)
2. **Processo de lógica de próximo estado** (combinacional)
3. **Processo de lógica de saída** (combinacional para Moore, combinacional com entradas para Mealy)

### Estratégia de Reset
- Use reset síncrono para projeto totalmente síncrono
- Reset assíncrono apenas se realmente necessário para resposta imediata

### Tratamento de Estado Inválido
Sempre inclua uma cláusula `when others` em instruções case para lidar com estados inesperados.

### Registro de Saída
Para máquinas de Mealy, considere registrar saídas para melhorar o timing:
```vhdl
process (CLK)
begin
    if rising_edge(CLK) then
        registered_output <= combinational_output;
    end if;
end process;
```

## Ferramentas de Detecção e Análise de FSM

### Ferramentas de Lint
- SpyGlass
- Real Intent
- Questa Lint

### Simulação
- Verifique todas as transições de estado
- Teste casos extremos e condições de erro

### Verificação Formal
- Verificação de modelo para provar propriedades
- Verificação de equivalência entre especificações e implementação

No próximo arquivo, exploraremos bancadas de teste para simulação e verificação.
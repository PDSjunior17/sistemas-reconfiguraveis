# Exemplos de Lógica Sequencial

A lógica sequencial tem saídas que dependem tanto das entradas atuais quanto dos estados passados (memória).

## Flip-Flops

### Flip-Flop D (Borda Positiva)
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity d_flipflop is
    Port ( D : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           Q : out STD_LOGIC );
end d_flipflop;

architecture Behavioral of d_flipflop is
begin
    process (CLK)
    begin
        if rising_edge(CLK) then
            Q <= D;
        end if;
    end process;
end Behavioral;
```

### Flip-Flop D com Reset Assíncrono
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity d_flipflop_reset is
    Port ( D : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;  -- Reset ativo em alto
           Q : out STD_LOGIC );
end d_flipflop_reset;

architecture Behavioral of d_flipflop_reset is
begin
    process (CLK, RESET)
    begin
        if RESET = '1' then
            Q <= '0';
        elsif rising_edge(CLK) then
            Q <= D;
        end if;
    end process;
end Behavioral;
```

### Flip-Flop D com Reset Síncrono
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity d_flipflop_sync_reset is
    Port ( D : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;  -- Reset ativo em alto
           Q : out STD_LOGIC );
end d_flipflop_sync_reset;

architecture Behavioral of d_flipflop_sync_reset is
begin
    process (CLK)
    begin
        if rising_edge(CLK) then
            if RESET = '1' then
                Q <= '0';
            else
                Q <= D;
            end if;
        end if;
    end process;
end Behavioral;
```

### Flip-Flop JK
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity jk_flipflop is
    Port ( J : in  STD_LOGIC;
           K : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           Q : out STD_LOGIC;
           Q_NOT : out STD_LOGIC );
end jk_flipflop;

architecture Behavioral of jk_flipflop is
    signal Q_int : STD_LOGIC := '0';
begin
    process (CLK, RESET)
    begin
        if RESET = '1' then
            Q_int <= '0';
        elsif rising_edge(CLK) then
            case (J & K) is
                when "00" => Q_int <= Q_int;     -- Manter
                when "01" => Q_int <= '0';       -- Reset
                when "10" => Q_int <= '1';       -- Definir
                when "11" => Q_int <= not Q_int; -- Alternar
                when others => null;
            end case;
        end if;
    end process;
    
    Q <= Q_int;
    Q_NOT <= not Q_int;
end Behavioral;
```

### Flip-Flop T (Alternar)
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity t_flipflop is
    Port ( T : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           Q : out STD_LOGIC );
end t_flipflop;

architecture Behavioral of t_flipflop is
    signal Q_int : STD_LOGIC := '0';
begin
    process (CLK, RESET)
    begin
        if RESET = '1' then
            Q_int <= '0';
        elsif rising_edge(CLK) then
            if T = '1' then
                Q_int <= not Q_int;
            end if;
        end if;
    end process;
    
    Q <= Q_int;
end Behavioral;
```

## Registradores

### Registrador de Carregamento Paralelo
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity parallel_load_register is
    Generic ( WIDTH : integer := 8 );
    Port ( D : in  STD_LOGIC_VECTOR(WIDTH-1 downto 0);
           LOAD : in  STD_LOGIC;  -- Habilitação de carregamento ativo em alto
           CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           Q : out STD_LOGIC_VECTOR(WIDTH-1 downto 0) );
end parallel_load_register;

architecture Behavioral of parallel_load_register is
begin
    process (CLK, RESET)
    begin
        if RESET = '1' then
            Q <= (others => '0');
        elsif rising_edge(CLK) then
            if LOAD = '1' then
                Q <= D;
            end if;
        end if;
    end process;
end Behavioral;
```

### Registrador de Deslocamento
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_register is
    Generic ( WIDTH : integer := 8 );
    Port ( SI : in  STD_LOGIC;      -- Entrada serial
           SHIFT_EN : in  STD_LOGIC; -- Habilitação de deslocamento
           CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           Q : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
           SO : out STD_LOGIC );     -- Saída serial
end shift_register;

architecture Behavioral of shift_register is
    signal Q_int : STD_LOGIC_VECTOR(WIDTH-1 downto 0) := (others => '0');
begin
    process (CLK, RESET)
    begin
        if RESET = '1' then
            Q_int <= (others => '0');
        elsif rising_edge(CLK) then
            if SHIFT_EN = '1' then
                Q_int(WIDTH-1 downto 1) <= Q_int(WIDTH-2 downto 0);
                Q_int(0) <= SI;
            end if;
        end if;
    end process;
    
    Q <= Q_int;
    SO <= Q_int(WIDTH-1);
end Behavioral;
```

### Registrador de Deslocamento com Carregamento Paralelo
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shift_register_pl is
    Generic ( WIDTH : integer := 8 );
    Port ( D : in  STD_LOGIC_VECTOR(WIDTH-1 downto 0);  -- Dados paralelos
           SI : in  STD_LOGIC;                            -- Entrada serial
           LOAD : in  STD_LOGIC;                          -- Carregamento paralelo
           SHIFT_EN : in  STD_LOGIC;                      -- Habilitação de deslocamento
           CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           Q : out STD_LOGIC_VECTOR(WIDTH-1 downto 0);
           SO : out STD_LOGIC );     -- Saída serial
end shift_register_pl;

architecture Behavioral of shift_register_pl is
    signal Q_int : STD_LOGIC_VECTOR(WIDTH-1 downto 0) := (others => '0');
begin
    process (CLK, RESET)
    begin
        if RESET = '1' then
            Q_int <= (others => '0');
        elsif rising_edge(CLK) then
            if LOAD = '1' then
                Q_int <= D;
            elsif SHIFT_EN = '1' then
                Q_int(WIDTH-1 downto 1) <= Q_int(WIDTH-2 downto 0);
                Q_int(0) <= SI;
            end if;
        end if;
    end process;
    
    Q <= Q_int;
    SO <= Q_int(WIDTH-1);
end Behavioral;
```

## Contadores (Formas Básicas)

### Contador Binário (Reset Assíncrono)
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity binary_counter is
    Generic ( WIDTH : integer := 8 );
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;  -- Ativo em alto
           ENABLE : in  STD_LOGIC; -- Habilitação de contagem
           Q : out STD_LOGIC_VECTOR(WIDTH-1 downto 0) );
end binary_counter;

architecture Behavioral of binary_counter is
    signal count : UNSIGNED(WIDTH-1 downto 0) := (others => '0');
begin
    process (CLK, RESET)
    begin
        if RESET = '1' then
            count <= (others => '0');
        elsif rising_edge(CLK) then
            if ENABLE = '1' then
                count <= count + 1;
            end if;
        end if;
    end process;
    
    Q <= STD_LOGIC_VECTOR(count);
end Behavioral;
```

### Contador Binário com Reset Síncrono e Controle de Direção
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity up_down_counter is
    Generic ( WIDTH : integer := 8 );
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;  -- Reset síncrono
           ENABLE : in  STD_LOGIC;
           UP : in  STD_LOGIC;     -- '1' para cima, '0' para baixo
           Q : out STD_LOGIC_VECTOR(WIDTH-1 downto 0) );
end up_down_counter;

architecture Behavioral of up_down_counter is
    signal count : UNSIGNED(WIDTH-1 downto 0) := (others => '0');
begin
    process (CLK)
    begin
        if rising_edge(CLK) then
            if RESET = '1' then
                count <= (others => '0');
            elsif ENABLE = '1' then
                if UP = '1' then
                    count <= count + 1;
                else
                    count <= count - 1;
                end if;
            end if;
        end if;
    end process;
    
    Q <= STD_LOGIC_VECTOR(count);
end Behavioral;
```

## Arquivos de Registradores

### Arquivo de Registradores Simples
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file is
    Generic (
        DATA_WIDTH : integer := 8;
        ADDR_WIDTH : integer := 4  -- 16 registradores
    );
    Port ( 
        CLK : in  STD_LOGIC;
        WE3 : in  STD_LOGIC;                     -- Habilitação de escrita para porta 3
        A1 : in  STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);  -- Endereço de leitura 1
        A2 : in  STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);  -- Endereço de leitura 2
        A3 : in  STD_LOGIC_VECTOR(ADDR_WIDTH-1 downto 0);  -- Endereço de escrita
        WD3 : in  STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0); -- Dados de escrita
        RD1 : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0); -- Dados de leitura 1
        RD2 : out STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0)  -- Dados de leitura 2
    );
end register_file;

architecture Behavioral of register_file is
    type register_array is array(0 to 2**ADDR_WIDTH-1) of 
        STD_LOGIC_VECTOR(DATA_WIDTH-1 downto 0);
    signal registers : register_array := (others => (others => '0'));
begin
    process (CLK)
    begin
        if rising_edge(CLK) then
            if WE3 = '1' then
                registers(to_integer(unsigned(A3))) <= WD3;
            end if;
        end if;
    end process;
    
    RD1 <= registers(to_integer(unsigned(A1)));
    RD2 <= registers(to_integer(unsigned(A2)));
end Behavioral;
```

## Divisores de Relógio

### Divisor de Relógio Simples (por potência de 2)
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity clock_divider is
    Generic ( DIVISOR : integer := 4 );  -- Deve ser potência de 2 para esta implementação
    Port ( CLK_IN : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           CLK_OUT : out STD_LOGIC );
end clock_divider;

architecture Behavioral of clock_divider is
    signal count : INTEGER range 0 to DIVISOR-1 := 0;
    signal clk_int : STD_LOGIC := '0';
begin
    process (CLK_IN, RESET)
    begin
        if RESET = '1' then
            count <= 0;
            clk_int <= '0';
        elsif rising_edge(CLK_IN) then
            if count = DIVISOR-1 then
                count <= 0;
                clk_int <= not clk_int;
            else
                count <= count + 1;
            end if;
        end if;
    end process;
    
    CLK_OUT <= clk_int;
end Behavioral;
```

## Princípios Importantes de Projeto Sequencial

### Tipos de Reset
- **Reset assíncrono**: Tem efeito imediatamente (independente do relógio)
- **Reset síncrono**: Tem efeito apenas na borda do relógio
- Resets assíncronos podem causar metastabilidade se liberados perto da borda do relógio
- Resets síncronos são totalmente síncronos, mas podem usar mais lógica

### Relógios
- Use `rising_edge(CLK)` ou `falling_edge(CLK)` para detecção de borda
- Evite usar o relógio como dado (ex: `if CLK = '1' and CLK'event`) - use as funções de borda em vez disso
- Mantenha os sinais de relógio nos recursos dedicados de roteamento de relógio

### Sinais de Habilitação
- Use habilitações de relógio em vez de portas de relógio
- Relógios com portas podem causar problemas de timing e usar recursos não-relógio

### Sinal vs Variável em Processos
- **Sinais**: Atualizam no final do processo (atraso delta), visíveis fora do processo
- **Variáveis**: Atualizam imediatamente, visíveis apenas dentro do processo
- Para lógica sequencial, geralmente use sinais para saídas e variáveis para cálculo temporário

No próximo arquivo, exploraremos projetos de contadores com mais detalhes.
# Bancadas de Teste e Simulação

Bancadas de teste são programas VHDL usados para verificar a correção de projetos digitais aplicando estímulos e verificando respostas.

## Estrutura da Bancada de Teste

Uma bancada de teste típica consiste em:

1. **Declaração de entidade** (geralmente vazia)
2. **Arquitetura** contendo:
   - Declarações de sinais para conexões com o DUT
   - Instanciação do DUT (Declaração de Componente + Mapeamento de Portas)
   - Geração de estímulo (relógio, reset, vetores de teste)
   - Verificação de resposta (asserções, verificação de forma de onda)
   - Opcional: controle de teste e relatório

## Modelo Básico de Bancada de Teste

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  -- Para operações com não assinado/assinado se necessário

entity tb_<nome_do_projeto> is
  -- A entidade da bancada de teste é tipicamente vazia
end tb_<nome_do_projeto>;

architecture Behavioral of tb_<nome_do_projeto> is
  -- Declaração de componente para o DUT
  component <nome_do_projeto>
    Port ( -- Portas do DUT );
  end component;
  
  -- Sinais para conectar ao DUT
  signal <nome_do_sinal> : <tipo> := <valor_inicial>;
  -- Sinais de relógio e reset
  signal CLK : STD_LOGIC := '0';
  signal RESET : STD_LOGIC := '0';
  
  -- Constante de período do relógio
  constant CLK_PERIOD : time := 10 ns;
  
begin
  -- Instanciação do DUT
  uut: <nome_do_projeto>
    port map (
      -- Mapear portas do DUT para sinais da bancada de teste
    );
    
  -- Processo de geração de relógio
  CLK_process : process
  begin
    CLK <= '0';
    wait for CLK_PERIOD/2;
    CLK <= '1';
    wait for CLK_PERIOD/2;
  end process;
  
  -- Processo de estímulo
  stimulus : process
  begin
    -- Aplicar reset
    RESET <= '1';
    wait for 2*CLK_PERIOD;
    RESET <= '0';
    
    -- Aplicar vetores de teste aqui
    
    -- Fim da simulação
    wait;
  end process;
  
  -- Opcional: Processo de verificação de resposta
  checker : process
  begin
    wait until rising_edge(CLK);
    -- Verificar saídas esperadas
  end process;
  
end Behavioral;
```

## Bancada de Teste para Porta AND

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_and_gate is
end tb_and_gate;

architecture Behavioral of tb_and_gate is
  -- Declaração de componente
  component and_gate
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           Y : out STD_LOGIC );
  end component;
  
  -- Sinais da bancada de teste
  signal A : STD_LOGIC := '0';
  signal B : STD_LOGIC := '0';
  signal Y : STD_LOGIC;
  
begin
  -- Instanciação do DUT
  uut: and_gate
    port map (
      A => A,
      B => B,
      Y => Y
    );
    
  -- Processo de estímulo
  stimulus : process
  begin
    -- Testar todas as combinações de A e B
    A <= '0'; B <= '0'; wait for 10 ns;
    assert Y = '0' report "Falhou para A=0,B=0" severity error;
    
    A <= '0'; B <= '1'; wait for 10 ns;
    assert Y = '0' report "Falhou para A=0,B=1" severity error;
    
    A <= '1'; B <= '0'; wait for 10 ns;
    assert Y = '0' report "Falhou para A=1,B=0" severity error;
    
    A <= '1'; B <= '1'; wait for 10 ns;
    assert Y = '1' report "Falhou para A=1,B=1" severity error;
    
    -- Fim da simulação
    wait;
  end process;
end Behavioral;
```

## Bancada de Teste com Visualização de Forma de Onda (Sem Asserções)

Às vezes você apenas quer ver formas de onda em um simulador como GTKWave:
```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_and_gate_simple is
end tb_and_gate_simple;

architecture Behavioral of tb_and_gate_simple is
  component and_gate
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           Y : out STD_LOGIC );
  end component;
  
  signal A : STD_LOGIC := '0';
  signal B : STD_LOGIC := '0';
  signal Y : STD_LOGIC;
  
begin
  uut: and_gate
    port map (A => A, B => B, Y => Y);
    
  -- Estímulo simples: alternar entradas
  stimulus : process
  begin
    wait for 10 ns; A <= '0'; B <= '0';
    wait for 10 ns; A <= '0'; B <= '1';
    wait for 10 ns; A <= '1'; B <= '0';
    wait for 10 ns; A <= '1'; B <= '1';
    wait for 40 ns;  -- Manter último valor para vê-lo
    wait;
  end process;
end Behavioral;
```

## Bancada de Teste para Flip-Flop D

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_d_flipflop is
end tb_d_flipflop;

architecture Behavioral of tb_d_flipflop is
  component d_flipflop
    Port ( D : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           Q : out STD_LOGIC );
  end component;
  
  signal D : STD_LOGIC := '0';
  signal CLK : STD_LOGIC := '0';
  signal Q : STD_LOGIC;
  
  constant CLK_PERIOD : time := 10 ns;
  
begin
  uut: d_flipflop
    port map (D => D, CLK => CLK, Q => Q);
    
  -- Geração de relógio
  CLK_process : process
  begin
    CLK <= '0';
    wait for CLK_PERIOD/2;
    CLK <= '1';
    wait for CLK_PERIOD/2;
  end process;
  
  -- Estímulo
  stimulus : process
  begin
    -- Aplicar reset (se o FF tiver reset)
    -- Para este FF básico, apenas testar captura de dados
    
    wait for 20 ns;  -- Deixar o relógio estabilizar
    
    -- Teste: D=0 deveria dar Q=0 na próxima borda de subida
    D <= '0';
    wait until rising_edge(CLK);
    wait for 1 ns;  -- Pequeno atraso para ver o resultado
    assert Q = '0' report "FF falhou ao capturar D=0" severity error;
    
    -- Teste: D=1 deveria dar Q=1 na próxima borda de subida
    D <= '1';
    wait until rising_edge(CLK);
    wait for 1 ns;
    assert Q = '1' report "FF falhou ao capturar D=1" severity error;
    
    -- Teste: D mudando entre relógios não deveria afetar Q
    D <= '0';
    wait for 8 ns;  -- Mudar D bem antes do próximo relógio
    D <= '1';
    wait for 8 ns;  -- Mudar de volta antes do relógio
    wait until rising_edge(CLK);
    wait for 1 ns;
    assert Q = '1' report "FF capturou glitch em D" severity error;
    
    wait;
  end process;
end Behavioral;
```

## Bancada de Teste para Contador Binário de 4 bits

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_binary_counter is
end tb_binary_counter;

architecture Behavioral of tb_binary_counter is
  component binary_counter
    Generic ( WIDTH : integer := 4 );
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           ENABLE : in  STD_LOGIC;
           Q : out STD_LOGIC_VECTOR(WIDTH-1 downto 0) );
  end component;
  
  signal CLK : STD_LOGIC := '0';
  signal RESET : STD_LOGIC := '0';
  signal ENABLE : STD_LOGIC := '0';
  signal Q : STD_LOGIC_VECTOR(3 downto 0);
  
  constant CLK_PERIOD : time := 10 ns;
  
begin
  uut: binary_counter
    generic map (WIDTH => 4)
    port map (CLK => CLK, RESET => RESET, ENABLE => ENABLE, Q => Q);
    
  -- Geração de relógio
  CLK_process : process
  begin
    CLK <= '0';
    wait for CLK_PERIOD/2;
    CLK <= '1';
    wait for CLK_PERIOD/2;
  end process;
  
  -- Estímulo
  stimulus : process
  begin
    -- Aplicar reset
    RESET <= '1';
    wait for 2*CLK_PERIOD;
    RESET <= '0';
    
    -- Esperar um pouco após a desassertion do reset
    wait for 2*CLK_PERIOD;
    
    -- Habilitar contagem
    ENABLE <= '1';
    
    -- Deixar contar por 16 ciclos (deveria dar overflow)
    wait for 16*CLK_PERIOD;
    
    -- Desabilitar contagem
    ENABLE <= '0';
    wait for 4*CLK_PERIOD;
    
    -- Re-habilitar e testar carregamento (se o contador tiver carregamento)
    -- ENABLE <= '1';
    -- wait;
    
    wait;
  end process;
  
  -- Opcional: Verificações simples
  checker : process
  begin
    wait until rising_edge(CLK);
    if RESET = '1' then
      assert Q = "0000" report "Contador não resetado" severity error;
    elsif ENABLE = '1' then
      -- Poderia adicionar verificações mais detalhadas aqui
      null;
    end if;
  end process;
end Behavioral;
```

## Bancada de Teste para FSM de Semáforo

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_traffic_light_moore is
end tb_traffic_light_moore;

architecture Behavioral of tb_traffic_light_moore is
  component traffic_light_moore
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           NS_RED, NS_YELLOW, NS_GREEN : out STD_LOGIC;
           EW_RED, EW_YELLOW, EW_GREEN : out STD_LOGIC );
  end component;
  
  signal CLK : STD_LOGIC := '0';
  signal RESET : STD_LOGIC := '0';
  signal NS_RED, NS_YELLOW, NS_GREEN : STD_LOGIC;
  signal EW_RED, EW_YELLOW, EW_GREEN : STD_LOGIC;
  
  constant CLK_PERIOD : time := 10 ns;
  
begin
  uut: traffic_light_moore
    port map (
      CLK => CLK,
      RESET => RESET,
      NS_RED => NS_RED,
      NS_YELLOW => NS_YELLOW,
      NS_GREEN => NS_GREEN,
      EW_RED => EW_RED,
      EW_YELLOW => EW_YELLOW,
      EW_GREEN => EW_GREEN
    );
    
  -- Geração de relógio
  CLK_process : process
  begin
    CLK <= '0';
    wait for CLK_PERIOD/2;
    CLK <= '1';
    wait for CLK_PERIOD/2;
  end process;
  
  -- Estímulo
  stimulus : process
  begin
    -- Aplicar reset para inicializar
    RESET <= '1';
    wait for 3*CLK_PERIOD;
    RESET <= '0';
    
    -- Deixar executar por alguns ciclos
    wait for 100*CLK_PERIOD;
    
    -- Fim da simulação
    wait;
  end process;
  
  -- Opcional: Verificar que apenas uma luz NS e uma luz EW estão acesas ao mesmo tempo
  checker : process
  begin
    wait until rising_edge(CLK);
    if RESET = '0' then
      assert (NS_RED + NS_YELLOW + NS_GREEN) = 1
        report "Estado inválido da luz NS" severity error;
      assert (EW_RED + EW_YELLOW + EW_GREEN) = 1
        report "Estado inválido da luz EW" severity error;
    end if;
  end process;
end Behavioral;
```

## Técnicas Avançadas de Bancada de Teste

### Uso de Procedimentos para Tarefas Repetitivas
```vhdl
package tb_utils is
  procedure apply_reset(signal CLK : out STD_LOGIC;
                        signal RESET : out STD_LOGIC;
                        constant reset_cycles : integer := 2);
  procedure wait_clocks(signal CLK : out STD_LOGIC;
                        constant cycles : integer := 1);
end package;

package body tb_utils is
  procedure apply_reset(signal CLK : out STD_LOGIC;
                        signal RESET : out STD_LOGIC;
                        constant reset_cycles : integer := 2) is
  begin
    RESET <= '1';
    for i in 1 to reset_cycles loop
      wait until rising_edge(CLK);
    end loop;
    RESET <= '0';
  end procedure;
  
  procedure wait_clocks(signal CLK : out STD_LOGIC;
                        constant cycles : integer := 1) is
  begin
    for i in 1 to cycles loop
      wait until rising_edge(CLK);
    end loop;
  end procedure;
end package body;

-- Uso na bancada de teste:
-- apply_reset(CLK, RESET, 2);
-- wait_clocks(CLK, 10);
```

### Teste Direcionado por Dados com Arrays
```vhdl
type test_vector is record
    A : STD_LOGIC_VECTOR(3 downto 0);
    B : STD_LOGIC_VECTOR(3 downto 0);
    expected_sum : STD_LOGIC_VECTOR(4 downto 0);
end type;

constant test_vectors : test_vector_array(0 to 3) := (
  (A => "0000", B => "0000", expected_sum => "00000"),
  (A => "0001", B => "0001", expected_sum => "00010"),
  (A => "1111", B => "0001", expected_sum => "10000"),
  (A => "1111", B => "1111", expected_sum => "11110")
);

-- Então percorrer test_vectors no processo de estímulo
```

### Bancadas de Teste Auto-Verificáveis
```vhdl
-- Em vez de apenas observar formas de onda, verifique resultados automaticamente
checker : process
begin
  wait until rising_edge(CLK);
  if RESET = '0' then
    -- Calcular resultado esperado
    expected <= std_logic_vector(unsigned(A) + unsigned(B));
    -- Verificar resultado real
    assert actual = expected
      report "Descorrespondência: obtido " & integer'image(to_integer(unsigned(actual))) &
             " esperado " & integer'image(to_integer(unsigned(expected)))
      severity error;
  end if;
end process;
```

## Dicas de Simulação

### Geração de Relógio
- Sempre use geração adequada de relógio com ciclo de 50%
- Use constantes para o período do relógio para facilitar alterações
- Considere usar declarações `after` para relógios simples em bancadas de teste pequenas:
  ```vhdl
  CLK_process : process
  begin
    CLK <= '0';
    wait for 5 ns;
    loop
      CLK <= not CLK;
      wait for 5 ns;
    end loop;
  end process;
  ```

### Tratamento de Reset
- Aplique reset por tempo suficiente (geralmente 2-3 ciclos de relógio)
- Desassert o reset sincronamente para evitar metastabilidade
- Considere tanto cenários de reset síncrono quanto assíncrono

### Duração do Teste
- Execute testes por tempo suficiente para cobrir todos os cenários
- Use um timer de vigilância para prevenir simulação infinita:
  ```vhdl
  watchdog : process
  begin
    wait for 1 ms;  -- Ajuste conforme necessário
    assert false
      report "Simulação timed out" severity failure;
  end process;
  ```

### Visualização de Forma de Onda
- Para GTKWave: salve sinais como VCD ou use formato nativo do simulador
- Rotule sinais claramente na bancada de teste
- Agrupe sinais relacionados logicamente

## Erros Comuns em Bancadas de Teste

### Esquecendo de Inicializar Sinais
Sinais não inicializados podem causar comportamento imprevisível, especialmente em FPGAs.

### Listas de Sensibilidade Incompletas
Em processos combinacionais, sinais faltando na lista de sensibilidade criam latches.

### Falhas de Relógio
Geração inadequada de relógio pode criar falhas que causam múltiplas bordas.

### Não Esperar pela Estabilidade
Verificando saídas muito cedo após alterações de entrada (antes do atraso de propagação).

### Laços Infinitos Sem Espera
Processos sem declarações de espera simulam tempo zero e travam o simulador.

### Ignorando Condições de Reset
Não testando o comportamento de reset ou assumindo estado de energia ligada.

## Execução de Bancadas de Teste

### Com GHDL (Código Aberto)
```bash
# Analisar
ghdl -a and_gate.vhd
ghdl -a tb_and_gate.vhd

# Elaborar
ghdl -e tb_and_gate

# Executar
ghdl -r tb_and_gate --wave=and_gate.ghw

# Visualizar formas de onda
gtkwave and_gate.ghw
```

### Com ModelSim/QuestaSim
```bash
# Compilar
vcom and_gate.vhd
vcom tb_and_gate.vhd

# Simular
vsim tb_and_gate

# No console VSIM:
run -all
```

## Conclusão

Bancadas de teste boas são essenciais para verificar projetos digitais. Elas devem:
1. Ser auto-verificáveis quando possível
2. Cobrir casos extremos e condições de erro
3. Ser reutilizáveis e modificáveis
4. Documentar claramente o que está sendo testado
5. Gerar mensagens de erro significativas quando os testes falham

No próximo arquivo, abordaremos melhores práticas e armadilhas comuns no projeto VHDL.
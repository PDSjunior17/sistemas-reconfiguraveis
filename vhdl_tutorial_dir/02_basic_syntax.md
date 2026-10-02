# Sintaxe Básica e Estrutura do VHDL

## Estrutura de Arquivo VHDL

Um arquivo VHDL típico contém:

1. **Declarações de bibliotecas** - Especificam quais bibliotecas usar
2. **Cláusulas de uso** - Importam pacotes específicos das bibliotecas
3. **Declaração de entidade** - Define a interface (portas)
4. **Corpo da arquitetura** - Contém a implementação

## Bibliotecas e Pacotes

### Bibliotecas Comuns
- `IEEE`: Biblioteca padrão com tipos de lógica padrão
- `STD`: Ambiente padrão (geralmente implícito)

### Pacotes Essenciais
```vhdl
use IEEE.STD_LOGIC_1164.ALL;    -- Tipos de lógica padrão
use IEEE.NUMERIC_STD.ALL;       -- Tipos não assinados/assinados e matemática
use IEEE.STD_LOGIC_UNSIGNED.ALL; -- Matemática não assinada alternativa (obsoleta em favor do NUMERIC_STD)
use IEEE.MATH_REAL.ALL;         -- Funções de números reais (teto, piso, etc.)
```

## Declaração de Entidade

Define a interface externa de um módulo de hardware:

```vhdl
entity entity_name is
    Port (
        port_name : mode type;
        port_name : mode type;
        -- ...
    );
end entity_name;
```

### Modos de Porta
- `in`: Entrada apenas (somente leitura dentro da arquitetura)
- `out`: Saída apenas (somente gravação dentro da arquitetura)
- `inout`: Bidirecional (leitura e gravação)
- `buffer`: Saída que pode ser lida dentro da arquitetura

## Corpo da Arquitetura

Contém a descrição da implementação:

```vhdl
architecture architecture_name of entity_name is
    -- Declarações (sinais, componentes, tipos, etc.)
begin
    -- Declarações concorrentes e processos
end architecture_name;
```

### Estilos de Arquitetura
1. **Estrutural**: Descreve hierarquia através de instanciação de componentes
2. **Fluxo de Dados**: Usa atribuições de sinal concorrentes
3. **Comportamental**: Usa processos com declarações sequenciais
4. **Misto**: Combinação dos acima

## Tipos de Dados

### Tipos de Lógica Padrão (de STD_LOGIC_1164)
- `STD_LOGIC`: Bit simples (valores: '0','1','Z','U','X','W','L','H','-')
- `STD_LOGIC_VECTOR`: Vetor de elementos STD_LOGIC

### Tipos Numéricos (de NUMERIC_STD)
- `UNSIGNED`: Vetor de inteiro não assinado
- `SIGNED`: Vetor de inteiro assinado (complemento de 2)
- `INTEGER`: Tipo inteiro
- `REAL`: Tipo de ponto flutuante

### Tipos Definidos pelo Usuário
```vhdl
type state_type is (IDLE, PROCESSING, DONE);
type memory_type is array(0 to 15) of STD_LOGIC_VECTOR(7 downto 0);
```

## Declarações Concorrentes vs Sequenciais

### Declarações Concorrentes (executam em paralelo)
- Atribuições de sinais: `signal <= expression;`
- Instanciações de componentes
- Declarações de processo
- Quando/senão, gerar declarações

### Declarações Sequenciais (executam em ordem, dentro de processos)
- Atribuições de variáveis: `variable := expression;`
- Se-então-senão, caso
- Laços (para, enquanto, loop)
- Declarações de espera

## Exemplo Simples: Porta AND

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
    Y <= A and B;  -- Atribuição de sinal concorrente
end Behavioral;
```

## Noções Básicas de Processo

Um processo contém lógica sequencial:

```vhdl
process (lista_sensibilidade)
begin
    -- Declarações sequenciais aqui
end process;
```

Listas de sensibilidade comuns:
- `process (A, B)`: Dispara quando A ou B muda
- `process (clk)`: Dispara na borda do relógio (com detecção de borda dentro)
- `process (all)`: VHDL-2008 - dispara em qualquer sinal usado dentro

No próximo arquivo, exploraremos exemplos de lógica combinacional.
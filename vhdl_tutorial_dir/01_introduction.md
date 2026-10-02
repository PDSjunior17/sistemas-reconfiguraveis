# Introdução ao VHDL

## O que é VHDL?

VHDL (VHSIC Hardware Description Language) é uma linguagem de descrição de hardware usada para modelar sistemas digitais em vários níveis de abstração, desde algorítmico até nível de portas. Foi desenvolvida na década de 1980 pelo Departamento de Defesa dos EUA e tornou-se um padrão IEEE (IEEE 1076).

## Por que aprender VHDL?

- **Projeto de FPGA/ASIC**: Linguagem primária para programar FPGAs e projetar ASICs
- **Padrão da Indústria**: Amplamente utilizada em aeroespacial, defesa, telecomunicações e eletrônicos de consumo
- **Controle Preciso**: Permite especificação detalhada do comportamento e estrutura do hardware
- **Capaz de Simulação**: Pode simular projetos antes da implementação em hardware
- **Padronizada**: Linguagem bem estabelecida com extensa suporte de ferramentas

## VHDL vs Outras HDLs

Comparado a Verilog/SystemVerilog:
- **Verbosidade**: O VHDL é mais verboso, mas frequentemente considerado mais legível para sistemas complexos
- **Tipagem Forte**: O VHDL possui tipagem mais forte, o que pode capturar mais erros em tempo de compilação
- **Concorrência**: Ambas as linguagens descrevem inherentemente a operação concorrente do hardware
- **Popularidade**: Verilog é mais comum no projeto de ASICs, enquanto o VHDL é mais forte em FPGA e setores de defesa

## Fluxo Básico de Projeto em VHDL

1. **Entrada de Projeto**: Escreva código VHDL descrevendo o hardware desejado
2. **Simulação**: Verifique a funcionalidade usando uma bancada de teste
3. **Síntese**: Converta VHDL para netlist de nível de portas (para FPGA/ASIC)
4. **Implementação**: Coloque e rotas para a tecnologia alvo
5. **Verificação**: Análise de tempo e validação final

## Conceitos-Chave

### Entidade e Arquitetura
- **Entidade**: Define a interface (entradas/saídas) de um módulo de hardware
- **Arquitetura**: Descreve o comportamento interno ou a estrutura

### Sinais vs Variáveis
- **Sinais**: Usados para comunicação entre processos, possuem atrasos delta de simulação
- **Variáveis**: Usadas dentro de processos para armazenamento temporário, atualizam imediatamente

### Concorrência
As declarações VHDL são executadas concorrentemente, a menos que estejam fechadas em um processo, refletindo a paralelismo do hardware.

## Exemplo "Olá, Mundo!"

Uma entidade VHDL simples que emite um valor constante:

```vhdl
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity hello_world is
    Port ( led : out STD_LOGIC_VECTOR (7 downto 0) );
end hello_world;

architecture Behavioral of hello_world is
begin
    led <= "10101010";  -- Padrão alternado
end Behavioral;
```

No próximo arquivo, exploraremos a sintaxe e estrutura básica com mais detalhes.
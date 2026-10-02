# Tutorial de Aprendizado de VHDL

Bem-vindo a este tutorial estruturado para aprender VHDL (Linguagem de Descrição de Hardware VHSIC). Este guia é projetado para levá-lo dos conceitos básicos às práticas intermediárias de projeto em VHDL.

## Estrutura do Diretório

```
vhdl_tutorial_dir/
├── README.md                 # Este arquivo
├── 01_introduction.md        # Introdução ao VHDL
├── 02_basic_syntax.md        # Sintaxe básica e estrutura do VHDL
├── 03_combinational_logic.md # Exemplos de lógica combinacional
├── 04_sequential_logic.md    # Exemplos de lógica sequencial
├── 05_counters.md            # Projetos de contadores
├── 06_state_machines.md      # Exemplos de Máquinas de Estado Finitas
├── 07_testbenches.md         # Escrevendo bancadas de teste para simulação
├── 08_best_practices.md      # Melhores práticas e armadilhas comuns
└── examples/                 # Arquivos de exemplo VHDL
    ├── and_gate.vhd
    ├── or_gate.vhd
    ├── multiplexer.vhd
    ├── d_flipflop.vhd
    ├── binary_counter.vhd
    ├── ring_counter.vhd
    ├── fsm_example.vhd
    └── testbench_examples/
        ├── and_gate_tb.vhd
        ├── d_flipflop_tb.vhd
        └── binary_counter_tb.vhd
```

## Caminho de Aprendizado

1. **Comece aqui**: Leia `01_introduction.md` para entender o que é VHDL e por que ele é usado
2. **Aprenda sintaxe**: Estude `02_basic_syntax.md` para os fundamentos do VHDL
3. **Lógica combinacional**: Trabalhe com `03_combinational_logic.md` para portas, multiplexores, etc.
4. **Lógica sequencial**: Estude `04_sequential_logic.md` para flip-flops e registros
5. **Contadores**: Aprenda projetos de contadores em `05_counters.md`
6. **Máquinas de estado**: Explore FSMs em `06_state_machines.md`
7. **Bancadas de teste**: Aprenda verificação em `07_testbenches.md`
8. **Melhores práticas**: Revise `08_best_practices.md` antes de iniciar seus próprios projetos

## Exemplos

Cada tópico inclui exemplos práticos no diretório `examples/`. Você pode:
- Ler os arquivos .vhd para ver as implementações
- Simular eles usando um simulador VHDL (GHDL, ModelSim, etc.)
- Modificá-los para experimentar diferentes comportamentos

## Recomendação de Ferramentas

Para simulação e síntese:
- **Código aberto**: GHDL (para simulação), Yosys (para síntese)
- **Padrão da indústria**: ModelSim/QuestaSim (simulação), Vivado/Synopsys (síntese)
- **Online**: EDA Playground (https://www.edaplayground.com/) para simulação baseada em navegador

## Como Começar

Comece lendo o arquivo de introdução:
```bash
cat 01_introduction.md
```

Ou se preferir ler todos os arquivos em ordem:
```bash
for i in {01..08}; do echo "=== $i ==="; cat ${i}_*.md; echo; done
```

Boa aprendizagem de VHDL!
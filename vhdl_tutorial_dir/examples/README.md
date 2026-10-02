# VHDL Examples Directory

This directory contains example VHDL files that accompany the tutorial.

## Design Examples

### Basic Logic Gates
- `and_gate.vhd` - Simple AND gate
- `or_gate.vhd` - Simple OR gate

### Combinational Logic
- `multiplexer.vhd` - 4-to-1 multiplexer

### Sequential Logic
- `d_flipflop.vhd` - D flip-flop with asynchronous reset
- `binary_counter.vhd` - 8-bit binary counter with enable and synchronous reset
- `fsm_example.vhd` - Traffic light controller (Moore machine FSM)

## Testbench Examples
Located in the `testbench_examples/` subdirectory:

- `and_gate_tb.vhd` - Testbench for AND gate with verification
- `d_flipflop_tb.vhd` - Testbench for D flip-flop with clock generation and reset testing
- `binary_counter_tb.vhd` - Testbench for binary counter with comprehensive counting tests

## Usage

Each example can be simulated using a VHDL simulator such as:
- GHDL (open source)
- ModelSim/QuestaSim (industry standard)
- Vivado XSIL (Xilinx)
- Or online at EDA Playground (https://www.edaplayground.com/)

To simulate with GHDL:
```bash
# Analyze the design and testbench
ghdl -a and_gate.vhd
ghdl -a and_gate_tb.vhd

# Elaborate
ghdl -e and_gate_tb

# Run simulation
ghdl -r and_gate_tb --wave=and_gate.ghw

# View waveforms (requires GTKWave)
gtkwave and_gate.ghw
```

Feel free to modify these examples to experiment with different behaviors or to use as starting points for your own designs.
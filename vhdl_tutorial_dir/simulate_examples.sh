#!/bin/bash
# Simple simulation script for VHDL examples
# Requires GHDL to be installed and in PATH

echo "VHDL Example Simulation Script"
echo "=============================="

# Check if ghdl is available
if ! command -v ghdl &> /dev/null
then
    echo "Error: ghdl not found. Please install GHDL first."
    echo "On Ubuntu/Debian: sudo apt-get install ghdl"
    echo "On Fedora: sudo dnf install ghdl"
    echo "On macOS with Homebrew: brew install ghdl"
    exit 1
fi

# Create a directory for simulation output
SIM_DIR="sim_output"
mkdir -p $SIM_DIR

# List of examples to simulate
EXAMPLES=(
    "and_gate and_gate_tb"
    "d_flipflop d_flipflop_tb"
    "binary_counter binary_counter_tb"
)

echo "Available examples:"
for i in "${!EXAMPLES[@]}"; do
    echo "  $((i+1)). ${EXAMPLES[$i]}"
done

# Ask user which example to simulate
read -p "Enter the number of the example to simulate (1-${#EXAMPLES[@]}): " choice

# Validate input
if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt ${#EXAMPLES[@]} ]; then
    echo "Invalid choice. Exiting."
    exit 1
fi

# Get selected example
SELECTED=${EXAMPLES[$((choice-1))]}
DESIGN=$(echo $SELECTED | cut -d' ' -f1)
TESTBENCH=$(echo $SELECTED | cut -d' ' -f2)

echo "Simulating: $DESIGN with testbench $TESTBENCH"

# Analyze files
echo "Analyzing $DESIGN.vhd..."
ghdl -a ../examples/$DESIGN.vhd
if [ $? -ne 0 ]; then
    echo "Error analyzing $DESIGN.vhd"
    exit 1
fi

echo "Analyzing $TESTBENCH.vhd..."
ghdl -a ../examples/testbench_examples/$TESTBENCH.vhd
if [ $? -ne 0 ]; then
    echo "Error analyzing $TESTBENCH.vhd"
    exit 1
fi

# Elaborate
echo "Elaborating $TESTBENCH..."
ghdl -e $TESTBENCH
if [ $? -ne 0 ]; then
    echo "Error elaborating $TESTBENCH"
    exit 1
fi

# Run simulation
echo "Running simulation..."
ghdl -r $TESTBENCH --wave=$SIM_DIR/$DESIGN.ghw --stop-time=100ns
if [ $? -ne 0 ]; then
    echo "Error running simulation"
    exit 1
fi

echo "Simulation completed successfully!"
echo "Waveform saved to: $SIM_DIR/$DESIGN.ghw"
echo "To view waveforms, run: gtkwave $SIM_DIR/$DESIGN.ghw"
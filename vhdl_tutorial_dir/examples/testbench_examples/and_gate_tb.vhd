library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Testbench for AND gate
entity and_gate_tb is
end and_gate_tb;

architecture Behavioral of and_gate_tb is
    -- Component declaration
    component and_gate
        Port ( A : in  STD_LOGIC;
               B : in  STD_LOGIC;
               Y : out STD_LOGIC );
    end component;
    
    -- Testbench signals
    signal A : STD_LOGIC := '0';
    signal B : STD_LOGIC := '0';
    signal Y : STD_LOGIC;
    
begin
    -- DUT instantiation
    uut: and_gate
        port map (
            A => A,
            B => B,
            Y => Y
        );
        
    -- Stimulus process with verification
    stimulus : process
    begin
        -- Test all 4 combinations
        A <= '0'; B <= '0'; wait for 10 ns;
        assert Y = '0' report "AND gate failed: 0 AND 0 = 1" severity error;
        
        A <= '0'; B <= '1'; wait for 10 ns;
        assert Y = '0' report "AND gate failed: 0 AND 1 = 1" severity error;
        
        A <= '1'; B <= '0'; wait for 10 ns;
        assert Y = '0' report "AND gate failed: 1 AND 0 = 1" severity error;
        
        A <= '1'; B <= '1'; wait for 10 ns;
        assert Y = '1' report "AND gate failed: 1 AND 1 = 0" severity error;
        
        -- All tests passed
        report "All AND gate tests passed" severity note;
        wait;  -- End simulation
    end process;
end Behavioral;
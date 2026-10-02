library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Testbench for D Flip-Flop with asynchronous reset
entity d_flipflop_tb is
end d_flipflop_tb;

architecture Behavioral of d_flipflop_tb is
    -- Component declaration
    component d_flipflop
        Port ( D : in  STD_LOGIC;
               CLK : in  STD_LOGIC;
               RESET : in  STD_LOGIC;
               Q : out STD_LOGIC );
    end component;
    
    -- Testbench signals
    signal D : STD_LOGIC := '0';
    signal CLK : STD_LOGIC := '0';
    signal RESET : STD_LOGIC := '0';
    signal Q : STD_LOGIC;
    
    -- Clock period
    constant CLK_PERIOD : time := 10 ns;
    
begin
    -- DUT instantiation
    uut: d_flipflop
        port map (
            D => D,
            CLK => CLK,
            RESET => RESET,
            Q => Q
        );
        
    -- Clock generation process
    CLK_process : process
    begin
        CLK <= '0';
        wait for CLK_PERIOD/2;
        CLK <= '1';
        wait for CLK_PERIOD/2;
    end process;
    
    -- Test process
    test_process : process
    begin
        -- Apply reset
        RESET <= '1';
        wait for 2*CLK_PERIOD;
        assert Q = '0' report "Reset failed: Q should be 0" severity error;
        RESET <= '0';
        
        wait for 2*CLK_PERIOD;  -- Let circuit stabilize
        
        -- Test 1: D=0 should capture 0 on rising edge
        D <= '0';
        wait until rising_edge(CLK);
        wait for 1 ns;  -- Small delay to see result
        assert Q = '0' report "Failed to capture D=0" severity error;
        
        -- Test 2: D=1 should capture 1 on rising edge
        D <= '1';
        wait until rising_edge(CLK);
        wait for 1 ns;
        assert Q = '1' report "Failed to capture D=1" severity error;
        
        -- Test 3: D changing between clocks should not affect Q
        D <= '0';
        wait for 8 ns;  -- Change well before clock
        D <= '1';
        wait for 8 ns;  -- Change back before clock
        wait until rising_edge(CLK);
        wait for 1 ns;
        assert Q = '1' report "Capture glitch on D input" severity error;
        
        -- Test 4: Reset should override D
        D <= '1';  -- Set D to 1
        wait for 5 ns;
        RESET <= '1';  -- Apply reset
        wait for 2*CLK_PERIOD;
        assert Q = '0' report "Reset did not override D=1" severity error;
        RESET <= '0';
        
        report "All D flip-flop tests passed" severity note;
        wait;  -- End simulation
    end process;
end Behavioral;
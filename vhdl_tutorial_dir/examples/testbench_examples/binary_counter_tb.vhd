library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Testbench for 8-bit binary counter
entity binary_counter_tb is
end binary_counter_tb;

architecture Behavioral of binary_counter_tb is
    -- Component declaration
    component binary_counter
        Generic ( WIDTH : integer := 8 );
        Port ( CLK : in  STD_LOGIC;
               RESET : in  STD_LOGIC;
               ENABLE : in  STD_LOGIC;
               Q : out STD_LOGIC_VECTOR(WIDTH-1 downto 0) );
    end component;
    
    -- Testbench signals
    signal CLK : STD_LOGIC := '0';
    signal RESET : STD_LOGIC := '0';
    signal ENABLE : STD_LOGIC := '0';
    signal Q : STD_LOGIC_VECTOR(7 downto 0);
    
    -- Clock period
    constant CLK_PERIOD : time := 10 ns;
    
begin
    -- DUT instantiation
    uut: binary_counter
        generic map (WIDTH => 8)
        port map (CLK => CLK, RESET => RESET, ENABLE => ENABLE, Q => Q);
        
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
        assert Q = x"00" report "Counter not reset to 0" severity error;
        RESET <= '0';
        
        wait for 2*CLK_PERIOD;  -- Let circuit stabilize
        
        -- Enable counting
        ENABLE <= '1';
        
        -- Count from 0 to 255 and check wrap-around
        for i in 0 to 255 loop
            wait until rising_edge(CLK);
            wait for 1 ns;
            assert Q = std_logic_vector(to_unsigned(i, 8))
                report "Counter mismatch at count " & integer'image(i) &
                       ": expected " & to_hstring(std_logic_vector(to_unsigned(i, 8))) &
                       " got " & to_hstring(Q)
                severity error;
        end loop;
        
        -- After 255, next should be 0 (wrap around)
        wait until rising_edge(CLK);
        wait for 1 ns;
        assert Q = x"00" report "Counter did not wrap around after 255" severity error;
        
        -- Disable counting
        ENABLE <= '0';
        wait for 4*CLK_PERIOD;
        
        -- Check that value holds when disabled
        assert Q = x"01" report "Counter changed while disabled" severity error;
        
        -- Re-enable and continue counting
        ENABLE <= '1';
        wait until rising_edge(CLK);
        wait for 1 ns;
        assert Q = x"02" report "Counter did not continue from 0x01" severity error;
        
        report "All binary counter tests passed" severity note;
        wait;  -- End simulation
    end process;
end Behavioral;
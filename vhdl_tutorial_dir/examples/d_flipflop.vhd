library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- D Flip-Flop with asynchronous reset
entity d_flipflop is
    Port ( D : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;  -- Active high asynchronous reset
           Q : out STD_LOGIC );
end d_flipflop;

architecture Behavioral of d_flipflop is
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Simple traffic light controller (Moore machine)
entity traffic_light_controller is
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;
           -- North-South lights
           NS_RED : out STD_LOGIC;
           NS_YELLOW : out STD_LOGIC;
           NS_GREEN : out STD_LOGIC;
           -- East-West lights
           EW_RED : out STD_LOGIC;
           EW_YELLOW : out STD_LOGIC;
           EW_GREEN : out STD_LOGIC );
end traffic_light_controller;

architecture Behavioral of traffic_light_controller is
    type state_type is (RED_RED, RED_YELLOW, GREEN_RED, YELLOW_RED,
                       RED_GREEN, RED_YELLOW_EW);
    signal state, next_state : state_type;
begin
    -- State register (synchronous reset)
    process (CLK, RESET)
    begin
        if RESET = '1' then
            state <= RED_RED;
        elsif rising_edge(CLK) then
            state <= next_state;
        end if;
    end process;
    
    -- Next state logic
    process (state)
    begin
        case state is
            when RED_RED =>      -- All red for safety
                next_state <= RED_YELLOW;
            when RED_YELLOW =>   -- NS red+yellow, EW red
                next_state <= GREEN_RED;
            when GREEN_RED =>    -- NS green, EW red
                next_state <= YELLOW_RED;
            when YELLOW_RED =>   -- NS yellow, EW red
                next_state <= RED_GREEN;
            when RED_GREEN =>    -- NS red, EW green
                next_state <= RED_YELLOW_EW;
            when RED_YELLOW_EW => -- NS red, EW yellow+red
                next_state <= RED_RED;
            when others =>
                next_state <= RED_RED;
        end case;
    end process;
    
    -- Output logic (Moore: outputs depend only on state)
    process (state)
    begin
        -- Default: all lights off
        NS_RED <= '0'; NS_YELLOW <= '0'; NS_GREEN <= '0';
        EW_RED <= '0'; EW_YELLOW <= '0'; EW_GREEN <= '0';
        
        case state is
            when RED_RED =>
                NS_RED <= '1'; EW_RED <= '1';
            when RED_YELLOW =>
                NS_RED <= '1'; NS_YELLOW <= '1'; EW_RED <= '1';
            when GREEN_RED =>
                NS_GREEN <= '1'; EW_RED <= '1';
            when YELLOW_RED =>
                NS_YELLOW <= '1'; EW_RED <= '1';
            when RED_GREEN =>
                NS_RED <= '1'; EW_GREEN <= '1';
            when RED_YELLOW_EW =>
                NS_RED <= '1'; EW_YELLOW <= '1'; EW_RED <= '1';
            when others =>
                NS_RED <= '1'; EW_RED <= '1';  -- Safe default
        end case;
    end process;
end Behavioral;
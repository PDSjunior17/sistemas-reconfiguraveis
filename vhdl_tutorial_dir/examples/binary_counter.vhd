library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- 8-bit binary counter with enable and synchronous reset
entity binary_counter is
    Generic ( WIDTH : integer := 8 );
    Port ( CLK : in  STD_LOGIC;
           RESET : in  STD_LOGIC;  -- Synchronous reset
           ENABLE : in  STD_LOGIC;
           Q : out STD_LOGIC_VECTOR(WIDTH-1 downto 0) );
end binary_counter;

architecture Behavioral of binary_counter is
    signal count : UNSIGNED(WIDTH-1 downto 0) := (others => '0');
begin
    process (CLK)
    begin
        if rising_edge(CLK) then
            if RESET = '1' then
                count <= (others => '0');
            elsif ENABLE = '1' then
                count <= count + 1;
            end if;
        end if;
    end process;
    
    Q <= STD_LOGIC_VECTOR(count);
end Behavioral;
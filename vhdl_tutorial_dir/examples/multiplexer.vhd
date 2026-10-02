library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- 4-to-1 Multiplexer
entity multiplexer4to1 is
    Port ( A0 : in  STD_LOGIC;
           A1 : in  STD_LOGIC;
           A2 : in  STD_LOGIC;
           A3 : in  STD_LOGIC;
           S  : in  STD_LOGIC_VECTOR(1 downto 0);  -- 2-bit select
           Y  : out STD_LOGIC );
end multiplexer4to1;

architecture Behavioral of multiplexer4to1 is
begin
    Y <= A0 when S = "00" else
         A1 when S = "01" else
         A2 when S = "10" else
         A3;
end Behavioral;
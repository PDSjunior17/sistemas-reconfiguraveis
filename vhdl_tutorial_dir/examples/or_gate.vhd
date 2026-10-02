library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Simple OR gate example
entity or_gate is
    Port ( A : in  STD_LOGIC;
           B : in  STD_LOGIC;
           Y : out STD_LOGIC );
end or_gate;

architecture Behavioral of or_gate is
begin
    Y <= A or B;
end Behavioral;
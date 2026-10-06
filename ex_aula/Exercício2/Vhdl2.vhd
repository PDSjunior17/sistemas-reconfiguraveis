LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY mux_4x1z IS
  PORT (
       i: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
       s: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
       e: IN STD_LOGIC;
       y: OUT STD_LOGIC
  );
END ENTITY;
ARCHITECTURE arch OFmux_4x1z IS
    SIGNALaux : STD_LOGIC;
BEGIN
    WITH s SELECT
         aux <=i(0) WHEN"00",
               i(1) WHEN"01",
               i(2) WHEN"10",
               i(3) WHEN"11";
    y <= aux WHENe = '1' ELSE--when enabled
         'Z';--when disabled
END arch;
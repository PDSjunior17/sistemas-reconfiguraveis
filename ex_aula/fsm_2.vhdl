-- O bloco WHEN correspondente ao estado atual (s1_ag_p) está destacado abaixo em tempo real:

LIBRARY ieee;
USE ieee.std_logic_1164.all;
 
ARCHITECTURE arch OF fsm_2 IS
  TYPE state_type IS (s0_reb, s1_ag_p, s2_parado, s3_play_p, s4_play, s5_pausa_p, s6_pausa);
  SIGNAL pres_state, next_state : state_type;
BEGIN
  -- PROCESS 1: Memória de Estado (Sequencial)
  PROCESS (nrst, clk) BEGIN
    IF nrst = '0' THEN pres_state <= s1_ag_p;
    ELSIF RISING_EDGE(clk) THEN pres_state <= next_state;
    END IF;
  END PROCESS;
 
  -- PROCESS 2: Lógica de Próximo Estado e Saídas (Combinacional)
  PROCESS (p, s, b, e, pres_state) BEGIN
    CASE pres_state IS
      WHEN s0_reb =>    m <= '1'; d <= '0';
        IF b = '0' THEN next_state <= s0_reb;
        ELSIF p = '0' THEN next_state <= s1_ag_p;
        ELSE next_state <= s2_parado; END IF;
      WHEN s1_ag_p =>   m <= '0'; d <= '0';
        IF b = '0' THEN next_state <= s0_reb;
        ELSIF p = '0' THEN next_state <= s1_ag_p;
        ELSE next_state <= s2_parado; END IF;
      WHEN s2_parado => m <= '0'; d <= '0';
        IF s = '1' AND p = '0' THEN next_state <= s3_play_p;
        ELSE next_state <= s2_parado; END IF;
      WHEN s3_play_p => m <= '1'; d <= '1';
        IF s = '0' OR e = '1' THEN next_state <= s0_reb;
        ELSIF p = '0' THEN next_state <= s3_play_p;
        ELSE next_state <= s4_play; END IF;
      WHEN s4_play =>   m <= '1'; d <= '1';
        IF s = '0' OR e = '1' THEN next_state <= s0_reb;
        ELSIF p = '0' THEN next_state <= s5_pausa_p;
        ELSE next_state <= s4_play; END IF;
      WHEN s5_pausa_p => m <= '0'; d <= '0';
        IF s = '0' THEN next_state <= s0_reb;
        ELSIF p = '0' THEN next_state <= s5_pausa_p;
        ELSE next_state <= s6_pausa; END IF;
      WHEN s6_pausa =>  m <= '0'; d <= '0';
        IF s = '0' THEN next_state <= s0_reb;
        ELSIF p = '0' THEN next_state <= s3_play_p;
        ELSE next_state <= s6_pausa; END IF;
    END CASE;
  END PROCESS;
END ARCHITECTURE arch;

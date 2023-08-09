library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all;

entity logica is port ( 

    round, bonus: in std_logic_vector(3 downto 0);
	nivel: in std_logic_vector(1 downto 0);
	points: out std_logic_vector(7 downto 0) );
  
end logica;

architecture logica_comb of logica is

  signal round8, nivel8, bonus8, Lx32, Bdiv2, Xdiv4, Bdiv2_x4: std_logic_vector(7 downto 0) := "00000000";
  signal p: std_logic_vector(7 downto 0) := "00000000";
  
begin

  round8 <= "0000" & round;
  bonus8 <= "0000" & bonus;
  nivel8 <= "000000" & nivel;
  
  Lx32 <= nivel8(2 downto 0) & "00000";
  Bdiv2 <= "0" & bonus8(7 downto 1);
  Xdiv4 <= "00" & round8(7 downto 2);
  Bdiv2_x4 <= Bdiv2(5 downto 0) & "00";
  
  p <= Lx32 + Bdiv2_x4 + Xdiv4;
  
  points <= p;
  
  
end logica_comb;

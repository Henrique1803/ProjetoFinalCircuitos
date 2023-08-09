library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all;

entity subtracao is port ( 

    E0: in std_logic_vector(3 downto 0);
	E1: in std_logic;
	resultado: out std_logic_vector(3 downto 0) 

);
  
end subtracao;

architecture arc_subtracao of subtracao is
  
  signal sub: std_logic_vector(3 downto 0);
  
begin
    
    sub <= E0 - "0001";
    
    with E1 select 
      resultado <= E0 when '0', 
           sub when others;
  
  
end arc_subtracao;

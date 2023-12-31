library IEEE;
use IEEE.Std_Logic_1164.all;

entity mux2x1_7bits is port (
      E0, E1:  in std_logic_vector(6 downto 0);
      sel: in std_logic;
      saida: out std_logic_vector(6 downto 0) );
      
end mux2x1_7bits;

architecture mux of mux2x1_7bits is

begin 
  with sel select 
      saida <=E0 when '0', 
           E1 when others;
end mux;

library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all;

entity registrador_bonus is port ( 

    S, E, clock: in std_logic;
	D: in std_logic_vector(3 downto 0);
	Q: out std_logic_vector(3 downto 0)

);
  
end registrador_bonus;

architecture registrador of registrador_bonus is
  
begin
  
  process(clock, S)
  begin
    if (S = '1') then
			Q <= "1000";
    elsif (clock'event and clock = '1') then
        if (E = '1') then
            
            Q <= D;
			
		end if;
    end if;
  end process;
  
  
end registrador;

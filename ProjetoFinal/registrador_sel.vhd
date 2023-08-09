library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all;

entity registrador_sel is port ( 

    R, E, clock: in std_logic;
	D: in std_logic_vector(3 downto 0);
	Q: out std_logic_vector(3 downto 0) );
  
end registrador_sel;

architecture registrador of registrador_sel is
  
begin
  
  process(clock, R)
  begin
    if (R = '1') then
			Q <= "0000";
    elsif (clock'event and clock = '1') then
        if (E = '1') then
            
            Q <= D;
			
		end if;
    end if;
  end process;
  
  
end registrador;

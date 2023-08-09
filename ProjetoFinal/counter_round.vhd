library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all;

entity counter_round is port ( 

  R, E, clock: in std_logic;
  Q: out std_logic_vector(3 downto 0);
  tc: out std_logic );
  
end counter_round;

architecture counter of counter_round is

  signal cnt: std_logic_vector(3 downto 0) := "0000";
  
begin

  tc <= '1' when cnt = "1111" else '0';
  Q <= cnt;
  
  process(clock, R)
  begin
    if (R = '1') then
			cnt <= "0000";
    elsif (clock'event and clock = '1') then
        if (E = '1') then
        
			cnt <= cnt + "0001";
			if (cnt = "1111") then
			    cnt <= "0000";
			end if;
			
		end if;
    end if;
  end process;
  
  
end counter;

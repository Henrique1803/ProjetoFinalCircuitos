library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all;

entity counter_time is port ( 

  R, E, clock: in std_logic;
  Q: out std_logic_vector(3 downto 0);
  tc: out std_logic );
  
end counter_time;

architecture counter of counter_time is

  signal cnt: std_logic_vector(3 downto 0) := "1010";
  
begin

  tc <= '1' when cnt = "0000" else '0';
  Q <= cnt;
  
  process(clock, R)
  begin
    if (R = '1') then
			cnt <= "1010";
    elsif (clock'event and clock = '1') then
        if (E = '1') then
        
			cnt <= cnt - "0001";
			if (cnt = "0000") then
			    cnt <= "1010";
			end if;
		end if;
    end if;
  end process;
  
  
end counter;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM3a is
port(
	  address: in std_logic_vector(3 downto 0);
	  output : out std_logic_vector(14 downto 0)
);
end ROM3a;

architecture arc_ROM3a of ROM3a is
begin

--         switches 0 a 14
--         EDCBA9876543210                 round
output <= "000000001111110" when address = "0000" else --Round 0: 1, 2, 3, 4, 5, 6
		    "000011110000011" when address = "0001" else --Round 1: 0, 1, 7, 8, 9, A
			 "010110000101100" when address = "0010" else --Round 2: 2, 3, 5, A, B, D
			 "111110000000001" when address = "0011" else --Round 3: 0, A, B, C, D, E
			 "001010101010100" when address = "0100" else --Round 4: 2, 4, 6, 8, A, C
			 "001110000001110" when address = "0101" else --Round 5: 1, 2, 3, A, B, C
			 "110000011110000" when address = "0110" else --Round 6: 4, 5, 6, 7, D, E
			 "000011010101001" when address = "0111" else --Round 7: 0, 3, 5, 7 ,9, A
			 "000101010101010" when address = "1000" else --Round 8: 1, 3, 5, 7, 9, B
			 "111100011000000" when address = "1001" else --Round 9: 6, 7, B, C, D, E
			 "101001001001001" when address = "1010" else --Round 10: 0, 3, 6, 9, C, E
			 "011110000000110" when address = "1011" else --Round 11: 1, 2, A, B, C, D
			 "001001011001001" when address = "1100" else --Round 12: 0, 3, 6, 7, 9, C
			 "100110010110000" when address = "1101" else --Round 13: 4, 5, 7, A, B, E
			 "000001110101010" when address = "1110" else --Round 14: 1, 3, 5, 7, 8, 9
			 "111010000000011"; --Round 15: 0, 1, A, C, D, E
			 
end arc_ROM3a;
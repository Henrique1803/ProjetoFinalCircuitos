library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM1a is
port(
	  address: in std_logic_vector(3 downto 0);
	  output : out std_logic_vector(14 downto 0)
);
end ROM1a;

architecture arc_ROM1a of ROM1a is
begin

--         switches 0 a 14
--         EDCBA9876543210                 round
output <= "000000101001001" when address = "0000" else --Round 0: 0, 3, 6, 8
		    "100010010000100" when address = "0001" else --Round 1: 2, 7, A, E
			 "000110000010010" when address = "0010" else --Round 2: 1, 4, A, B
			 "011000100000100" when address = "0011" else --Round 3: 2, 8, C, D
			 "000000000011110" when address = "0100" else --Round 4: 1, 2, 3, 4
			 "100011000000001" when address = "0101" else --Round 5: 0, 9, A, E
			 "000001010101000" when address = "0110" else --Round 6: 3, 5, 7, 9
			 "100010000000011" when address = "0111" else --Round 7: 0, 1, A, E
			 "011010001000000" when address = "1000" else --Round 8: 6, A, C, D
			 "001001001001000" when address = "1001" else --Round 9: 3, 6, 9, C
			 "111010000000000" when address = "1010" else --Round 10: A, C, D, E
			 "000001100000110" when address = "1011" else --Round 11: 1, 2, 8, 9
			 "100001000101000" when address = "1100" else --Round 12: 3, 5, 9, E
			 "000111100000000" when address = "1101" else --Round 13: 8, 9, A, B
			 "011000010000001" when address = "1110" else --Round 14: 0, 7, C, D
			 "101001000000001"; --Round 15: 0, 9, C, E
			 
end arc_ROM1a;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM2a is
port(
	  address: in std_logic_vector(3 downto 0);
	  output : out std_logic_vector(14 downto 0)
);
end ROM2a;

architecture arc_ROM2a of ROM2a is
begin

--         switches 0 a 14
--         EDCBA9876543210                 round
output <= "000000000111110" when address = "0000" else --Round 0: 1, 2, 3, 4, 5
		    "000001001110001" when address = "0001" else --Round 1: 0, 4, 5, 6, 9
			 "000101110000100" when address = "0010" else --Round 2: 2, 7, 8, 9, B
			 "011011010000000" when address = "0011" else --Round 3: 7, 9, A, C, D
			 "100001000010101" when address = "0100" else --Round 4: 0, 2, 4, 9, E
			 "111110000000000" when address = "0101" else --Round 5: A, B, C, D, E
			 "101001100100000" when address = "0110" else --Round 6: 5, 8, 9, C, E
			 "000110000001110" when address = "0111" else --Round 7: 1, 2, 3, A, B
			 "000000101010101" when address = "1000" else --Round 8: 0, 2, 4, 6, 8
			 "001011010000001" when address = "1001" else --Round 9: 0, 7, 9, A, C
			 "110001000000110" when address = "1010" else --Round 10: 1, 2, 9, D, E
			 "010111100000000" when address = "1011" else --Round 11: 8, 9, A, B, D
			 "000001011100001" when address = "1100" else --Round 12: 0, 5, 6, 7, 9
			 "011110000001000" when address = "1101" else --Round 13: 3, A, B, C, D
			 "000001110000101" when address = "1110" else --Round 14: 0, 2, 7, 8, 9
			 "001100010001010"; --Round 15: 1, 3, 7, B, C
			 
end arc_ROM2a;
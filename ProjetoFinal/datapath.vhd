library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity datapath is
port(
	-- Entradas de dados
	clk: in std_logic;
	SW: in std_logic_vector(17 downto 0);
	
	-- Entradas de controle
	R1, R2, E1, E2, E3, E4, E5: in std_logic;
	
	-- Saídas de dados
	hex0, hex1, hex2, hex3, hex4, hex5, hex6, hex7: out std_logic_vector(6 downto 0);
	ledr: out std_logic_vector(15 downto 0);
	
	-- Saídas de status
	end_game, end_time, end_round, end_FPGA: out std_logic
);
end entity;

architecture arc of datapath is
---------------------------SIGNALS-----------------------------------------------------------
--contadores
signal tempo, X: std_logic_vector(3 downto 0);
--FSM_clock
signal CLK_1Hz, CLK_050Hz, CLK_033Hz, CLK_025Hz, CLK_020Hz: std_logic;
--Logica combinacional
signal RESULT: std_logic_vector(7 downto 0);
--Registradores
signal SEL: std_logic_vector(3 downto 0);
signal USER: std_logic_vector(14 downto 0);
signal Bonus, Bonus_reg: std_logic_vector(3 downto 0);
--ROMs
signal CODE_aux: std_logic_vector(14 downto 0);
signal CODE: std_logic_vector(31 downto 0);
--COMP
signal erro: std_logic;
--NOR enables displays
signal E23, E25, E12: std_logic;

--signals implícitos--

--dec termometrico
signal stermoround, stermobonus, andtermo: std_logic_vector(15 downto 0);
--decoders HEX 7-0
signal sdecod7, sdec7, sdecod6, sdec6, sdecod5, sdecod4, sdec4, sdecod3, sdecod2, sdec2, sdecod1, sdecod0, sdec0: std_logic_vector(6 downto 0);
signal smuxhex7, smuxhex6, smuxhex5, smuxhex4, smuxhex3, smuxhex2, smuxhex1, smuxhex0: std_logic_vector(6 downto 0);
signal edec2, edec0: std_logic_vector(3 downto 0);
--saida ROMs
signal srom0, srom1, srom2, srom3: std_logic_vector(31 downto 0);
signal srom0a, srom1a, srom2a, srom3a: std_logic_vector(14 downto 0);
--FSM_clock
signal E2orE3: std_logic;

---------------------------COMPONENTS-----------------------------------------------------------
component counter_time is 
port(
	R, E, clock: in std_logic;
	Q: out std_logic_vector(3 downto 0);
	tc: out std_logic
);
end component;

component counter_round is
port(
	R, E, clock: in std_logic;
	Q: out std_logic_vector(3 downto 0);
	tc: out std_logic
);
end component;

component decoder_termometrico is
 port(
	X: in  std_logic_vector(3 downto 0);
	S: out std_logic_vector(15 downto 0)
);
end component;

component FSM_clock_de2 is
port(
	reset, E: in std_logic;
	clock: in std_logic;
	CLK_1Hz, CLK_050Hz, CLK_033Hz, CLK_025Hz, CLK_020Hz: out std_logic
);
end component;

component FSM_clock_emu is
port(
	reset, E: in std_logic;
	clock: in std_logic;
	CLK_1Hz, CLK_050Hz, CLK_033Hz, CLK_025Hz, CLK_020Hz: out std_logic
);
end component;

component decod7seg is
port(
	C: in std_logic_vector(3 downto 0);
	F: out std_logic_vector(6 downto 0)
 );
end component;

component d_code is
port(
	C: in std_logic_vector(3 downto 0);
	F: out std_logic_vector(6 downto 0)
 );
end component;

component mux2x1_7bits is
port(
	E0, E1: in std_logic_vector(6 downto 0);
	sel: in std_logic;
	saida: out std_logic_vector(6 downto 0)
);
end component;

component mux2x1_16bits is
port(
	E0, E1: in std_logic_vector(15 downto 0);
	sel: in std_logic;
	saida: out std_logic_vector(15 downto 0)
);
end component;

component mux4x1_1bit is
port(
	E0, E1, E2, E3: in std_logic;
	sel: in std_logic_vector(1 downto 0);
	saida: out std_logic
);
end component;

component mux4x1_15bits is
port(
	E0, E1, E2, E3: in std_logic_vector(14 downto 0);
	sel: in std_logic_vector(1 downto 0);
	saida: out std_logic_vector(14 downto 0)
);
end component;

component mux4x1_32bits is
port(
	E0, E1, E2, E3: in std_logic_vector(31 downto 0);
	sel: in std_logic_vector(1 downto 0);
	saida: out std_logic_vector(31 downto 0)
);
end component;

component registrador_sel is 
port(
	R, E, clock: in std_logic;
	D: in std_logic_vector(3 downto 0);
	Q: out std_logic_vector(3 downto 0) 
);
end component;

component registrador_user is 
port(
	R, E, clock: in std_logic;
	D: in std_logic_vector(14 downto 0);
	Q: out std_logic_vector(14 downto 0) 
);
end component;

component registrador_bonus is 
port(
	S, E, clock: in std_logic;
	D: in std_logic_vector(3 downto 0);
	Q: out std_logic_vector(3 downto 0) 
);
end component;

component COMP_erro is
port(
	E0, E1: in std_logic_vector(14 downto 0);
	diferente: out std_logic
);
end component;

component COMP_end is
port(
	E0: in std_logic_vector(3 downto 0);
	endgame: out std_logic
);
end component;

component subtracao is
port(
	E0: in std_logic_vector(3 downto 0);
	E1: in std_logic;
	resultado: out std_logic_vector(3 downto 0)
);
end component;

component logica is 
port(
	round, bonus: in std_logic_vector(3 downto 0);
	nivel: in std_logic_vector(1 downto 0);
	points: out std_logic_vector(7 downto 0)
);
end component;

component ROM0 is
port(
	address: in std_logic_vector(3 downto 0);
	output : out std_logic_vector(31 downto 0)
);
end component;

component ROM1 is
port(
	address: in std_logic_vector(3 downto 0);
	output : out std_logic_vector(31 downto 0)
);
end component;

component ROM2 is
port(
	address: in std_logic_vector(3 downto 0);
	output : out std_logic_vector(31 downto 0)
);
end component;

component ROM3 is
port(
	address: in std_logic_vector(3 downto 0);
	output : out std_logic_vector(31 downto 0)
);
end component;

component ROM0a is
port(
	address: in std_logic_vector(3 downto 0);
	output : out std_logic_vector(14 downto 0)
);
end component;

component ROM1a is
port(
	address: in std_logic_vector(3 downto 0);
	output : out std_logic_vector(14 downto 0)
);
end component;

component ROM2a is
port(
	address: in std_logic_vector(3 downto 0);
	output : out std_logic_vector(14 downto 0)
);
end component;

component ROM3a is
port(
	address: in std_logic_vector(3 downto 0);
	output : out std_logic_vector(14 downto 0)
);
end component;

-- COMECO DO CODIGO ---------------------------------------------------------------------------------------

begin	

--Conexoes e atribuicoes a partir daqui. Dica: usar os mesmos nomes e I/O ja declarados nos components. Todos os signals necessarios ja estao declarados.
     
    -- counter time  
    ContaTempo: counter_time port map (R => R1,
                            E => E3,
                            clock => CLK_1Hz,
                            Q => tempo,
                            tc => end_time);
    -- fim counter time 
    
    -- counter round 
    ContaRound: counter_round port map (R => R2,
                            E => E4,
                            clock => clk,
                            Q => X,
                            tc => end_round);
    -- fim counter round 
    
    -- signals NOR
    E23 <= E2 NOR E3;
    E25 <= E2 NOR E5;
    E12 <= E1 NOR E2;
    -- fim signals NOR
    
    -- lógica combinacional      
    LogicaCombinacional: logica port map (round => X,
                            bonus => Bonus_reg,
                            nivel => SEL(1 downto 0),
                            points => RESUlT);
    -- fim lógica combinacional
    
    -- bloco que exibe bonus / rounds
    DecoderTermBonus: decoder_termometrico port map (X => Bonus_reg,
                            S => stermobonus);
    
    DecoderTermX: decoder_termometrico port map (X => X,
                            S => stermoround);
                            
    andtermo <= stermoround and (not (E1&E1&E1&E1&E1&E1&E1&E1&E1&E1&E1&E1&E1&E1&E1&E1));
    
    MuxDecoderTerm: mux2x1_16bits port map (E0 => andtermo,
                            E1 => stermobonus,
                            sel => SW(17),
                            saida => ledr);
    -- fim bloco que exibe bonus / rounds
    
    -- bloco hex7       
    d_codeHex7: d_code port map (C => CODE(31 downto 28),
                            F => sdecod7);
    
    decod7segHex7: decod7seg port map (C => RESULT(7 downto 4),
                            F => sdec7);
                            
    MuxHex7: mux2x1_7bits port map (E0 => sdecod7,
                            E1 => sdec7,
                            sel => E5,
                            saida => smuxhex7);
    
    hex7 <= smuxhex7 or (E25&E25&E25&E25&E25&E25&E25);
    -- fim bloco hex7   
    
    -- bloco hex6       
    d_codeHex6: d_code port map (C => CODE(27 downto 24),
                            F => sdecod6);
    
    decod7segHex6: decod7seg port map (C => RESULT(3 downto 0),
                            F => sdec6);
                            
    MuxHex6: mux2x1_7bits port map (E0 => sdecod6,
                            E1 => sdec6,
                            sel => E5,
                            saida => smuxhex6);
    
    hex6 <= smuxhex6 or (E25&E25&E25&E25&E25&E25&E25);
    -- fim bloco hex6 
    
    -- bloco hex5      
    d_codeHex5: d_code port map (C => CODE(23 downto 20),
                            F => sdecod5);
                            
    MuxHex5: mux2x1_7bits port map (E0 => sdecod5,
                            E1 => "0000111",
                            sel => E3,
                            saida => smuxhex5);
    
    hex5 <= smuxhex5 or (E23&E23&E23&E23&E23&E23&E23);
    -- fim bloco hex5
    
    -- bloco hex4       
    d_codeHex4: d_code port map (C => CODE(19 downto 16),
                            F => sdecod4);
    
    decod7segHex4: decod7seg port map (C => tempo,
                            F => sdec4);
                            
    MuxHex4: mux2x1_7bits port map (E0 => sdecod4,
                            E1 => sdec4,
                            sel => E3,
                            saida => smuxhex4);
    
    hex4 <= smuxhex4 or (E23&E23&E23&E23&E23&E23&E23);
    -- fim bloco hex4
    
    -- bloco hex3   
    d_codeHex3: d_code port map (C => CODE(15 downto 12),
                            F => sdecod3);
                            
    MuxHex3: mux2x1_7bits port map (E0 => sdecod3,
                            E1 => "1000110",
                            sel => E1,
                            saida => smuxhex3);
    
    hex3 <= smuxhex3 or (E12&E12&E12&E12&E12&E12&E12);
    -- fim bloco hex3

    -- bloco hex2      
    d_codeHex2: d_code port map (C => CODE(11 downto 8),
                            F => sdecod2);
                            
    edec2 <= "00"&sel(3 downto 2);
    
    decod7segHex2: decod7seg port map (C => edec2,
                            F => sdec2);
                            
    MuxHex2: mux2x1_7bits port map (E0 => sdecod2,
                            E1 => sdec2,
                            sel => E1,
                            saida => smuxhex2);
    
    hex2 <= smuxhex2 or (E12&E12&E12&E12&E12&E12&E12);
    -- fim bloco hex2

    -- bloco hex1  
    d_codeHex1: d_code port map (C => CODE(7 downto 4),
                            F => sdecod1);
                            
    MuxHex1: mux2x1_7bits port map (E0 => sdecod1,
                            E1 => "1000111",
                            sel => E1,
                            saida => smuxhex1);
    
    hex1 <= smuxhex1 or (E12&E12&E12&E12&E12&E12&E12);
    -- fim bloco hex1
    
    -- bloco hex0      
    d_codeHex0: d_code port map (C => CODE(3 downto 0),
                            F => sdecod0);
                            
    edec0 <= "00"&sel(1 downto 0);
    
    decod7segHex0: decod7seg port map (C => edec0,
                            F => sdec0);
                            
    MuxHex0: mux2x1_7bits port map (E0 => sdecod0,
                            E1 => sdec0,
                            sel => E1,
                            saida => smuxhex0);
    
    hex0 <= smuxhex0 or (E12&E12&E12&E12&E12&E12&E12);
    -- fim bloco hex0
    
    -- bloco compara usuario com memória
    CompIgualdade: COMP_erro port map (E0 => CODE_aux,
                            E1 => USER,
                            diferente => erro);
    -- fim bloco compara usuario com memória
    
    -- bloco registrador user
    RegistrUser: registrador_user port map (R => R2,
                            E => E3,
                            clock => clk,
                            D => SW(14 downto 0),
                            Q => USER);
    -- fim bloco registrador user
    
    -- bloco contador/ subtrator de vidas
    Subtr: subtracao port map (E0 => Bonus_reg,
                            E1 => erro,
                            resultado => Bonus);
                            
    RegistrBonus: registrador_bonus port map (S => R2,
                            E => E4,
                            clock => clk,
                            D => Bonus,
                            Q => Bonus_reg);
    
    CompA0: COMP_end port map (E0 => Bonus_reg,
                            endgame => end_game);
    -- fim bloco contador/ subtrator de vidas

    -- bloco controle de memória/level/code
    E2orE3 <= E2 or E3;
    
    FSM_clock1: FSM_clock_emu port map (reset => R1,
                            E => E2orE3,
                            clock => clk,
                            CLK_1Hz => CLK_1Hz,
                            CLK_050Hz => CLK_050Hz,
                            CLK_033Hz => CLK_033Hz,
                            CLK_025Hz => CLK_025Hz,
                            CLK_020Hz => CLK_020Hz);
    MuxFSMClock: mux4x1_1bit port map (E0 => CLK_020Hz,
                            E1 => CLK_025Hz,
                            E2 => CLK_033Hz,
                            E3 => CLK_050Hz,
                            sel => sel(1 downto 0),
                            saida => end_FPGA);
                            
    RegistrSel: registrador_sel port map (R => R2,
                            E => E1,
                            clock => clk,
                            D => SW(3 downto 0),
                            Q => sel);
    
    MEM0: ROM0 port map (address => X,
                            output => srom0);
    
    MEM1: ROM1 port map (address => X,
                            output => srom1);
                            
    MEM2: ROM2 port map (address => X,
                            output => srom2);
                            
    MEM3: ROM3 port map (address => X,
                            output => srom3);
                            
    MEM0a: ROM0a port map (address => X,
                            output => srom0a);
    
    MEM1a: ROM1a port map (address => X,
                            output => srom1a);
                            
    MEM2a: ROM2a port map (address => X,
                            output => srom2a);
                            
    MEM3a: ROM3a port map (address => X,
                            output => srom3a);
                            
    MuxCODE: mux4x1_32bits port map (E0 => srom0,
                            E1 => srom1,
                            E2 => srom2,
                            E3 => srom3,
                            sel => sel(3 downto 2),
                            saida => CODE);
                            
    MuxCODE_aux: mux4x1_15bits port map (E0 => srom0a,
                            E1 => srom1a,
                            E2 => srom2a,
                            E3 => srom3a,
                            sel => sel(3 downto 2),
                            saida => CODE_aux);
    -- fim bloco controle de memória/level/code


end arc;
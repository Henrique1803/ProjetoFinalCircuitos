library ieee;
use ieee.std_logic_1164.all;

entity controle is port (

    -- Entradas de controle
	enter, reset, CLOCK: in std_logic;
    -- Entradas de status
	end_game, end_time, end_round, end_FPGA: in std_logic;
    -- Saídas de comandos
	R1, R2, E1, E2, E3, E4, E5: out std_logic
	
   );
end controle;

architecture arc_control of controle is

  type STATES is (Init, Setup, Play_FPGA, Play_user, Count_Round, Check, Result, WaitS);
  signal EAtual, PEstado: STATES;
  
begin

  process(CLOCK, reset)
  begin
    if (reset = '1') then
	  EAtual <= Init;
	elsif (CLOCK'event AND CLOCK = '1') then 
  	  EAtual <= PEstado;
	end if;
  end process;
  
  process(EAtual, enter, end_game, end_time, end_round, end_FPGA)
  begin
    case EAtual is
    
      when Init =>
        R1 <= '1';
        R2 <= '1';
        E1 <= '0';
        E2 <= '0';
        E3 <= '0';
        E4 <= '0';
        E5 <= '0';
        PEstado <= Setup;
		
	  when Setup => 
	    R1 <= '0';
        R2 <= '0';
		E1 <= '1';
		E2 <= '0';
        E3 <= '0';
        E4 <= '0';
        E5 <= '0';
		if (enter = '1') then
		    PEstado <= Play_FPGA;
		else
            PEstado <= Setup;
		end if;
		
	  when Play_FPGA =>
	    R1 <= '0';
        R2 <= '0';
        E1 <= '0';
        E2 <= '1';
        E3 <= '0';
        E4 <= '0';
        E5 <= '0';
        if (end_FPGA = '1') then
		    PEstado <= Play_user;
		else
            PEstado <= Play_FPGA;
		end if;
		
	  when Play_user =>
	    R1 <= '0';
        R2 <= '0';
	    E1 <= '0';
        E2 <= '0';
        E3 <= '1';
        E4 <= '0';
        E5 <= '0';
        if (end_time = '1') then
		    PEstado <= Result;
		else
            if (enter = '1') then
		       PEstado <= Count_Round;
    		else
               PEstado <= Play_user;
    		end if;
		end if;
		
	  when Count_Round =>
	    R1 <= '0';
        R2 <= '0';
	    E1 <= '0';
        E2 <= '0';
	    E3 <= '0';
		E4 <= '1';
		E5 <= '0';
		PEstado <= Check;
		
	  when Check =>
	    R1 <= '0';
        R2 <= '0';
        E1 <= '0';
        E2 <= '0';
	    E3 <= '0';
		E4 <= '0';
		E5 <= '0';
        if (end_game = '1' or end_round = '1') then
		    PEstado <= Result;
		else
            PEstado <= WaitS;
		end if;
		
	  when WaitS =>
        R1 <= '1';
        R2 <= '0';
        E1 <= '0';
        E2 <= '0';
	    E3 <= '0';
		E4 <= '0';
		E5 <= '0';
        if (enter = '1') then
		    PEstado <= Play_FPGA;
		else
            PEstado <= WaitS;
		end if;
	  
	  when Result =>
	    R1 <= '0';
        R2 <= '0';
	    E1 <= '0';
        E2 <= '0';
        E3 <= '0';
        E4 <= '0';
	    E5 <= '1';
	    if (enter = '1') then
		    PEstado <= Init;
		end if;
		
    end case;
  end process;
  
end arc_control;

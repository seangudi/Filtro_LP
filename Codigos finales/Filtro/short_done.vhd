-- Recibe un done tick largo y da como output un done tick de 1 clk
-- funciona como FSM ipo moore
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity short_done is
port(
	clk,reset	: in std_logic;
	done			: in std_logic;
	s_done		: out std_logic
);
end short_done;

architecture Behavioral of short_done is
type state_type is (idle, doneRise, waiting);
signal state_reg, state_next : state_type ;

begin

-- registro de estado 
	process(clk,reset)
	begin
		if( reset='1') then
			state_reg <= idle ; 
		elsif(clk'event and clk='1') then
			state_reg <= state_next ;
		end if;
	end process;
	
--=================== NEXT STATE LOGIC =========================

process(state_reg,done)
begin
	state_next <= state_reg ; -- por dafault 
	case state_reg is
		when idle =>
			if(done='1') then
				state_next <= doneRise ; 
			end if;
			
		when doneRise =>
			state_next <= waiting ; 
		
		when waiting =>
			if(done='0') then
				state_next <= idle ; 
			end if;		
	end case;
end process;

--=================== OUTPUT  LOGIC =========================
process(state_reg)
begin
	s_done <= '0' ; -- por dafault 
	case state_reg is
		when idle =>
			
		when doneRise =>
			s_done <= '1' ; 
		
		when waiting =>
	
	end case;
end process;


end Behavioral;


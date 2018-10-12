-- Concatena una muestra de entrada (de 8 bits) en la posicion mas significativa (izq) de un array de muestras
-- y elimina la muestra menos significativa (derecha)
-- Funciona como FSM tipo MOORE
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.filtro_pkg.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fifo_shift is
port(
	clk,reset:	in std_logic;
	new_tick:	in std_logic;
	new_samp:	in std_logic_vector(Bits_x_t-1 downto 0) ; -- Bits_x_t = 8 
	v:				in x_t(N_coef-1 downto 0) ; -- N_coef = numero de coefs = numero de muestras
	v_out:		out x_t(N_coef-1 downto 0) ;
	v_tick:		out std_logic
);
end fifo_shift;

architecture Behavioral of fifo_shift is
type state_type is(idle, shifting, done) ; 
signal state_reg, state_next : state_type ; 
signal v_reg, v_next : x_t(N_coef-1 downto 0) ; 

begin
-- registro 
	process(clk,reset)
	begin 
		if(reset = '1')then
			state_reg	<= idle ; 
			v_reg			<= (others=>(others=>'0')) ; -- pongo todo en ceros
		elsif(rising_edge(clk)) then
			state_reg	<= state_next ; 
			v_reg			<= v_next ; 
		end if;
	end process;
	
	
-- ===================== NEST STATE LOGIC =======================
 
	process(state_reg, v, new_samp, new_tick)
	begin
		state_next <= state_reg ; -- default
		v_next	  <= v_reg ; 
		case state_reg is
			when idle => 
				if(new_tick='1') then
					state_next	<= shifting ; 
				end if;
			
			when shifting =>
				state_next	<= done ; 
				v_next		<= new_samp & v(N_coef-1 downto 1) ;
				
			when done => 
				state_next <= idle ; 
		end case;
	end process;
	

-- ===================== OUTPUT LOGIC =======================

	process(state_reg, v_reg)
	begin
		-- default
		v_tick	<= '0' ;
		v_out  <= v_reg ; 
		case state_reg is
			when done => 
				v_tick <= '1' ; 
			
			when others => 
		end case ; 
	end process;
	 

end Behavioral;


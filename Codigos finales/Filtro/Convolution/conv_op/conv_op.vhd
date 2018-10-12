
-- Realiza la multiplicacion de las muestras por los coeficientes y la suma. NO TIENE EL SHIFT incorporado
-- Funciona con FSM tipo MOORE
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.filtro_pkg.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity conv_op is
port(
	clk,reset:	in std_logic;
	v_tick:		in std_logic;
	v:				in x_t(N_coef-1 downto 0);  -- vector de muestras
	y_tick:		out std_logic ; 
	y:				out std_logic_vector((Bits_x_t + Bits_cte_t-1)-1 downto 0)  --31 bits 
);
end conv_op;

 architecture Behavioral of conv_op is
type state_type is( idle, op, done) ;
signal state_reg, state_next: state_type; 
-- señales de 1 o 0 auxiliares para concatenar a las constantes
signal zeros, ones : std_logic_vector(Bits_x_t downto 0) ; -- 9 bits 
-- coeficiente y muestra extendidas
signal c_ext_reg, c_ext_next, x_ext_reg, x_ext_next: std_logic_vector((Bits_cte_t + Bits_x_t)-1 downto 0) ; 
-- resutado de una mutiplicacion ( doble de largo de bits ) 
signal  p_reg, p_next : signed(2*(c_ext_reg'length)-1 downto 0) ;
-- contador para las diferentes operaciones
signal n_reg, n_next : integer ; 



begin
	zeros <= (others=>'0') ; 
	ones	<= (others=>'1') ; 
-- registro 
	process(clk,reset)
	begin 
		if(reset = '1')then
			state_reg	<= idle ;
			p_reg			<= to_signed(0,p_reg'length) ;	
			n_reg			<= 0 ;
			c_ext_reg	<= (others=>'0'); 
			x_ext_reg	<= (others=>'0');
		elsif(rising_edge(clk)) then
			state_reg	<= state_next ;
			p_reg			<= p_next ;
			n_reg			<= n_next ;
			c_ext_reg	<= c_ext_next ; 
			x_ext_reg	<= x_ext_next ; 
		end if;
	end process;
	
	
-- ===================== NEXT STATE LOGIC =======================
 
	process(state_reg, p_reg, n_reg, v,  v_tick, c_ext_reg, x_ext_reg, zeros, ones )
	begin
	
		state_next	<= state_reg ; -- default
		p_next		<= p_reg ;  	
		n_next		<= n_reg ; 
		c_ext_next	<= c_ext_reg ;
		x_ext_next	<= x_ext_reg ; 
		
		
		
		case state_reg is
			when idle => 
				if(v_tick='1') then
					state_next	<= op ; 
					n_next		<= 0 ; 
					p_next		<= (others=>'0');
				end if;
			
			when op =>
				if(n_reg = (N_coef+1)) then 
					state_next	<= done ;									
				else
				
				
				if(n_reg<=N_coef-1) then
					x_ext_next	<= '0' & v(N_coef-1-n_reg) & std_logic_vector(to_unsigned(0,Bits_cte_t-1)) ; -- muestra extendida	
					-- extiendo c
					if(coefs(n_reg)(Bits_cte_t-1) = '0')then
						c_ext_next <= zeros & coefs(n_reg)(Bits_cte_t-2 downto 0) ; 
					else
						c_ext_next <= ones & coefs(n_reg)(Bits_cte_t-2 downto 0) ;
					end if;
				end if;
				
				-- multiplicacion y suma 
					p_next	<= p_reg + (signed(c_ext_reg) * signed(x_ext_reg)) ;
				-- incremento el contador 
					n_next <= n_reg + 1 ; 
									
				end if; 
								
			when done => 
				state_next <= idle ; 
		end case;
	end process;
	

-- ===================== OUTPUT LOGIC =======================

	process(state_reg, p_reg)
	begin
	-- default
		y_tick	<= '0' ; 
		y			<= std_logic_vector(p_reg( ( 2*(Bits_cte_t-1) + Bits_x_t-1 )  downto (Bits_cte_t-1) )) ;
		
		case state_reg is
			when done => 
				y_tick 	<= '1';		
			when others => 
				
		end case ; 
	end process;

end Behavioral;


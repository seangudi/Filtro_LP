-- Convolucion top. 
-- recibe una nueva muestra, un nuevo tick y da como salida la informacion del sonido filtrada 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.filtro_pkg.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity convolution is
port(
	clk,reset:	in std_logic;
	new_tick:	in std_logic;
	new_samp:	in std_logic_vector(Bits_x_t-1 downto 0) ;
	y_tick:		out std_logic ; 
	y:				out std_logic_vector((Bits_x_t + Bits_cte_t-1)-1 downto 0)  --31 bits 
);
end convolution;

architecture Behavioral of convolution is
signal v_aux : x_t(N_coef-1 downto 0)  ; -- retroalimentacion del fifo_shift y fifo_shift-> conv_op ; 
signal v_tick_aux : std_logic ; -- fifo_shift -> conv_op

begin
-- ========== fifo_shift ========
	fifo_shift: entity work.fifo_shift(Behavioral)
	port map(clk=>clk, reset=>reset, new_tick=>new_tick, new_samp=>new_samp, v=>v_aux, v_out=>v_aux, v_tick=>v_tick_aux)  ;
	
-- ====== conv_op ===============
	conv_op: entity work.conv_op(Behavioral)
	port map(clk=>clk, reset=>reset, v_tick=>v_tick_aux, v=>v_aux, y_tick=>y_tick, y=>y);

 end Behavioral;


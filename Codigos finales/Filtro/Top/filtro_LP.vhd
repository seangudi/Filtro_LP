-- modulo top del filtro pasa bajos con frecuencia de corte a 3 kHz
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.filtro_pkg.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity filtro_LP is
port(
	clk,reset	: in std_logic ; 
	-- PmodMicRefComp
	sdata 		: in std_logic ; -- la info del microfono 
   sclk     	: out std_logic; -- va al adc
   ncs         : out std_logic; -- selecciona cual mic uso
	-- UART
	tx,tx_full	: out std_logic 
);
end filtro_LP;

architecture Behavioral of filtro_LP is
signal up_aux : std_logic;												-- long_clk_20kHz -> pModMic
signal done_aux : std_logic; 											-- pModMic -> short_done

signal s_done_conv : std_logic;										-- short_done -> CONVOLUTION
signal data_conv : std_logic_vector(11 downto 0 ) ; 			-- MIC -> CONVOLUTION

signal s_done_aux : std_logic;										--  CONVOUTION -> UART
signal data_aux: std_logic_vector(Bits_x_t + (Bits_cte_t-1) -1 downto 0) ; 	-- CONVOLUTION -> UART 

begin

-- =================== clk de 9 clk's a 20 kHz ===========
	long_clk_20kHz: entity work.long_clk_20kHz(Behavioral)
	port map(clk=>clk, reset=>reset, up => up_aux );

-- =================== short done ======================== recorta el done largo del pModMic a un tick de 1 clk
	short_done: entity work.short_done(Behavioral)
	port map(clk=>clk, reset=>reset, done=>done_aux, s_done=>s_done_conv);

-- =================== UART ========================
	uart_tx_unit: entity work.uart_tx_unit(Behavioral)
	--  
	port map(clk=>clk, reset=>reset, wr_uart=>s_done_aux, w_data=>data_aux(Bits_x_t + (Bits_cte_t-1) -1 downto Bits_x_t + (Bits_cte_t-1) -8), tx=>tx, tx_full=>tx_full) ; 

-- =================== Microfono =====================
	PmodMicRefComp:entity work.PmodMicRefComp(PmodMic)
	port map(clk=>clk, rst=>reset, sdata=>sdata, start=>up_aux, sclk=>sclk, ncs=>ncs, data=>data_conv, done=>done_aux);

-- ================= CONVOLUTION ====================
convolution: entity work.convolution(Behavioral)
port map(clk=>clk, reset=>reset, new_tick=>s_done_conv, new_samp=>data_conv(11 downto 4), y_tick=>s_done_aux, y=>data_aux ) ;

end Behavioral;


-- Modulo top que transmite el sonido recibido por un microfono a traves de la UART 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_sound is
port(
	clk,reset	: in std_logic ; 
	-- PmodMicRefComp
	sdata 		: in std_logic ; -- la info del microfono 
   sclk     	: out std_logic; -- va al adc
   ncs         : out std_logic; -- selecciona cual mic uso
	-- UART
	tx,tx_full	: out std_logic 
);
end top_sound;

architecture Behavioral of top_sound is
signal up_aux : std_logic; -- long_clk_20kHz -> pModMic
signal done_aux : std_logic; --  pModMic -> short_done
signal s_done_aux : std_logic; --  short_done -> UART
signal data_aux: std_logic_vector(11 downto 0) ; -- MIC -> UART 


begin

-- =================== clk de 9 clk's a 20 kHz ===========
	long_clk_20kHz: entity work.long_clk_20kHz(Behavioral)
	port map(clk=>clk, reset=>reset, up => up_aux );

-- =================== short done ======================== recorta el done largo del pModMic a un tick de 1 clk
	short_done: entity work.short_done(Behavioral)
	port map(clk=>clk, reset=>reset, done=>done_aux, s_done=>s_done_aux);

-- =================== UART ========================
	uart_tx_unit: entity work.uart_tx_unit(Behavioral)
	--  
	port map(clk=>clk, reset=>reset, wr_uart=>s_done_aux, w_data=>data_aux(11 downto 4), tx=>tx, tx_full=>tx_full) ; 

-- =================== Microfono =====================
	PmodMicRefComp:entity work.PmodMicRefComp(PmodMic)
	port map(clk=>clk, rst=>reset, sdata=>sdata, start=>up_aux, sclk=>sclk, ncs=>ncs, data=>data_aux, done=>done_aux);

end Behavioral;




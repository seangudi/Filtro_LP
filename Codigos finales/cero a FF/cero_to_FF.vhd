
-- Manda a traves de la UART un contador de 0 -> FF a 20 kHz
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cero_to_FF is
port(
	clk,reset:	 in std_logic ; 
	tx, tx_full: out std_logic
	);
end cero_to_FF;

architecture Behavioral of cero_to_FF is
signal up_aux : std_logic ; 
signal num_aux: std_logic_vector(7 downto 0) ; 

begin

	contador_20kHz: entity work.contador_20kHz(Behavioral)
	port map(clk=>clk, reset=>reset, up=>up_aux, num=>num_aux) ; 
	
	uart_tx_unit: entity work.uart_tx_unit(behavioral)
	port map(clk=>clk, reset=>reset, wr_uart=>up_aux, w_data=>num_aux, tx=>tx, tx_full=>tx_full) ; 

end Behavioral;



----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity long_clk_20kHz is
port(
	clk,reset:	in std_logic;
	up:			out std_logic
);
end long_clk_20kHz;

architecture Behavioral of long_clk_20kHz is
signal c_reg, c_next			: unsigned(12 downto 0 ) ; -- 13 bits para contar hasta 5000 clk's (20 kHz)
signal up_reg, up_next		: std_logic ; 

begin
-- registro de estado 
	process(clk,reset)
	begin
		if( reset='1') then
			c_reg		<= to_unsigned(0,c_reg'length) ;
			up_reg	<= '0' ;  
		elsif(clk'event and clk='1') then
			c_reg		<= c_next ; 
			up_reg	<= up_next ;
		end if;
	end process;
	
-- ================== NEXT STATE LOGIC ===================	
	c_next	<= to_unsigned(0,c_next'length) when(c_reg = to_unsigned(5000,c_reg'length)) else
					c_reg + 1 ; 
					
	up_next	<= '0' when(c_reg >= to_unsigned(9,c_reg'length)) else
					'1' ; 


-- ================== OUTPUT LOGIC ===================	
	up <= up_reg ; 


end Behavioral;


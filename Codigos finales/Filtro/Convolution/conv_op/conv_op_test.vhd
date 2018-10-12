
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use work.filtro_pkg.ALL;
 
ENTITY conv_op_test IS
END conv_op_test;
 
ARCHITECTURE behavior OF conv_op_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT conv_op
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         v_tick : IN  std_logic;
         v : IN  x_t(N_coef-1 downto 0);
         y_tick : OUT  std_logic;
         y : OUT std_logic_vector((Bits_x_t + Bits_cte_t-1)-1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal v_tick : std_logic := '0';
   signal v : x_t(N_coef-1 downto 0) := (others => (others => '0'));

 	--Outputs
   signal y_tick : std_logic;
   signal y : std_logic_vector((Bits_x_t + Bits_cte_t-1)-1 downto 0);
	
	-- Auxiliar 
	signal aux : std_logic_vector((Bits_x_t + Bits_cte_t-1)-1 downto 0) := (others => '0') ; 

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: conv_op PORT MAP (
          clk => clk,
          reset => reset,
          v_tick => v_tick,
          v => v,
          y_tick => y_tick,
          y => y
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
		reset <= '1' ; 
		wait for 15 ns ; 
		reset <= '0' ; 
		assert(y_tick = '0' ) report "---------- NO RESETEA Y_TICK ----------" severity failure;
		assert(y = aux) report "------ NO RESETEA SALIDA Y -----------" severity failure ; 
		
		-- creo vector de array de con "1" en alguna posicion y veo si a la salida se obtiene el correspondiente coeficiente
		for k in 0 to N_coef-1 loop
			if(k=N_coef-1-3)then 
				v(k) <= std_logic_vector(to_signed(1,Bits_x_t)) ;
			else
				v(k) <= std_logic_vector(to_signed(0,Bits_x_t)) ;
			end if;
		end loop;

		
		-- Hasta aca no ha pasado ningun clk 
		
		v_tick <= '1' ; 
		
	wait for	clk_period; -- pasamos a op	
		v_tick <= '0';
		-- para completar todas las multipliciones-sumas  y llegar al done (N_coef+2) clk's
		wait for (N_coef+4)*clk_period ; 
		
		
		assert false report "----- EXITO ----------" severity failure ; 
   end process;

END;

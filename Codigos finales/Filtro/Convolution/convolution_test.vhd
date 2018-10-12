-- da como entrada un impulso unitario y checkea que a la salida se tengan los coeficientes del filtro 
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use work.filtro_pkg.ALL;
 
ENTITY convolution_test IS
END convolution_test;
 
ARCHITECTURE behavior OF convolution_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT convolution
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         new_tick : IN  std_logic;
         new_samp : IN  std_logic_vector(Bits_x_t-1 downto 0);
         y_tick : OUT  std_logic;
         y : OUT  std_logic_vector((Bits_x_t + Bits_cte_t-1)-1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal new_tick : std_logic := '0';
   signal new_samp : std_logic_vector(Bits_x_t-1 downto 0) := (others => '0');

 	--Outputs
   signal y_tick : std_logic;
   signal y : std_logic_vector((Bits_x_t + Bits_cte_t-1)-1 downto 0);
	
	-- auxiliar
	signal aux: std_logic_vector((Bits_x_t + Bits_cte_t-1)-1 downto 0) := (others=>'0') ;
   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: convolution PORT MAP (
          clk => clk,
          reset => reset,
          new_tick => new_tick,
          new_samp => new_samp,
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
		-- reset 
		reset <= '1' ; 
		wait for 15 ns;
		reset <= '0' ; 
		
		assert(y = aux) report "------- NO RESETEA LA SALIDA Y ------------ " severity failure ; 
		assert(y_tick = '0') report "--------- no reseta y_tick ----------" severity failure ; 
		
		
		for k in 0 to (N_coef-1) loop 
		
			if (k=0) then
				new_samp <= std_logic_vector(to_unsigned(1,new_samp'length)) ; 
			else
				new_samp <= std_logic_vector(to_unsigned(0,new_samp'length)) ; 
			end if;
			
			new_tick <= '1' ; 
			wait for clk_period ;
			new_tick <= '0' ;
			wait until rising_edge(y_tick) ; 
			
			assert(y(Bits_cte_t-1 downto 0) = coefs(k)) report "---- NO SALE COEF " &integer'image(k)& "-------" severity failure ; 
			wait for 2*clk_period; -- le damos un poco de calma a la vida
			
		end loop ; 

	assert false report "------ EXITO -------- " severity failure ; 
	
   end process;

END;

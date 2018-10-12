
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
use work.filtro_pkg.ALL;
 
ENTITY fifo_shit_test IS
END fifo_shit_test;
 
ARCHITECTURE behavior OF fifo_shit_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT fifo_shift
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         new_tick : IN  std_logic;
         new_samp : IN  std_logic_vector(Bits_x_t-1 downto 0);
         v : IN  x_t(N_coef-1 downto 0) ;
         v_out : OUT  x_t(N_coef-1 downto 0) ;
         v_tick : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal new_tick : std_logic := '0';
   signal new_samp : std_logic_vector(7 downto 0) := (others => '0');
   signal v : x_t(N_coef-1 downto 0) := (others => (others => '0'));

 	--Outputs
   signal v_out : x_t(N_coef-1 downto 0) ;
   signal v_tick : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	
	-- AUXILIARES
	signal aux : x_t(N_coef-1 downto 0) := (others => (others => '0')) ; 
	signal aux_up : x_t(N_coef-1 downto 0) := (others => (others => '0')) ; 
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: fifo_shift PORT MAP (
          clk => clk,
          reset => reset,
          new_tick => new_tick,
          new_samp => new_samp,
          v => v,
          v_out => v_out,
          v_tick => v_tick
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
		
		assert(v_out = aux) report "------- NO RESETA V_OUT ------" severity failure ; 
		assert(v_tick = '0') report "-------------- NO RESETEAL EL V_TICK ----------" severity failure ; 
		wait until rising_edge(clk) ; 
		
		for k in 1 to ((N_coef-1)*3/2) loop 
			v <= v_out ;  
			new_samp <= std_logic_vector(to_unsigned(k,Bits_x_t)) ;
			aux_up <= std_logic_vector(to_unsigned(k,Bits_x_t)) & aux(N_coef-1 downto 1) ; 
			new_tick <= '1' ; 
			wait for clk_period ; -- tiempo para llegar al shifting 
			aux <= aux_up ; 
			new_tick <= '0' ;
			wait for clk_period*1.5; -- tiempo para llegar al done
			assert(v_out = aux) report "------- NO SHIFTEA BIEN ------" severity failure ; 
			assert(v_tick = '1') report "-------------- NO LEVANTA EL V_TICK ----------" severity failure ;	
			wait for clk_period*0.5; -- tiempo para volver a idle
			
		end loop ;
	
		assert false report "-------- EXITO --------" severity failure ; 
		
   end process;

END;

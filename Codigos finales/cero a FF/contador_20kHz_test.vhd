
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY contador_20kHz_test IS
END contador_20kHz_test;
 
ARCHITECTURE behavior OF contador_20kHz_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT contador_20kHz
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         up : OUT  std_logic;
         num : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal up : std_logic;
   signal num : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: contador_20kHz PORT MAP (
          clk => clk,
          reset => reset,
          up => up,
          num => num
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
		
		for k in 0 to 256 loop
			wait for 5000*clk_period ; 
			assert (num = std_logic_vector(to_unsigned(k,num'length))) report "---- NO CUENTA BIEN ----" severity failure ; 
			
		end loop ;
		
		assert false report "-- EXITO ---" severity failure ; 
		
   end process;

END;

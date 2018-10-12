
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY long_clk_20kHz_test IS
END long_clk_20kHz_test;
 
ARCHITECTURE behavior OF long_clk_20kHz_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT long_clk_20kHz
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         up : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';

 	--Outputs
   signal up : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: long_clk_20kHz PORT MAP (
          clk => clk,
          reset => reset,
          up => up
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
			--assert (num = std_logic_vector(to_unsigned(k,num'length))) report "---- NO CUENTA BIEN ----" severity failure ; 		
		end loop ;
		
		assert false report "-- EXITO ---" severity failure ; 
   end process;


END;

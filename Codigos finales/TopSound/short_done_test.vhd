
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY short_done_test IS
END short_done_test;
 
ARCHITECTURE behavior OF short_done_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT short_done
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         done : IN  std_logic;
         s_done : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   signal done : std_logic := '0';

 	--Outputs
   signal s_done : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: short_done PORT MAP (
          clk => clk,
          reset => reset,
          done => done,
          s_done => s_done
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
	
	for k in 0 to 10 loop 
		done <= '1' ; 
		wait for 10*clk_period;
		done <= '0' ; 
		wait for 10*clk_period;
	end loop ; 
	
	assert false report "EXITO" severity failure ; 
	
	
   end process;

END;

-- =========================================================00


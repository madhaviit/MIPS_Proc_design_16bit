LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY tb_MIPS_VHDL IS
END tb_MIPS_VHDL;
 
ARCHITECTURE behavior OF tb_MIPS_VHDL IS 
    -- Component Declaration for the single-cycle MIPS Processor in VHDL
    COMPONENT MIPS_VHDL
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         pc_out : OUT  std_logic_vector(7 downto 0);
         alu_result : OUT  std_logic_vector(7 downto 0)
			
--			--additional signals
-- load_data: in std_logic_vector(7 downto 0);
-- load_data_valid: in std_logic;
-- load_addr: out std_logic_vector(2 downto 0);
-- load_addr_valid: out std_logic;
-- instruction_available : in std_logic;
-- next_instruction: out std_logic_vector(3 downto 0); --as size of rom decided by us
-- next_instruction_addr: in std_logic_vector(15 downto 0);
--  pipeline_empty: out std_logic;
-- instruction_valid: in std_logic;
-- writeback_data: out std_logic_vector(7 downto 0);
-- writeback_adddr: out std_logic_vector(7 downto 0);
-- writeback_valid: out std_logic
        );
    END COMPONENT;
   --Inputs
   signal clk : std_logic := '0';
   signal reset : std_logic := '0';
   --Outputs
   signal pc_out : std_logic_vector(7 downto 0);
   signal alu_result : std_logic_vector(7 downto 0);
	
	--additional
-- signal load_data: std_logic_vector(7 downto 0);
-- signal load_data_valid: std_logic;
-- signal load_addr: std_logic_vector(2 downto 0);
-- signal load_addr_valid: std_logic;
-- signal instruction_available : std_logic;
-- signal next_instruction: std_logic_vector(3 downto 0); --as size of rom decided by us
-- signal next_instruction_addr: std_logic_vector(15 downto 0);
-- signal pipeline_empty: std_logic;
-- signal instruction_valid: std_logic;
-- signal writeback_data: std_logic_vector(7 downto 0);
-- signal writeback_adddr:std_logic_vector(7 downto 0);
-- signal writeback_valid:std_logic ;
 
	
   -- Clock period definitions
   constant clk_period : time := 10 ns;
BEGIN
 -- Instantiate the for the single-cycle MIPS Processor in VHDL
   uut: MIPS_VHDL PORT MAP (
          clk => clk,
          reset => reset,
          pc_out => pc_out,
          alu_result => alu_result
--			 load_data =>load_data,
--			 load_data_valid=>load_data_valid,
--			 load_addr=>load_addr,
--			 load_addr_valid=>load_addr_valid,
--			 instruction_available=>instruction_available,
--			 next_instruction=>next_instruction,
--			 next_instruction_addr=>next_instruction_addr,
--			 pipeline_empty=>pipeline_empty,
--			 instruction_valid=>instruction_valid,
--			 writeback_data=> writeback_data,
-- writeback_adddr=> writeback_adddr,
-- writeback_valid=> writeback_valid
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
      reset <= '1';
      wait for clk_period*10;
  reset <= '0';
		wait for 10000 ms;
      -- insert stimulus here 
      wait;
   end process;

END;
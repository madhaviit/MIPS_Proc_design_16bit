library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;  

-- VHDL code for the register file of the MIPS Processor


--we have 3 bit addresses for registers (there are 8 registers) and we have each register of 8 bit capacity.
--so we are getting the addresses of register to be read from instruction and we access those registers and get the data there and send it back to the top entity.
entity register_file_VHDL is
port (
 clk,rst: in std_logic;
 write_enable: in std_logic; --*reg_write_en=write_enable
 reg_write_dest: in std_logic_vector(2 downto 0);
 reg_write_data: in std_logic_vector(7 downto 0);----as each register is of size 8bit
 reg_read_addr_1: in std_logic_vector(2 downto 0);
 reg_read_data_1: out std_logic_vector(7 downto 0);
 reg_read_addr_2: in std_logic_vector(2 downto 0);
 reg_read_data_2: out std_logic_vector(7 downto 0)

);
end register_file_VHDL;

-- like a vector of vector 
architecture Behavioral of register_file_VHDL is
type reg_type is array (0 to 7 ) of std_logic_vector (7 downto 0);
signal reg_array: reg_type;
begin
 process(clk,rst) 
 begin
 if(rst='1') then

   reg_array(0) <= x"01";  --reg_array(0)<=x"0001" earlier version if we need.
   reg_array(1) <= x"02";  
   reg_array(2) <= x"03";  
   reg_array(3) <= x"04";  
   reg_array(4) <= x"05";  
   reg_array(5) <= x"06";  
   reg_array(6) <= x"07";  
   reg_array(7) <= x"08";  
 elsif(rising_edge(clk)) then
   if(reg_write_en='1') then --* reg_write_en=write_enable

    reg_array(to_integer(unsigned(reg_write_dest))) <= reg_write_data;
   end if;
 end if;
 end process;

 reg_read_data_1 <= x"00" when reg_read_addr_1 = "000" else reg_array(to_integer(unsigned(reg_read_addr_1)));
 reg_read_data_2 <= x"00" when reg_read_addr_2 = "000" else reg_array(to_integer(unsigned(reg_read_addr_2)));

end Behavioral;
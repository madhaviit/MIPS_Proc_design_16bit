library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;  

entity Data_Memory_VHDL is
port (
 clk: in std_logic;
 mem_access_addr: in std_logic_Vector(7 downto 0);--TEMWORK(why downto 1 and new size of thsi var) --earlier 15 now 7
 mem_write_data: in std_logic_Vector(7 downto 0); --earlier it was 15
 mem_write_en,mem_read:in std_logic;
 mem_read_data: out std_logic_Vector(7 downto 0)--earlier it was 15
);
end Data_Memory_VHDL;

architecture Behavioral of Data_Memory_VHDL is
signal i: integer;
signal ram_addr: std_logic_vector(5 downto 0);-- earlier 7 downto 0
type data_mem is array (0 to 63 ) of std_logic_vector (7 downto 0); --earlier we had 8 bits for address now we have 6 so 64 memory locations and size of register is now 8 bits
signal RAM: data_mem :=((others=> (others=>'0')));
begin

 ram_addr <= mem_access_addr(6 downto 1);--earlier 8 downto 1
 process(clk)
 begin
  if(rising_edge(clk)) then
  if (mem_write_en='1') then
  ram(to_integer(unsigned(ram_addr))) <= mem_write_data;
  end if;
  end if;
 end process;
   mem_read_data <= ram(to_integer(unsigned(ram_addr))) when (mem_read='1') else x"00"; --earlier x"0000"

end Behavioral;

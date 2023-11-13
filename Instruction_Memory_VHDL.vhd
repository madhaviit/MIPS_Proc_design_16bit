library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;  
-- VHDL code for the Instruction Memory of the MIPS Processor
entity Instruction_Memory_VHDL is
port (
 pc: in std_logic_vector(15 downto 0);
 instruction: out  std_logic_vector(15 downto 0)
);
end Instruction_Memory_VHDL;

architecture Behavioral of Instruction_Memory_VHDL is
signal rom_addr: std_logic_vector(3 downto 0);
--old code
 -- lw $3, 0($0) -- pc=0
 -- Loop: sltiu  $1, $3, 11= pc = 2
 -- beq $1, $0, Skip = 4 --PCnext=PC_current+2+BranchAddr
 -- add $4, $4, $3 = 6
 -- addi $3, $3, 1 = 8
 -- beq $0, $0, Loop--a
 -- Skip c = 12 = 4 + 2 + br
--new_instruction
	--lw $3, 0($0) --pc=0
	--addi $5, $3, 9 --pc=2 
 type ROM_type is array (0 to 15 ) of std_logic_vector(15 downto 0);
 constant rom_data: ROM_type:=(
   --"1000000110000000",
   --"0010110010001011",
   --"1100010000000011",
   --"0001000111000000",
   --"1110110110000001",
   --"1100000001111011",
   --"0000000000000000",
   --"0000000000000000",
   --"0000000000000000",
   --"0000000000000000",
   --"0000000000000000",
   --"0000000000000000",
   --"0000000000000000",
   --"0000000000000000",
   --"0000000000000000",
   --"0000000000000000"
	
	"1001011000000000", --we may require to change to array size of 64
   "0010101011001001",
   "1100010000000011",
   "0001000111000000",
   "1110110110000001",
   "1100000001111011",
   "0000000000000000",
   "0000000000000000",
   "0000000000000000",
   "0000000000000000",
   "0000000000000000",
   "0000000000000000",
   "0000000000000000",
   "0000000000000000",
   "0000000000000000",
   "0000000000000000"
	
	
  );
begin

  rom_addr <= pc(4 downto 1);--TEMWORK (Why down to 1)--this represent the index of instruction --we are having pc 4 down to 1 because we want to avoid fluctuations just at the start.
  instruction <= rom_data(to_integer(unsigned(rom_addr))) when pc < x"0020" else x"0000";--this means when pc grows beyond 32, program doesn't prgress further.

end Behavioral;

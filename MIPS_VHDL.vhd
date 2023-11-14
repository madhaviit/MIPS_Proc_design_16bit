library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_signed.all;
entity MIPS_VHDL is
port (
 clk,reset: in std_logic;
 pc_out, alu_result: out std_logic_vector(7 downto 0)
);
end MIPS_VHDL;

architecture Behavioral of MIPS_VHDL is
 signal pc_current: std_logic_vector(7 downto 0);--current program counter
 signal pc_next,pc2: std_logic_vector(7 downto 0);--temporary
 signal instr: std_logic_vector(15 downto 0);
 signal reg_dst,mem_to_reg,alu_op: std_logic_vector(1 downto 0);
 signal jump,branch,mem_read,mem_write,alu_src,reg_write: std_logic;
 signal reg_write_dest: std_logic_vector(2 downto 0);
 signal reg_write_data: std_logic_vector(7 downto 0);
 signal reg_read_addr_1: std_logic_vector(2 downto 0);
 signal reg_read_data_1: std_logic_vector(7 downto 0);
 signal reg_read_addr_2: std_logic_vector(2 downto 0);
 signal reg_read_data_2: std_logic_vector(7 downto 0);
 signal sign_ext_im,read_data2,zero_ext_im,imm_ext: std_logic_vector(7 downto 0);
 signal JRControl: std_logic;
 signal ALU_Control: std_logic_vector(2 downto 0);
 signal ALU_out: std_logic_vector(7 downto 0);
 signal zero_flag: std_logic;
 signal im_shift_1, PC_j, PC_beq, PC_4beq,PC_4beqj,PC_jr: std_logic_vector(7 downto 0);
 signal beq_control: std_logic;
 signal jump_shift_1: std_logic_vector(6 downto 0);
 signal mem_read_data: std_logic_vector(7 downto 0);
 signal no_sign_ext: std_logic_vector(7 downto 0);
 signal sign_or_zero: std_logic;
 signal tmp1: std_logic_vector(1 downto 0); --because we will allow immediate w=values only upto 8 bits
begin
-- PC of the MIPS Processor in VHDL
process(clk,reset)
begin 
 if(reset='1') then
  pc_current <= x"00";
 elsif(rising_edge(clk)) then
  pc_current <= pc_next;
 end if;
end process;
-- PC + 2 
  pc2 <= pc_current + x"02";
  
-------PC_adjustment--------------
-- instruction memory of the MIPS Processor in VHDL
Instruction_Memory: entity work.Instruction_Memory_VHDL 
        port map
       (
        pc=> pc_current,
        instruction => instr
        );
-------------IF---------------
-- jump shift left 1
 jump_shift_1 <= instr(5 downto 0) & '0';--TEMWORK(why 14 bits and 0)
-- control unit of the MIPS Processor in VHDL
control: entity work.control_unit_VHDL
   port map
   (reset => reset,
    opcode => instr(15 downto 12),--change 13 to 12
    reg_dst => reg_dst,
    mem_to_reg => mem_to_reg,
    alu_op => alu_op,
    jump => jump,
    branch => branch,
    mem_read => mem_read,
    mem_write => mem_write,
    alu_src => alu_src,
    reg_write => reg_write,
    sign_or_zero => sign_or_zero
    );
-- multiplexer regdest
  reg_write_dest <= "111" when  reg_dst= "10" else --jal --TEMWORK
        instr(5 downto 3) when  reg_dst= "01" else --add and others -TEMWORK
        instr(11 downto 9); --load-store--we are setting write address according to instruction type --earlier 9down to 7
-- register file instantiation of the MIPS Processor in VHDL
 reg_read_addr_1 <= instr(11 downto 9); --we are setting read addresses
 reg_read_addr_2 <= instr(8 downto 6);
register_file: entity work.register_file_VHDL --mapping the set variables to actual register memory
 port map
 (
 clk => clk,
 rst => reset,
 reg_write_data => reg_write_data,
 reg_read_addr_1 => reg_read_addr_1,
 reg_read_data_1 => reg_read_data_1,
 reg_read_addr_2 => reg_read_addr_2,
 reg_read_data_2 => reg_read_data_2,
 reg_write_en => reg_write,
 reg_write_dest => reg_write_dest
 );
 --addi

--	reg_write_data<=reg_read_data_1+unsigned(to_integer(instr(5 downto 0))) when (instr(15 downto 12)="0010") else reg_write_data;

-- sign extend is required because we want to move backwards in some cases so we may need to add for example -4$(reg_addr). That is why
 tmp1 <= (others => instr(5));--still need to think TEMWORK --4op 3-r1 -3r2  -6 imm (so 6th bit will nbe signed bit with index 5)
 sign_ext_im <=  tmp1 & instr(5 downto 0); 
 zero_ext_im <= "00"& instr(5 downto 0); 
 imm_ext <= sign_ext_im when sign_or_zero='1' else zero_ext_im;
-- JR control unit of the MIPS Processor in VHDL
 JRControl <= '1' when ((alu_op="00") and (instr(15 downto 12)="1000")) else '0';--for now commented
-- ALU control unit of the MIPS Processor in VHDL

-----------------ID done-----------------------------
ALUControl: entity work.ALU_Control_VHDL port map
  (
   ALUOp => alu_op,
   ALU_Funct => instr(2 downto 0),
   ALU_Control => ALU_Control
   );
-- multiplexer alu_src
 read_data2 <= imm_ext when alu_src='1' else reg_read_data_2;
-- ALU unit of the MIPS Processor in VHDL
alu: entity work.ALU_VHDL port map
  (
   a => reg_read_data_1,
   b => read_data2,
   alu_control => ALU_Control,
   alu_result => ALU_out,
   zero => zero_flag
   );
-- immediate shift 1
 im_shift_1 <= imm_ext(6 downto 0) & '0';
 no_sign_ext <= (not im_shift_1) + x"01";
-- PC beq add
 PC_beq <= (pc2 - no_sign_ext) when im_shift_1(7) = '1' else (pc2 +im_shift_1);
-- beq control
   beq_control <= branch and zero_flag;
-- PC_beq
   PC_4beq <= PC_beq when beq_control='1' else pc2;
-- PC_j
 PC_j <= pc2(7) & jump_shift_1;
-- PC_4beqj
 PC_4beqj <= PC_j when jump = '1' else  PC_4beq;
-- PC_jr
 PC_jr <= reg_read_data_1;
-- PC_next
 pc_next <= PC_jr when (JRControl='1') else PC_4beqj;
 
 
-----------------------EXE done----------------------
-- data memory of the MIPS Processor in VHDL
data_memory: entity work.Data_Memory_VHDL port map
  (
  clk => clk,
  mem_access_addr => ALU_out,
  mem_write_data => reg_read_data_2,
  mem_write_en => mem_write,
  mem_read => mem_read,
  mem_read_data => mem_read_data
  );
-- write back of the MIPS Processor in VHDL
 reg_write_data <= pc2 when (mem_to_reg = "10") else
       mem_read_data when (mem_to_reg = "01") else ALU_out;
-- output
 pc_out <= pc_current;
 alu_result <= ALU_out;
-------------------MEM and WB done------------------------
end Behavioral;

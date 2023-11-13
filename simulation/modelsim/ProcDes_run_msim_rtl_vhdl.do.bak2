transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {D:/Quartus/ProcDes/Data_Memory_VHDL.vhd}
vcom -93 -work work {D:/Quartus/ProcDes/ALU_VHDL.vhd}
vcom -93 -work work {D:/Quartus/ProcDes/ALU_Control_VHDL.vhd}
vcom -93 -work work {D:/Quartus/ProcDes/register_file_VHDL.vhd}
vcom -93 -work work {D:/Quartus/ProcDes/control_unit_VHDL.vhd}
vcom -93 -work work {D:/Quartus/ProcDes/Instruction_Memory_VHDL.vhd}
vcom -93 -work work {D:/Quartus/ProcDes/MIPS_VHDL.vhd}

vcom -93 -work work {D:/Quartus/ProcDes/tb_MIPS_VHDL.vhd}

vsim -t 1ps -L altera -L lpm -L sgate -L altera_mf -L altera_lnsim -L cycloneive -L rtl_work -L work -voptargs="+acc"  tb_MIPS_VHDL

add wave *
view structure
view signals
run 1 sec

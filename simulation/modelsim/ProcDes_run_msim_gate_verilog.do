transcript on
if {[file exists gate_work]} {
	vdel -lib gate_work -all
}
vlib gate_work
vmap work gate_work

vlog -vlog01compat -work work +incdir+. {ProcDes.vo}

vcom -93 -work work {D:/Quartus/ProcDes/tb_MIPS_VHDL.vhd}

vsim -t 1ps -L altera_ver -L cycloneive_ver -L gate_work -L work -voptargs="+acc"  tb_MIPS_VHDL

add wave *
view structure
view signals
run 1 sec

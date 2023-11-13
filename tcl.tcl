quit -sim
vlib work
vcom ../*.vhd
vcom *.vht
vsim work.testbench -Lf 220model -Lf altera_mf
do wave.do
run 120 ns
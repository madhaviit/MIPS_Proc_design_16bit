onerror {exit -code 1}
vlib work
vcom -work work ProcDes.vho
vcom -work work Waveform2.vwf.vht
vsim -c -t 1ps -sdfmax MIPS_VHDL_vhd_vec_tst/i1=ProcDes_vhd.sdo -L cycloneive -L altera -L altera_mf -L 220model -L sgate -L altera_lnsim work.MIPS_VHDL_vhd_vec_tst
vcd file -direction ProcDes.msim.vcd
vcd add -internal MIPS_VHDL_vhd_vec_tst/*
vcd add -internal MIPS_VHDL_vhd_vec_tst/i1/*
proc simTimestamp {} {
    echo "Simulation time: $::now ps"
    if { [string equal running [runStatus]] } {
        after 2500 simTimestamp
    }
}
after 2500 simTimestamp
run -all
quit -f

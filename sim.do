if {[file isdirectory work]} {vdel -all -lib work}
vlib work
vmap work work

set TOP_ENTITY {work.TB_Processor}

vlog -work work +cover=bcesfx IF_SPI.sv
vlog -work work +cover=bcesfx alu.sv
vlog -work work +cover=bcesfx processor.sv
vlog -work work +cover=bcesfx TB_Processor.sv

vsim -voptargs=+acc ${TOP_ENTITY} -coverage

quietly set StdArithNoWarnings 1
quietly set StdVitalGlitchNoWarnings 1

run 1000ns
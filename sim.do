if {[file isdirectory work]} {vdel -all -lib work}
vlib work
vmap work work

#lembrar de mudar os nomes

set TOP_ENTITY {work.tb_spi}

vlog -work work +cover=bcesfx ispi.sv
vlog -work work +cover=bcesfx spi_master.sv
vlog -work work +cover=bcesfx spi_slave.sv
vlog -work work +cover=bcesfx tb_spi.sv

vsim -voptargs=+acc ${TOP_ENTITY} -coverage

quietly set StdArithNoWarnings 1
quietly set StdVitalGlitchNoWarnings 1

do wave.do
run 100ns
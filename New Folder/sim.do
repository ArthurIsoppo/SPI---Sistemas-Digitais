if {[file isdirectory work]} {vdel -all -lib work}
vlib work
vmap work work

set TOP_ENTITY {work.tb_spi}

vlog -work work ispi.sv
vlog -work work spi_master.sv
vlog -work work spi_slave.sv
vlog -work work tb_spi.sv

vsim -voptargs=+acc ${TOP_ENTITY}

quietly set StdArithNoWarnings 1
quietly set StdVitalGlitchNoWarnings 1

do wave.do
run 100ns
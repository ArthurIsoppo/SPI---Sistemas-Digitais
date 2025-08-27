onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Interface -color Yellow /tb_spi/if_spi/sclk
add wave -noupdate -expand -group Interface -color Yellow /tb_spi/if_spi/miso
add wave -noupdate -expand -group Interface -color Yellow /tb_spi/if_spi/mosi
add wave -noupdate -expand -group Interface -color Yellow /tb_spi/if_spi/nss
add wave -noupdate -expand -group master -color Cyan /tb_spi/master/bits_in
add wave -noupdate -expand -group master -color Cyan /tb_spi/master/clock
add wave -noupdate -expand -group master -color Cyan /tb_spi/master/reset
add wave -noupdate -expand -group master -color Cyan /tb_spi/master/bits_out
add wave -noupdate -expand -group master -color Cyan /tb_spi/master/nss
add wave -noupdate -expand -group master -color Cyan /tb_spi/master/mosi
add wave -noupdate -expand -group slave -color Violet /tb_spi/if_spi/sclk
add wave -noupdate -expand -group slave -color Violet /tb_spi/if_spi/miso
add wave -noupdate -expand -group slave -color Violet /tb_spi/if_spi/mosi
add wave -noupdate -expand -group slave -color Violet /tb_spi/if_spi/nss
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1 us}

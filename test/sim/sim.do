onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate sim:/testbench/regfile_tb;
add wave -noupdate sim:/testbench/opcode_str;
add wave -noupdate -r *;
add wave -noupdate sim:/testbench/ram_tb;
TreeUpdate [SetDefaultTree]
quietly wave cursor active 1
configure wave -namecolwidth 397
configure wave -valuecolwidth 120
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
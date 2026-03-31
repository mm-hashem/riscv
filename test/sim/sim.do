onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate sim:/rv_top/RV_CORE/rv_core_inst/register_file_inst/regfile;
add wave -noupdate sim:/rv_top/RV_CORE/rv_core_inst/monitor_inst/instr_name;
add wave -noupdate -r *;
add wave -noupdate sim:/rv_top/RV_CORE/rv_core_inst/data_ram_inst/ram;
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
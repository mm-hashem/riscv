onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group TESTBENCH /testbench/clk_i
add wave -noupdate -expand -group TESTBENCH /testbench/rst_i
add wave -noupdate -expand -group TESTBENCH /testbench/pc_init_i
add wave -noupdate -expand -group RV32I /testbench/rv32i_inst/pc
add wave -noupdate -expand -group RV32I /testbench/rv32i_inst/result
add wave -noupdate -expand -group RV32I /testbench/rv32i_inst/instr
add wave -noupdate -expand -group RV32I /testbench/rv32i_inst/imm_ext
add wave -noupdate -group {PROGRAM COUNTER} /testbench/rv32i_inst/program_counter_inst/pc_src_i
add wave -noupdate -group {PROGRAM COUNTER} /testbench/rv32i_inst/program_counter_inst/pc_init_i
add wave -noupdate -group {PROGRAM COUNTER} /testbench/rv32i_inst/program_counter_inst/imm_ext_i
add wave -noupdate -group {PROGRAM COUNTER} /testbench/rv32i_inst/program_counter_inst/pc_o
add wave -noupdate -group {PROGRAM COUNTER} /testbench/rv32i_inst/program_counter_inst/pc_next_o
add wave -noupdate -group {PROGRAM COUNTER} /testbench/rv32i_inst/program_counter_inst/state
add wave -noupdate -group {INSTRUCTIONS MEMORY} /testbench/rv32i_inst/instr_ram_inst/a_i
add wave -noupdate -group {INSTRUCTIONS MEMORY} /testbench/rv32i_inst/instr_ram_inst/rd_o
add wave -noupdate -expand -group {REGISTER FILE} /testbench/rv32i_inst/register_file_inst/we3_i
add wave -noupdate -expand -group {REGISTER FILE} /testbench/rv32i_inst/register_file_inst/a1_i
add wave -noupdate -expand -group {REGISTER FILE} /testbench/rv32i_inst/register_file_inst/a2_i
add wave -noupdate -expand -group {REGISTER FILE} /testbench/rv32i_inst/register_file_inst/a3_i
add wave -noupdate -expand -group {REGISTER FILE} /testbench/rv32i_inst/register_file_inst/wd3_i
add wave -noupdate -expand -group {REGISTER FILE} /testbench/rv32i_inst/register_file_inst/rd1_o
add wave -noupdate -expand -group {REGISTER FILE} /testbench/rv32i_inst/register_file_inst/rd2_o
add wave -noupdate -expand -group {REGISTER FILE} /testbench/rv32i_inst/register_file_inst/regfile
add wave -noupdate -group ALU /testbench/rv32i_inst/alu_inst/alu_ctrl_i
add wave -noupdate -group ALU /testbench/rv32i_inst/alu_inst/src_a_i
add wave -noupdate -group ALU /testbench/rv32i_inst/alu_inst/src_b_i
add wave -noupdate -group ALU /testbench/rv32i_inst/alu_inst/zero_o
add wave -noupdate -group ALU /testbench/rv32i_inst/alu_inst/alu_result_o
add wave -noupdate -expand -group CONTROLLER /testbench/rv32i_inst/controller_inst/zero_i
add wave -noupdate -expand -group CONTROLLER /testbench/rv32i_inst/controller_inst/pc_src_o
add wave -noupdate -expand -group CONTROLLER -expand -group {MAIN DECODER} -radix binary /testbench/rv32i_inst/controller_inst/main_decoder_inst/op_i
add wave -noupdate -expand -group CONTROLLER -expand -group {MAIN DECODER} /testbench/rv32i_inst/controller_inst/main_decoder_inst/reg_write_o
add wave -noupdate -expand -group CONTROLLER -expand -group {MAIN DECODER} /testbench/rv32i_inst/controller_inst/main_decoder_inst/alu_src_o
add wave -noupdate -expand -group CONTROLLER -expand -group {MAIN DECODER} /testbench/rv32i_inst/controller_inst/main_decoder_inst/mem_write_o
add wave -noupdate -expand -group CONTROLLER -expand -group {MAIN DECODER} /testbench/rv32i_inst/controller_inst/main_decoder_inst/branch_o
add wave -noupdate -expand -group CONTROLLER -expand -group {MAIN DECODER} /testbench/rv32i_inst/controller_inst/main_decoder_inst/jump_o
add wave -noupdate -expand -group CONTROLLER -expand -group {MAIN DECODER} /testbench/rv32i_inst/controller_inst/main_decoder_inst/result_src_o
add wave -noupdate -expand -group CONTROLLER -expand -group {MAIN DECODER} /testbench/rv32i_inst/controller_inst/main_decoder_inst/imm_src_o
add wave -noupdate -expand -group CONTROLLER -expand -group {MAIN DECODER} /testbench/rv32i_inst/controller_inst/main_decoder_inst/alu_op_o
add wave -noupdate -expand -group CONTROLLER -group {ALU DECODER} /testbench/rv32i_inst/controller_inst/alu_decoder_inst/alu_op_i
add wave -noupdate -expand -group CONTROLLER -group {ALU DECODER} /testbench/rv32i_inst/controller_inst/alu_decoder_inst/funct3_i
add wave -noupdate -expand -group CONTROLLER -group {ALU DECODER} /testbench/rv32i_inst/controller_inst/alu_decoder_inst/op_i
add wave -noupdate -expand -group CONTROLLER -group {ALU DECODER} /testbench/rv32i_inst/controller_inst/alu_decoder_inst/funct7_i
add wave -noupdate -expand -group CONTROLLER -group {ALU DECODER} /testbench/rv32i_inst/controller_inst/alu_decoder_inst/alu_ctrl_o
add wave -noupdate -group {DATA MEMORY} /testbench/rv32i_inst/data_ram_inst/we_i
add wave -noupdate -group {DATA MEMORY} /testbench/rv32i_inst/data_ram_inst/a_i
add wave -noupdate -group {DATA MEMORY} /testbench/rv32i_inst/data_ram_inst/wd_i
add wave -noupdate -group {DATA MEMORY} /testbench/rv32i_inst/data_ram_inst/rd_o
add wave -noupdate -group {SIGN EXTENDER} /testbench/rv32i_inst/sign_extender_inst/imm_src_i
add wave -noupdate -group {SIGN EXTENDER} /testbench/rv32i_inst/sign_extender_inst/instr_i
add wave -noupdate -group {SIGN EXTENDER} /testbench/rv32i_inst/sign_extender_inst/imm_ext_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {13 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 424
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
WaveRestoreZoom {0 ns} {131 ns}

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group DEFINITIONS /definitions_pkg::VERSION
add wave -noupdate -group DEFINITIONS /definitions_pkg::FNAME_DATA
add wave -noupdate -group DEFINITIONS /definitions_pkg::FNAME_TEXT
add wave -noupdate -group DEFINITIONS /definitions_pkg::TEXT_ORG
add wave -noupdate -group DEFINITIONS /definitions_pkg::DATA_ORG
add wave -noupdate -group DEFINITIONS /definitions_pkg::TEXT_LENGTH
add wave -noupdate -group DEFINITIONS /definitions_pkg::DATA_LENGTH
add wave -noupdate -group DEFINITIONS /definitions_pkg::TEXT_END
add wave -noupdate -group DEFINITIONS /definitions_pkg::DATA_END
add wave -noupdate -group TESTBENCH /testbench/clk_i
add wave -noupdate -group TESTBENCH /testbench/rst_i
add wave -noupdate -group TESTBENCH /testbench/pc_init_i
add wave -noupdate -group RV32I /testbench/rv32i_inst/result
add wave -noupdate -group RV32I /testbench/rv32i_inst/pc
add wave -noupdate -group RV32I /testbench/rv32i_inst/pc_next
add wave -noupdate -group RV32I /testbench/rv32i_inst/pc_next_4
add wave -noupdate -group RV32I /testbench/rv32i_inst/pc_next_imm
add wave -noupdate -group RV32I /testbench/rv32i_inst/read_data
add wave -noupdate -group RV32I /testbench/rv32i_inst/read_data_sized
add wave -noupdate -group RV32I /testbench/rv32i_inst/rs2_d
add wave -noupdate -group RV32I /testbench/rv32i_inst/write_data_sized
add wave -noupdate -group RV32I /testbench/rv32i_inst/rs1_d
add wave -noupdate -group RV32I /testbench/rv32i_inst/src_b
add wave -noupdate -group PROGRAM_COUNTER /testbench/rv32i_inst/program_counter_inst/pc_init_i
add wave -noupdate -group PROGRAM_COUNTER /testbench/rv32i_inst/program_counter_inst/pc_next_i
add wave -noupdate -group PROGRAM_COUNTER /testbench/rv32i_inst/program_counter_inst/pc_o
add wave -noupdate -group INSTRUCTION_MEMORY /testbench/rv32i_inst/instr_ram_inst/instr_a_i
add wave -noupdate -group INSTRUCTION_MEMORY /testbench/rv32i_inst/instr_ram_inst/instr_o
add wave -noupdate -group REGISTER_FILE /testbench/rv32i_inst/register_file_inst/rd_we_i
add wave -noupdate -group REGISTER_FILE -radix symbolic /testbench/rv32i_inst/register_file_inst/rs1_a_i
add wave -noupdate -group REGISTER_FILE -radix symbolic /testbench/rv32i_inst/register_file_inst/rs2_a_i
add wave -noupdate -group REGISTER_FILE -radix symbolic /testbench/rv32i_inst/register_file_inst/rd_a_i
add wave -noupdate -group REGISTER_FILE /testbench/rv32i_inst/register_file_inst/rd_d_i
add wave -noupdate -group REGISTER_FILE /testbench/rv32i_inst/register_file_inst/rs1_d_o
add wave -noupdate -group REGISTER_FILE /testbench/rv32i_inst/register_file_inst/rs2_d_o
add wave -noupdate -group EXTEND_IMM /testbench/rv32i_inst/extend_imm_inst/imm_src_i
add wave -noupdate -group EXTEND_IMM /testbench/rv32i_inst/extend_imm_inst/instr_i
add wave -noupdate -group EXTEND_IMM /testbench/rv32i_inst/extend_imm_inst/imm_ext_o
add wave -noupdate -group CONTROLLER /testbench/rv32i_inst/controller_inst/zero_i
add wave -noupdate -group CONTROLLER /testbench/rv32i_inst/controller_inst/less_than_i
add wave -noupdate -group CONTROLLER /testbench/rv32i_inst/controller_inst/pc_src_o
add wave -noupdate -group CONTROLLER -group MAIN_DECODER -radix symbolic /testbench/rv32i_inst/controller_inst/main_decoder_inst/op_i
add wave -noupdate -group CONTROLLER -group MAIN_DECODER /testbench/rv32i_inst/controller_inst/main_decoder_inst/reg_write_o
add wave -noupdate -group CONTROLLER -group MAIN_DECODER -radix symbolic /testbench/rv32i_inst/controller_inst/main_decoder_inst/imm_src_o
add wave -noupdate -group CONTROLLER -group MAIN_DECODER /testbench/rv32i_inst/controller_inst/main_decoder_inst/alu_src_o
add wave -noupdate -group CONTROLLER -group MAIN_DECODER /testbench/rv32i_inst/controller_inst/main_decoder_inst/mem_write_o
add wave -noupdate -group CONTROLLER -group MAIN_DECODER -radix binary /testbench/rv32i_inst/controller_inst/main_decoder_inst/result_src_o
add wave -noupdate -group CONTROLLER -group MAIN_DECODER /testbench/rv32i_inst/controller_inst/main_decoder_inst/branch_o
add wave -noupdate -group CONTROLLER -group MAIN_DECODER -radix binary /testbench/rv32i_inst/controller_inst/main_decoder_inst/alu_op_o
add wave -noupdate -group CONTROLLER -group MAIN_DECODER /testbench/rv32i_inst/controller_inst/main_decoder_inst/jump_o
add wave -noupdate -group CONTROLLER -group MAIN_DECODER -radix binary /testbench/rv32i_inst/controller_inst/main_decoder_inst/up_imm_src_o
add wave -noupdate -group CONTROLLER -group MAIN_DECODER /testbench/rv32i_inst/controller_inst/main_decoder_inst/ctrl_signals
add wave -noupdate -group CONTROLLER -group ALU_DECODER /testbench/rv32i_inst/controller_inst/alu_decoder_inst/alu_op_i
add wave -noupdate -group CONTROLLER -group ALU_DECODER /testbench/rv32i_inst/controller_inst/alu_decoder_inst/funct3_i
add wave -noupdate -group CONTROLLER -group ALU_DECODER /testbench/rv32i_inst/controller_inst/alu_decoder_inst/op_5_i
add wave -noupdate -group CONTROLLER -group ALU_DECODER /testbench/rv32i_inst/controller_inst/alu_decoder_inst/funct7_5_i
add wave -noupdate -group CONTROLLER -group ALU_DECODER -radix symbolic /testbench/rv32i_inst/controller_inst/alu_decoder_inst/alu_control_o
add wave -noupdate -group ALU -radix symbolic /testbench/rv32i_inst/alu_inst/alu_control_i
add wave -noupdate -group ALU /testbench/rv32i_inst/alu_inst/src_a_i
add wave -noupdate -group ALU /testbench/rv32i_inst/alu_inst/src_b_i
add wave -noupdate -group ALU /testbench/rv32i_inst/alu_inst/zero_o
add wave -noupdate -group ALU /testbench/rv32i_inst/alu_inst/alu_result_o
add wave -noupdate -group extend_write_data /testbench/rv32i_inst/extend_write_data_inst/write_data_i
add wave -noupdate -group extend_write_data /testbench/rv32i_inst/extend_write_data_inst/funct3_i
add wave -noupdate -group extend_write_data /testbench/rv32i_inst/extend_write_data_inst/write_data_sized_o
add wave -noupdate -group DATA_MEMORY /testbench/rv32i_inst/data_ram_inst/we_i
add wave -noupdate -group DATA_MEMORY /testbench/rv32i_inst/data_ram_inst/a_i
add wave -noupdate -group DATA_MEMORY /testbench/rv32i_inst/data_ram_inst/wd_i
add wave -noupdate -group DATA_MEMORY /testbench/rv32i_inst/data_ram_inst/rd_o
add wave -noupdate -group EXTEND_READ_DATA /testbench/rv32i_inst/extend_read_data_inst/read_data_i
add wave -noupdate -group EXTEND_READ_DATA /testbench/rv32i_inst/extend_read_data_inst/funct3_i
add wave -noupdate -group EXTEND_READ_DATA /testbench/rv32i_inst/extend_read_data_inst/read_data_sized_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {37 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 424
configure wave -valuecolwidth 74
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
WaveRestoreZoom {3 ns} {157 ns}

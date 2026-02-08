module rv64i_zba_pipe3
    import definitions_pkg::*;
(
    input  logic   clk_i, rst_i,
    input  word_st pc_init_i
);
    timeunit 1ns/1ns;

    logic pc_src_s3, flush_dc,flush_s3;
    word_st      pc_next_imm_s3;
    word_32ut instr_dc;
    word_st pc_next_4_s3,pc_s3, pc_next_4_dc, pc_dc;

    hazard_unit hazard_unit_dc_inst (
        .pc_src_s3_i(pc_src_s3),
        .flush_dc_o(flush_dc),
        .flush_s3_o(flush_s3)
    );

    fetch fetch_inst (
        .clk_i, .rst_i,
        .pc_src_ft_i(pc_src_s3),
        .flush_dc_i(flush_dc),
        .pc_init_ft_i(pc_init_i),
        .pc_next_imm_ft_i(pc_next_imm_s3),
        .instr_ft_o(instr_dc),
        .pc_next_4_ft_o(pc_next_4_dc),
        .pc_ft_o(pc_dc)
    );

    imm_src_e imm_src_dc;
    logic reg_write_s3, mem_write_s3, data_memory_sign_s3,
    branch_s3, jump_s3,word_32_s3;
    logic [1:0] result_src_s3,data_memory_size_s3,up_imm_src_s3;
    alu_e alu_control_s3;
    logic [2:0] funct3_s3;

    decode_cp decode_cp_inst (
        .clk_i, .rst_i,
        .instr_dc_i(instr_dc),
        .alu_src_dc_o(alu_src_s3), .reg_write_dc_o(reg_write_s3), .mem_write_dc_o(mem_write_s3),
        .data_memory_sign_dc_o(data_memory_sign_s3), .branch_dc_o(branch_s3), .jump_dc_o(jump_s3),
        .result_src_dc_o(result_src_s3), .up_imm_src_dc_o(up_imm_src_s3), .data_memory_size_dc_o(data_memory_size_s3),
        .imm_src_dc_o(imm_src_dc), .word_32_dc_o(word_32_s3),
        .alu_control_dc_o(alu_control_s3), .funct3_dc_o(funct3_s3)
    );

    word_st rs1_d_s3, rs2_d_s3, imm_ext_s3, result_s3;

    decode_dp decode_dp_inst (
    .clk_i, .rst_i,
    .flush_s3_i(flush_s3),
    .reg_write_dc_i(reg_write_s3),
    .instr_dc_i(instr_dc),
    .rd_d_dc_i(result_s3),.pc_dc_i(pc_dc),.pc_next_4_dc_i(pc_next_4_dc),
    .imm_src_dc_i(imm_src_dc),
    .rs1_d_dc_o(rs1_d_s3), .rs2_d_dc_o(rs2_d_s3),
    .imm_ext_dc_o(imm_ext_s3),.pc_dc_o(pc_s3),.pc_next_4_dc_o(pc_next_4_s3)
    );

    logic zero_s3, less_than_s3;

    stage3_cp stage3_cp_inst (
        .branch_s3_i(branch_s3), .jump_s3_i(jump_s3),
        .funct3_s3_i(funct3_s3),
        .zero_s3_i(zero_s3), .less_than_s3_i(less_than_s3),
        .pc_src_s3_o(pc_src_s3)
    );

    stage3_dp stage3_dp_inst (
    .clk_i, .rst_i,
    .alu_src_s3_i(alu_src_s3),.up_imm_src_s3_i(up_imm_src_s3),
    .data_memory_sign_s3_i(data_memory_sign_s3), .mem_write_s3_i(mem_write_s3),
    .result_src_s3_i(result_src_s3),.data_memory_size_s3_i(data_memory_size_s3),
    .alu_control_s3_i(alu_control_s3), .word_32_s3_i(word_32_s3),
    .pc_s3_i(pc_s3), .pc_next_4_s3_i(pc_next_4_s3),
    .rs1_d_s3_i(rs1_d_s3), .rs2_d_s3_i(rs2_d_s3), .imm_ext_s3_i(imm_ext_s3),
    .pc_next_imm_s3_o(pc_next_imm_s3), .result_s3_o(result_s3),
    .zero_s3_o(zero_s3), .less_than_s3_o(less_than_s3)
    );

endmodule : rv64i_zba_pipe3
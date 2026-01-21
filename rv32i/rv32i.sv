module rv32i
    import definitions_pkg::*;
(
    input  logic   clk_i, rst_i,
    input  word_st pc_init_i
);
    timeunit 1ns/1ns;

    word_st pc, pc_next, imm_ext, alu_result, read_data, read_data_sized, write_data, result;
    word_ut instr;
    word_st src_a, src_b;

    logic       alu_src,   pc_src,
                reg_write, mem_write;
    logic [1:0] imm_src,   result_src;
    alu_t alu_ctrl;
    logic zero;

    program_counter program_counter_inst (
        .clk_i,   .rst_i,
        .pc_src_i (pc_src),
        .pc_init_i(pc_init_i),
        .imm_ext_i(imm_ext),
        .pc_o     (pc), .pc_next_o(pc_next)
    );

    instruction_ram instr_ram_inst (
        .a_i(pc), .rd_o(instr)
    );

    immediate_extender immediate_extender_inst (
        .imm_src_i(imm_src),
        .instr_i  (instr),
        .imm_ext_o(imm_ext)
    );

    controller controller_inst (
        .op_i       (instr[6:0]),
        .funct3_i   (instr[14:12]),
        .funct7_i   (instr[30]),
        .zero_i     (zero),
        .alu_src_o  (alu_src),   .result_src_o(result_src), .pc_src_o(pc_src),
        .reg_write_o(reg_write), .mem_write_o (mem_write),
        .imm_src_o  (imm_src),   .alu_ctrl_o  (alu_ctrl)
    ); 

    register_file register_file_inst (
        .clk_i, .rst_i,
        .we_3_i(reg_write),
        .a_1_i (instr[19:15]), .a_2_i(instr[24:20]), .a_3_i(instr[11:7]),
        .wd_3_i(result),
        .rd_1_o(src_a), .rd_2_o(write_data)
    );

    assign src_b = alu_src ? imm_ext : write_data;

    alu alu_inst (
        .alu_ctrl_i  (alu_ctrl),
        .src_a_i     (src_a),     .src_b_i(src_b),
        .zero_o      (zero),
        .alu_result_o(alu_result)
    );

    data_ram data_ram_inst (
        .clk_i, .rst_i,
        .we_i(mem_write),
        .a_i (alu_result), .wd_i(write_data),
        .rd_o(read_data)
    );

    read_data_extender read_data_extender_inst (
        .read_data_i      (read_data),
        .funct3_i         (instr[14:12]),
        .read_data_sized_o(read_data_sized)
    );

    assign result = result_src[1] ? pc_next : result_src[0] ? read_data_sized : alu_result;
    
endmodule: rv32i
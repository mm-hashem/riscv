module rv32i_single
    import definitions_pkg::*;
(
    input  logic   clk_i, rst_i,
    input  word_st pc_init_i
);
    timeunit 1ns/1ns;

    word_st imm_ext, alu_result, result;
    
    // Program Counter signals
    word_st pc, pc_next, pc_next_4, pc_next_imm;

    // Data Memory signals
    word_st read_data,  read_data_sized,
            rs2_d, write_data_sized;

    word_32ut instr;
    word_st rs1_d, src_b;

    // Control signals
    logic       alu_src,    pc_src,
                reg_write,  mem_write,
                data_memory_sign;
    logic [1:0] up_imm_src, result_src,
                data_memory_size;
    imm_src_e   imm_src;
    alu_e       alu_control;

    // ALU Flags
    logic zero;
    
    ///////////// Program Counter
    assign pc_next_4 = pc + 32'sd4;

    // Jump/Branch adder, used for U-type and dalr instructions instructions
    always_comb begin : JmpBrnAdderMux
        unique case (up_imm_src)
            2'b00:   pc_next_imm = imm_ext;         // lui
            2'b01:   pc_next_imm = pc    + imm_ext; // auipc
            2'b10:   pc_next_imm = rs1_d + imm_ext; // jalr
            default: pc_next_imm = 32'bx;
        endcase
    end : JmpBrnAdderMux

    assign pc_next = pc_src ? pc_next_imm : pc_next_4;

    program_counter program_counter_inst (
        .clk_i, .rst_i,
        .pc_init_i(pc_init_i),
        .pc_next_i(pc_next),
        .pc_o(pc)
    );

    instruction_ram instr_ram_inst (
        .instr_a_i(pc), .instr_o(instr)
    );

    register_file register_file_inst (
        .clk_i, .rst_i,
        .rd_we_i(reg_write),
        .rs1_a_i(reg_e'(instr[19:15])), .rs2_a_i(reg_e'(instr[24:20])), .rd_a_i(reg_e'(instr[11:7])),
        .rd_d_i (result),
        .rs1_d_o(rs1_d), .rs2_d_o(rs2_d)
    );

    extend_imm extend_imm_inst (
        .imm_src_i(imm_src),
        .instr_i  (instr),
        .imm_ext_o(imm_ext)
    );

    controller controller_inst (
        .op_i       (opcode_e'(instr[6:0])),
        .funct3_i   (instr[14:12]),
        .funct7_5_i (instr[30]),
        .zero_i     (zero),                    .less_than_i  (alu_result[0]),
        .alu_src_o  (alu_src),                 .result_src_o (result_src), .pc_src_o(pc_src),
        .reg_write_o(reg_write),               .mem_write_o  (mem_write),  .up_imm_src_o(up_imm_src),
        .imm_src_o  (imm_src),                 .alu_control_o(alu_control),
        .data_memory_sign_o(data_memory_sign), .data_memory_size_o(data_memory_size)
`ifdef PIPELINE3
        ,.branch_o(), .jump_o()
`endif
    );

    // ALUSrc Mux
    assign src_b = alu_src ? imm_ext : rs2_d;

    alu alu_inst (
        .alu_control_i(alu_control),
        .src_a_i      (rs1_d),     .src_b_i(src_b),
        .zero_o       (zero),
        .alu_result_o (alu_result)
    );

    extend_write_data extend_write_data_inst (
        .write_data_i(rs2_d),
        .data_memory_size_i(data_memory_size),
        .write_data_sized_o(write_data_sized)
    );

    data_ram data_ram_inst (
        .clk_i, .rst_i,
        .we_i(mem_write),
        .a_i (alu_result), .wd_i(write_data_sized),
        .rd_o(read_data)
    );

    extend_read_data extend_read_data_inst (
        .read_data_i       (read_data),
        .data_memory_sign_i(data_memory_sign),
        .data_memory_size_i(data_memory_size),
        .read_data_sized_o (read_data_sized)
    );

    // ResultSrc Mux
    always_comb begin : ResultSrcMux
        unique case (result_src)
            2'b00:   result = alu_result;
            2'b01:   result = read_data_sized;
            2'b10:   result = pc_next_4;
            2'b11:   result = pc_next_imm;
            default: result = 32'bx;
        endcase
    end : ResultSrcMux
    
endmodule : rv32i_single
module decode_cp
    import definitions_pkg::*;
(
    input logic clk_i, rst_i,
    input word_32ut instr_dc_i,
    output logic alu_src_dc_o, reg_write_dc_o, mem_write_dc_o,
    data_memory_sign_dc_o, branch_dc_o, jump_dc_o, word_32_dc_o,
    output logic [1:0] result_src_dc_o, up_imm_src_dc_o, data_memory_size_dc_o,
    output imm_src_e imm_src_dc_o,
    output alu_e alu_control_dc_o,
    output logic [2:0] funct3_dc_o
);

    logic data_memory_sign_dc,reg_write_dc, mem_write_dc, jump_dc, branch_dc, alu_src_dc, word_32_dc;
    logic [1:0] data_memory_size_dc,up_imm_src_dc,result_src_dc;
    alu_e alu_control_dc;
    //imm_src_e imm_src_dc;

    controller controller_s2_inst (
        .op_i       (opcode_e'(instr_dc_i[6:0])),
        .funct3_i   (instr_dc_i[14:12]),
        .funct7_5_i (instr_dc_i[30]),
        //.zero_i     (),                    .less_than_i  (), NOT NEEDED FOR PIPELINE
`ifdef ZBA
        .funct7_4_i(instr_dc_i[29]), .funct7_2_i(instr_dc_i[27]),
`endif
        .alu_src_o  (alu_src_dc),                 .result_src_o (result_src_dc), .pc_src_o(),
        .reg_write_o(reg_write_dc),               .mem_write_o  (mem_write_dc),  .up_imm_src_o(up_imm_src_dc),
        .imm_src_o  (imm_src_dc_o),                 .alu_control_o(alu_control_dc),
        .data_memory_sign_o(data_memory_sign_dc), .data_memory_size_o(data_memory_size_dc),
        .branch_o(branch_dc), .jump_o(jump_dc), .word_32_o(word_32_dc)
    );

    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            data_memory_sign_dc_o <='0;
            data_memory_size_dc_o<='0;
            up_imm_src_dc_o<='0;
            reg_write_dc_o<='0;
            result_src_dc_o<='0;
            mem_write_dc_o<='0;
            jump_dc_o<='0;
            branch_dc_o<='0;
            alu_control_dc_o<=ALU_ADD;
            alu_src_dc_o<='0;
            funct3_dc_o<='0;
            word_32_dc_o<='0;
        end else begin
            data_memory_sign_dc_o<=data_memory_sign_dc;
            data_memory_size_dc_o<=data_memory_size_dc;
            up_imm_src_dc_o<=up_imm_src_dc;
            reg_write_dc_o<=reg_write_dc;
            result_src_dc_o<=result_src_dc;
            mem_write_dc_o<=mem_write_dc;
            jump_dc_o<=jump_dc;
            branch_dc_o<=branch_dc;
            alu_control_dc_o<=alu_control_dc;
            alu_src_dc_o<=alu_src_dc;
            funct3_dc_o<=instr_dc_i[14:12];
            word_32_dc_o<=word_32_dc;
        end
    end

endmodule
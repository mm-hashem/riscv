module controller
    import definitions_pkg::*;
(
    input  opcode_e    op_i,
    input  logic [2:0] funct3_i,
    input  logic       funct7_5_i,
`ifdef ZBA
    input logic funct7_4_i, funct7_2_i,
`endif
`ifndef PIPELINE3
                       zero_i,             less_than_i,
`endif
    output logic       alu_src_o,          pc_src_o,
                       reg_write_o,        mem_write_o,
                       data_memory_sign_o, word_32_o,
`ifdef PIPELINE3
                       branch_o, jump_o,
`endif
    output logic [1:0] up_imm_src_o, result_src_o,
                       data_memory_size_o,
    output imm_src_e   imm_src_o,
    output alu_e       alu_control_o
);

    logic [1:0] alu_op;

    main_decoder main_decoder_inst (
        .op_i       (op_i),
        .alu_src_o  (alu_src_o),     .result_src_o(result_src_o), .reg_write_o(reg_write_o),
        .mem_write_o(mem_write_o),   .branch_o    (branch_o),       .jump_o     (jump_o),
        .up_imm_src_o(up_imm_src_o), .imm_src_o  (imm_src_o),   .alu_op_o    (alu_op), .word_32_o(word_32_o)
    );

    alu_decoder alu_decoder_inst (
        .alu_op_i     (alu_op),
        .funct3_i     (funct3_i),
        .op_5_i       (op_i[5]), .funct7_5_i(funct7_5_i),
`ifdef ZBA
        .funct7_4_i(funct7_4_i), .funct7_2_i(funct7_2_i),
`endif
        .alu_control_o(alu_control_o)
    );

`ifndef PIPELINE3
    // the equation is not updated to bltu and bgeu
    // Equivalent to
    // assign pc_src_o = jump | (branch & ((funct3_i[2] & (funct3_i[0] ^ less_than_i)) + (!funct3_i[2] & (funct3_i[0] ^ zero_i))));
    // Note that branch and jump are mutually exclusive
    always_comb begin
        case ({funct3_i, less_than_i, zero_i, branch_o, jump_o}) inside
            7'b???_?_?_0_1: pc_src_o = 1'b1; // jal
            7'b000_0_1_1_0: pc_src_o = 1'b1; // beq
            7'b001_?_0_1_0: pc_src_o = 1'b1; // bne
            7'b100_1_0_1_0: pc_src_o = 1'b1; // blt
            7'b101_0_1_1_0: pc_src_o = 1'b1; // bge
            7'b110_1_0_1_0: pc_src_o = 1'b1; // bltu
            7'b111_0_1_1_0: pc_src_o = 1'b1; // bgeu
            default       : pc_src_o = 1'b0;
        endcase
    end
`endif

    assign {data_memory_sign_o, data_memory_size_o} = funct3_i;
    
endmodule
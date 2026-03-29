module controller
    import types_pkg::*;
(
    input  opcode_e     op_i,
    input  logic [2:0]  funct3_i,
    input  logic [6:0]  funct7_i,
    output logic        reg_write_o, mem_write_o,
                        branch_o,    jump_o,
    output branch_op_e  branch_op_o,
    output imm_src_e    imm_src_o,
    output result_src_e result_src_o,
    output alu_src_a_e  alu_a_src_o,
    output alu_src_b_e  alu_b_src_o,
    output alu_e        alu_ctrl_o,
    output data_ctrl_t  data_ctrl_o
);

    alu_op_e alu_op;

    main_decoder main_decoder_inst (
        .op_i       (op_i),
        .alu_a_src_o(alu_a_src_o), .alu_b_src_o(alu_b_src_o), .result_src_o(result_src_o),
        .reg_write_o(reg_write_o), .mem_write_o(mem_write_o), .branch_o    (branch_o),
        .jump_o     (jump_o),      .imm_src_o  (imm_src_o),   .alu_op_o    (alu_op)
    );

    alu_decoder alu_decoder_inst (
        .alu_op_i  (alu_op),  .funct3_i(funct3_i),
        .op_5_i    (op_i[5]), .funct7_i(funct7_i),
        .alu_ctrl_o(alu_ctrl_o)
    );

    branch_decoder branch_decoder_inst (
        .funct3_i   (funct3_i),
        .branch_op_o(branch_op_o)
    );

    memory_control_unit memory_control_unit_inst (
        .mem_write_i(mem_write_o),
        .funct3_i   (funct3_i),
        .data_ctrl_o(data_ctrl_o)
    );
    
endmodule
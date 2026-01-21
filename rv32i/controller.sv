module controller
    import definitions_pkg::*;
(
    input  logic [6:0] op_i,
    input  logic [2:0] funct3_i,
    input  logic       funct7_i,
                       zero_i,
    output logic       alu_src_o,    pc_src_o,
                       reg_write_o,  mem_write_o,
    output logic [1:0] result_src_o, imm_src_o,
    output alu_t       alu_ctrl_o
);

    logic [1:0] alu_op;
    logic       branch;

    main_decoder main_decoder_inst (
        .op_i       (op_i),
        .alu_src_o  (alu_src_o),   .result_src_o(result_src_o), .reg_write_o(reg_write_o),
        .mem_write_o(mem_write_o), .branch_o    (branch),       .jump_o     (jump),
        .imm_src_o  (imm_src_o),   .alu_op_o    (alu_op)
    );

    alu_decoder alu_decoder_inst (
        .alu_op_i  (alu_op),
        .funct3_i  (funct3_i),
        .op_i      (op_i[5]), .funct7_i(funct7_i),
        .alu_ctrl_o(alu_ctrl_o)
    );

    assign pc_src_o = (zero_i & branch) | jump;
    
endmodule
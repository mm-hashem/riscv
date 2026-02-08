module main_decoder
    import definitions_pkg::*;
(
    input  opcode_e    op_i,
    output logic       reg_write_o,  alu_src_o, mem_write_o,
                       branch_o,     jump_o, word_32_o,
    output logic [1:0] up_imm_src_o, result_src_o, alu_op_o,
    output imm_src_e   imm_src_o
);

    logic [14:0] ctrl_signals;
    assign {reg_write_o,  imm_src_o, alu_src_o, mem_write_o,
            result_src_o, branch_o,  alu_op_o,  jump_o, up_imm_src_o, word_32_o} = ctrl_signals;

    always_comb begin
        unique case (op_i)
            OP_I_LOAD : ctrl_signals = 15'b1_000_1_0_01_0_00_0_xx_0; //x I load
            OP_I_ALU  : ctrl_signals = 15'b1_000_1_0_00_0_10_0_xx_0; // I alu
            OP_U_AUIPC: ctrl_signals = 15'b1_100_x_0_11_0_xx_0_01_0; //x U: auipc
            OP_S      : ctrl_signals = 15'b0_001_1_1_xx_0_00_0_xx_0; //x S
            OP_R      : ctrl_signals = 15'b1_xxx_0_0_00_0_10_0_xx_0; // R
            OP_U_LUI  : ctrl_signals = 15'b1_100_x_0_11_0_xx_0_00_0; //x U: lui
            OP_B      : ctrl_signals = 15'b0_010_0_0_xx_1_01_0_01_0; // B
            OP_I_JALR : ctrl_signals = 15'b1_000_x_0_10_0_xx_1_10_0; //x I: jalr
            OP_J_JAL  : ctrl_signals = 15'b1_011_x_0_10_0_xx_1_01_0; //x J
            OP_I_ECALL: ctrl_signals = 15'b0_xxx_x_0_xx_0_xx_0_xx_0; //x I: ecall
`ifdef RV64
            OP_I_ALU_W: ctrl_signals = 15'b1_000_1_0_00_0_10_0_xx_1; // I w
            OP_R_W    : ctrl_signals = 15'b1_xxx_0_0_00_0_10_0_xx_1; // R w
`endif
            default   : ctrl_signals = 15'bx_xxx_x_x_xx_x_xx_x_xx_x;
        endcase
    end
    
endmodule
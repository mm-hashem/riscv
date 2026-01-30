module main_decoder
    import definitions_pkg::*;
(
    input  opcode_e    op_i,
    output logic       reg_write_o,  alu_src_o, mem_write_o,
                       branch_o,     jump_o,
    output logic [1:0] up_imm_src_o, result_src_o, alu_op_o,
    output imm_src_e   imm_src_o
);

    logic [13:0] ctrl_signals;
    assign {reg_write_o,  imm_src_o, alu_src_o, mem_write_o,
            result_src_o, branch_o,  alu_op_o,  jump_o, up_imm_src_o} = ctrl_signals;

    always_comb begin
        unique case (op_i)
            OP_I_LOAD : ctrl_signals = 14'b1_000_1_0_01_0_00_0_xx; // I load
            OP_I_ALU  : ctrl_signals = 14'b1_000_1_0_00_0_10_0_xx; // I alu
            OP_U_AUIPC: ctrl_signals = 14'b1_100_x_0_11_0_xx_0_01; // U: auipc
            OP_S      : ctrl_signals = 14'b0_001_0_1_xx_0_00_0_xx; // S
            OP_R      : ctrl_signals = 14'b1_xxx_0_0_00_0_10_0_xx; // R
            OP_U_LUI  : ctrl_signals = 14'b1_100_x_0_11_0_xx_0_00; // U: lui
            OP_B      : ctrl_signals = 14'b0_010_0_0_xx_1_01_0_01; // B
            OP_I_JALR : ctrl_signals = 14'b1_000_x_0_10_0_xx_1_10; // I: jalr
            OP_J_JAL  : ctrl_signals = 14'b1_011_x_0_10_0_xx_1_01; // J
            OP_I_ECALL: ctrl_signals = 14'b0_xxx_x_0_xx_0_xx_0_xx; // I: ecall
            default   : ctrl_signals = 14'bx_xxx_x_x_xx_x_xx_x_xx;
        endcase
    end
    
endmodule
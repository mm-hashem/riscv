module main_decoder
(
    input  logic [6:0] op_i,
    output logic       reg_write_o,  alu_src_o, mem_write_o,
                       branch_o,     jump_o,
    output logic [1:0] result_src_o, imm_src_o, alu_op_o
);

    logic [10:0] ctrl_signals;
    assign {reg_write_o,  imm_src_o, alu_src_o, mem_write_o,
            result_src_o, branch_o,  alu_op_o,  jump_o} = ctrl_signals;

    always_comb begin
        unique case (op_i)
            7'b0110011: ctrl_signals = 11'b1_xx_0_0_00_0_10_0; // r-type
            7'b0000011: ctrl_signals = 11'b1_00_1_0_01_0_00_0; // lw
            7'b0100011: ctrl_signals = 11'b0_01_1_1_xx_0_00_0; // sw
            7'b1100011: ctrl_signals = 11'b0_10_0_0_xx_1_01_0; // beq
            7'b0010011: ctrl_signals = 11'b1_00_1_0_00_0_10_0; // i-type alu
            7'b1101111: ctrl_signals = 11'b1_11_x_0_10_0_xx_1; // jal
            default   : ctrl_signals = 11'bx_xx_x_x_xx_x_xx_x;
        endcase
    end
    
endmodule
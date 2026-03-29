module main_decoder
    import types_pkg::*;
(
    input  opcode_e     op_i,
    output logic        branch_o,    jump_o,
                        reg_write_o, mem_write_o,
    output alu_src_a_e  alu_a_src_o,
    output alu_src_b_e  alu_b_src_o,
    output result_src_e result_src_o,
    output alu_op_e     alu_op_o,
    output imm_src_e    imm_src_o
);

    always_comb begin
        unique case (op_i)

            OP_I_LOAD: begin
                reg_write_o  = 1'b1;
                imm_src_o    = IMM_I;
                alu_op_o     = ALUOP_ADD;
                alu_a_src_o  = SRCA_RS1;
                alu_b_src_o  = SRCB_IMM;
                mem_write_o  = 1'b0;
                branch_o     = 1'b0;
                jump_o       = 1'b0;
                result_src_o = RESULT_MEMORY;
            end

            OP_I_ALU: begin
                reg_write_o  = 1'b1;
                imm_src_o    = IMM_I;
                alu_op_o     = ALUOP_REGULAR;
                alu_a_src_o  = SRCA_RS1;
                alu_b_src_o  = SRCB_IMM;
                mem_write_o  = 1'b0;
                branch_o     = 1'b0;
                jump_o       = 1'b0;
                result_src_o = RESULT_ALU;
            end

            OP_S: begin
                reg_write_o  = 1'b0;
                imm_src_o    = IMM_S;
                alu_op_o     = ALUOP_ADD;
                alu_a_src_o  = SRCA_RS1;
                alu_b_src_o  = SRCB_IMM;
                mem_write_o  = 1'b1;
                branch_o     = 1'b0;
                jump_o       = 1'b0;
                result_src_o = RESULT_ALU;
            end

            OP_R: begin
                reg_write_o  = 1'b1;
                imm_src_o    = IMM_I;
                alu_op_o     = ALUOP_REGULAR;
                alu_a_src_o  = SRCA_RS1;
                alu_b_src_o  = SRCB_RS2;
                mem_write_o  = 1'b0;
                branch_o     = 1'b0;
                jump_o       = 1'b0;
                result_src_o = RESULT_ALU;
            end

            OP_U_AUIPC: begin
                reg_write_o  = 1'b1;
                imm_src_o    = IMM_U;
                mem_write_o  = 1'b0;
                result_src_o = RESULT_ALU;
                branch_o     = 1'b0;
                alu_op_o     = ALUOP_ADD;
                jump_o       = 1'b0;
                alu_a_src_o  = SRCA_PC;
                alu_b_src_o  = SRCB_IMM;
            end

            OP_U_LUI: begin
                reg_write_o  = 1'b1;
                imm_src_o    = IMM_U;
                mem_write_o  = 1'b0;
                result_src_o = RESULT_ALU;
                branch_o     = 1'b0;
                alu_op_o     = ALUOP_ADD;
                jump_o       = 1'b0;
                alu_a_src_o  = SRCA_0;
                alu_b_src_o  = SRCB_IMM;
            end

            OP_B: begin
                reg_write_o  = 1'b0;
                imm_src_o    = IMM_B;
                mem_write_o  = 1'b0;
                result_src_o = RESULT_ALU;
                branch_o     = 1'b1;
                alu_op_o     = ALUOP_BRANCH;
                jump_o       = 1'b0;
                alu_a_src_o  = SRCA_RS1;
                alu_b_src_o  = SRCB_RS2;
            end

            OP_I_JALR: begin
                reg_write_o  = 1'b1;
                mem_write_o  = 1'b0;
                imm_src_o    = IMM_I;
                result_src_o = RESULT_PC4;
                branch_o     = 1'b0;
                jump_o       = 1'b1;
                alu_op_o     = ALUOP_ADD;
                alu_a_src_o  = SRCA_RS1;
                alu_b_src_o  = SRCB_IMM;
            end

            OP_J: begin
                reg_write_o  = 1'b1;
                mem_write_o  = 1'b0;
                imm_src_o    = IMM_J;
                result_src_o = RESULT_PC4;
                branch_o     = 1'b0;
                jump_o       = 1'b1;
                alu_op_o     = ALUOP_ADD;
                alu_a_src_o  = SRCA_PC;
                alu_b_src_o  = SRCB_IMM;
            end

            OP_I_ALU_W: begin
                reg_write_o  = 1'b1;
                imm_src_o    = IMM_I;
                alu_b_src_o  = SRCB_IMM;
                mem_write_o  = 1'b0;
                result_src_o = RESULT_ALU;
                branch_o     = 1'b0;
                alu_op_o     = ALUOP_WORD;
                jump_o       = 1'b0;
                alu_a_src_o  = SRCA_RS1;
            end

            OP_R_W: begin
                reg_write_o  = 1'b1;
                imm_src_o    = IMM_I;
                alu_b_src_o  = SRCB_RS2;
                mem_write_o  = 1'b0;
                result_src_o = RESULT_ALU;
                branch_o     = 1'b0;
                alu_op_o     = ALUOP_WORD;
                jump_o       = 1'b0;
                alu_a_src_o  = SRCA_RS1;
            end

            default: begin
                reg_write_o  = 1'b0;
                imm_src_o    = IMM_I;
                alu_b_src_o  = SRCB_RS2;
                mem_write_o  = 1'b0;
                result_src_o = RESULT_ALU;
                branch_o     = 1'b0;
                alu_op_o     = ALUOP_ADD;
                jump_o       = 1'b0;
                alu_a_src_o  = SRCA_RS1;
            end
        endcase
    end

endmodule
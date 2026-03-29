module alu_decoder
    import funct_pkg::*;
    import config_pkg::*;
    import types_pkg::*;
(
    input  alu_op_e    alu_op_i,
    input  logic [2:0] funct3_i,
    input  logic       op_5_i,
    input  logic [6:0] funct7_i,
    output alu_e       alu_ctrl_o
);

    always_comb begin : ALUDecoder
        unique case (alu_op_i)

            ALUOP_ADD: alu_ctrl_o = ALU_ADD; // I Load, I W Load, S, U: lui, auipc

            ALUOP_BRANCH: begin
                unique case (funct3_i)
                    F3_BEQ,  F3_BNE : alu_ctrl_o = ALU_SUB;  // B: beq,  bne
                    F3_BLT,  F3_BGE : alu_ctrl_o = ALU_SLT;  // B: blt,  bge
                    F3_BLTU, F3_BGEU: alu_ctrl_o = ALU_SLTU; // B: bltu, bgeu
                    default         : alu_ctrl_o = ALU_ADD;
                endcase
            end

            ALUOP_REGULAR: begin
                
                unique case (funct3_i)

                    3'b000: begin
                        if (!op_5_i || !funct7_i[5])
                            alu_ctrl_o = ALU_ADD; // R: add, I ALU: addi
                        else if (op_5_i && funct7_i[5])
                            alu_ctrl_o = ALU_SUB; // R: sub
                        else
                            alu_ctrl_o = ALU_ADD;
                    end

                    3'b001: alu_ctrl_o = ALU_SLL;  // R: sll, I ALU: slli

                    3'b010: begin
                        if (!op_5_i || !funct7_i[4])
                            alu_ctrl_o = ALU_SLT; // R: slt, I ALU: slti
                        else if (op_5_i && funct7_i[4])
                            alu_ctrl_o = CFG_ZBA ? ALU_SH1ADD : ALU_ADD; // R: sh1add
                        else
                            alu_ctrl_o = ALU_ADD;
                    end

                    3'b011: alu_ctrl_o = ALU_SLTU; // R: sltu, I ALU: sltiu

                    3'b100: begin
                        if (!op_5_i || !funct7_i[4])
                            alu_ctrl_o = ALU_XOR; // R: xor, I ALU: xori
                        else if (op_5_i && funct7_i[4])
                            alu_ctrl_o = CFG_ZBA ? ALU_SH2ADD : ALU_ADD; // R: sh2add
                        else
                            alu_ctrl_o = ALU_ADD;
                    end

                    3'b101: begin
                        unique case (funct7_i[5])
                            1'b0   : alu_ctrl_o = ALU_SRL;  // R: srl, I ALU: srli
                            1'b1   : alu_ctrl_o = ALU_SRA;  //# R: sra, I ALU: srai
                            default: alu_ctrl_o = ALU_ADD;
                        endcase
                    end

                    3'b110: begin
                        if (!op_5_i || !funct7_i[4])
                            alu_ctrl_o = ALU_OR; // R: or, I ALU: ori
                        else if (op_5_i && funct7_i[4])
                            alu_ctrl_o = CFG_ZBA ? ALU_SH3ADD : ALU_ADD; // R: sh3add
                        else
                            alu_ctrl_o = ALU_ADD;
                    end

                    3'b111: alu_ctrl_o = ALU_AND; // R: and, I ALU: andi

                    default: alu_ctrl_o = ALU_ADD;
                endcase
            end

            ALUOP_WORD: begin
                unique case (funct3_i)
                
                    3'b000: begin
                        if (!op_5_i || (!funct7_i[5] && !funct7_i[2]))
                            alu_ctrl_o = ALU_ADDW; // R W: addw, I ALU W: addiw
                        else if (op_5_i && funct7_i[5] && !funct7_i[2])
                            alu_ctrl_o = ALU_SUBW; // R W: subw
                        else if (op_5_i && !funct7_i[5] && funct7_i[2])
                            alu_ctrl_o = CFG_ZBA ? ALU_ADDUW : ALU_ADD; // R W: add.uw
                        else
                            alu_ctrl_o = ALU_ADD;
                    end

                    3'b001: begin
                        if (op_5_i)
                            alu_ctrl_o = ALU_SLLW; // R W: sllw
                        else if (!op_5_i && !funct7_i[2])
                            alu_ctrl_o = ALU_SLLW; // I ALU W: slliw
                        else if (!op_5_i && funct7_i[2])
                            alu_ctrl_o = CFG_ZBA ? ALU_SLLUW : ALU_ADD; // I ALU W: slli.uw
                        else
                            alu_ctrl_o = ALU_ADD;
                    end

                    3'b010: alu_ctrl_o = CFG_ZBA ? ALU_SH1ADDUW: ALU_ADD; // R W: sh1add.uw
                    3'b100: alu_ctrl_o = CFG_ZBA ? ALU_SH2ADDUW: ALU_ADD; // R W: sh2add.uw

                    3'b101: begin
                        unique case (funct7_i[5])
                            1'b0   : alu_ctrl_o = ALU_SRLW; // R W: srlw, I ALU W: srliw
                            1'b1   : alu_ctrl_o = ALU_SRAW; // R W: sraw, I ALU W: sraiw
                            default: alu_ctrl_o = ALU_ADD;
                        endcase
                    end

                    3'b110: alu_ctrl_o = CFG_ZBA ? ALU_SH3ADDUW: ALU_ADD; // R W: sh3add.uw

                    default: alu_ctrl_o = ALU_ADD;
                endcase
            end
            default: alu_ctrl_o = ALU_ADD;
        endcase
    end : ALUDecoder

endmodule
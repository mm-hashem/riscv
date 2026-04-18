module alu
    import config_pkg::*;
    import types_pkg::*;
(
    input  alu_e   alu_ctrl_i,
    input  xlen_st src_a_i, src_b_i,
    output logic   zero_o,
    output xlen_st alu_result_o
);

    localparam SHAMT  = (CFG_XLEN == 64) ? 6 : 5;
    localparam SHAMTW = SHAMT - 1;

    always_comb begin
        unique case (alu_ctrl_i)
            ALU_ADD : alu_result_o = src_a_i + src_b_i; // I Load, I W Load, S, I ALU: addi, R: add, U: lui, auipc
            ALU_SUB : alu_result_o = src_a_i - src_b_i; // R: sub, B: beq, bne
            ALU_AND : alu_result_o = src_a_i & src_b_i; // R: and, I ALU: andi
            ALU_OR  : alu_result_o = src_a_i | src_b_i; // R: or,  I ALU: ori
            ALU_XOR : alu_result_o = src_a_i ^ src_b_i; // R: xor, I ALU: xori
            ALU_SLT : alu_result_o = src_a_i < src_b_i; // B: blt, bge, R: slt, I ALU: slti
            ALU_SLTU: alu_result_o = unsigned'(src_a_i) <   unsigned'(src_b_i);            // B: bltu, bgeu, R: sltu, I ALU: sltiu
            ALU_SLL : alu_result_o =           src_a_i  <<  unsigned'(src_b_i[SHAMT-1:0]); // R: sll, I ALU: slli
            ALU_SRL : alu_result_o =           src_a_i  >>  unsigned'(src_b_i[SHAMT-1:0]); // R: srl, I ALU: srli
            ALU_SRA : alu_result_o =   signed'(src_a_i) >>> unsigned'(src_b_i[SHAMT-1:0]); // R: sra, I ALU: srai

            // RV64I Word instructions
            ALU_ADDW: alu_result_o = signed'(32'(src_a_i + src_b_i)); // R W: addw, I ALU W: addiw
            ALU_SUBW: alu_result_o = signed'(32'(src_a_i - src_b_i)); // R W: subw
            ALU_SLLW: alu_result_o = signed'(32'(        src_a_i[31:0]  <<  unsigned'(src_b_i[SHAMTW-1:0]))); // R W: sllw, I ALU W: slliw
            ALU_SRLW: alu_result_o = signed'(32'(        src_a_i[31:0]  >>  unsigned'(src_b_i[SHAMTW-1:0]))); // R W: srlw, I ALU W: srliw
            ALU_SRAW: alu_result_o = signed'(32'(signed'(src_a_i[31:0]) >>> unsigned'(src_b_i[SHAMTW-1:0]))); // R W: sraw, I ALU W: sraiw

            // Zba
            ALU_SH1ADD  : alu_result_o =           (src_a_i << 1)        + src_b_i; // R  : sh1add
            ALU_SH2ADD  : alu_result_o =           (src_a_i << 2)        + src_b_i; // R  : sh2add
            ALU_SH3ADD  : alu_result_o =           (src_a_i << 3)        + src_b_i; // R  : sh3add
            ALU_ADDUW   : alu_result_o =  unsigned'(src_a_i[31:0])       + src_b_i; // R W: add.uw
            ALU_SH1ADDUW: alu_result_o = (unsigned'(src_a_i[31:0]) << 1) + src_b_i; // R W: sh1add.uw
            ALU_SH2ADDUW: alu_result_o = (unsigned'(src_a_i[31:0]) << 2) + src_b_i; // R W: sh2add.uw
            ALU_SH3ADDUW: alu_result_o = (unsigned'(src_a_i[31:0]) << 3) + src_b_i; // R W: sh3add.uw
            ALU_SLLUW   : alu_result_o =  unsigned'(src_a_i[31:0]) << unsigned'(src_b_i[SHAMT-1:0]); // I ALU W: slli.uw

            default: alu_result_o = 'x;
        endcase
    end

    assign zero_o = alu_result_o == '0;
    
endmodule
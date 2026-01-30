module alu_decoder
    import definitions_pkg::*;
(
    input  logic [1:0] alu_op_i,
    input  logic [2:0] funct3_i,
    input  logic       op_5_i, funct7_5_i,
    output alu_e       alu_control_o
);

    always_comb begin
        case ({alu_op_i, funct3_i, op_5_i, funct7_5_i}) inside
            7'b10_000_0_?,                           // I: addi
            7'b10_000_1_0,                           // R: add
            7'b00_???_?_?: alu_control_o = ALU_ADD ; // I: load, S 
            7'b10_000_1_1,                           // R: sub
            7'b01_00?_1_?: alu_control_o = ALU_SUB ; // B: beq,  bne
            7'b10_111_?_?: alu_control_o = ALU_AND ; // R: and,  I: andi
            7'b10_110_?_?: alu_control_o = ALU_OR  ; // R: or,   I: ori
            7'b01_10?_1_?,                           // B: blt,  bge
            7'b10_010_?_?: alu_control_o = ALU_SLT ; // R: slt,  I: slti
            7'b10_100_?_?: alu_control_o = ALU_XOR ; // R: xor,  I: xori
            7'b10_001_?_?: alu_control_o = ALU_SLL ; // R: sll,  I: slli
            7'b10_101_?_0: alu_control_o = ALU_SRL ; // R: srl,  I: srli
            7'b10_101_?_1: alu_control_o = ALU_SRA ; // R: sra,  I: srai
            7'b01_11?_1_?,                           // B: bltu, bgeu
            7'b10_011_?_?: alu_control_o = ALU_SLTU; // R: sltu, I: sltiu
            default      : alu_control_o = alu_e'('x);
        endcase
    end
    
endmodule
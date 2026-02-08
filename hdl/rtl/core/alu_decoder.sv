module alu_decoder
    import definitions_pkg::*;
(
    input  logic [1:0] alu_op_i,
    input  logic [2:0] funct3_i,
    input  logic       op_5_i, funct7_5_i, funct7_4_i,funct7_2_i,
    output alu_e       alu_control_o
);

    always_comb begin
        case ({alu_op_i, funct3_i, op_5_i, funct7_5_i, funct7_4_i, funct7_2_i}) inside
            9'b10_000_0_?_?_x,                           // I: addi
            9'b10_000_1_0_?_0,                           // R: add, addw
            9'b00_???_?_?_?_x: alu_control_o = ALU_ADD ; // I: load, S 
            9'b10_000_1_1_?_x,                           // R: sub
            9'b01_00?_1_?_?_x: alu_control_o = ALU_SUB ; // B: beq,  bne
            9'b10_111_?_?_?_x: alu_control_o = ALU_AND ; // R: and,  I: andi
            9'b10_110_1_0_0_x,                           // R: or
            9'b10_110_0_?_0_x: alu_control_o = ALU_OR  ; // I: ori
            9'b01_10?_1_?_?_x,                           // B: blt,  bge
            9'b10_010_1_0_0_0,                           // R: slt
            9'b10_010_0_?_0_?: alu_control_o = ALU_SLT ; // I: slti
            9'b10_100_1_0_0_x,                           // R: xor
            9'b10_100_0_?_0_x: alu_control_o = ALU_XOR ; // I: xori
            9'b10_001_?_?_?_x: alu_control_o = ALU_SLL ; // R: sll,  I: slli
            9'b10_101_?_0_?_x: alu_control_o = ALU_SRL ; // R: srl,  I: srli
            9'b10_101_?_1_?_x: alu_control_o = ALU_SRA ; // R: sra,  I: srai
            9'b01_11?_1_?_?_x,                           // B: bltu, bgeu
            9'b10_011_?_?_?_x: alu_control_o = ALU_SLTU; // R: sltu, I: sltiu
`ifdef ZBA
            9'b10_000_1_0_?_1: alu_control_o = ALU_SH0ADD; // Rw: add.uw
            9'b10_010_1_0_1_0: alu_control_o = ALU_SH1ADD; // R : sh1add, Rw: sh1add.uw
            9'b10_100_1_0_1_0: alu_control_o = ALU_SH2ADD; // R : sh2add, Rw: sh2add.uw
            9'b10_110_1_0_1_0: alu_control_o = ALU_SH3ADD; // R : sh3add, Rw: sh3add.uw
`endif
            default      : alu_control_o = alu_e'('x);
        endcase
    end
    
endmodule
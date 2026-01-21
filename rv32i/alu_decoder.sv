module alu_decoder
    import definitions_pkg::*;
(
    input  logic [1:0] alu_op_i,
    input  logic [2:0] funct3_i,
    input  logic       op_i, funct7_i,
    output alu_t       alu_ctrl_o
);

    always_comb begin
        case ({alu_op_i, funct3_i, op_i, funct7_i}) inside
            7'b00_???_??,
            7'b10_000_0?,
            7'b10_000_10: alu_ctrl_o = ADD; // lw, sw, add
            7'b01_???_??,
            7'b10_000_11: alu_ctrl_o = SUB; // sub, beq
            7'b10_010_??: alu_ctrl_o = SLT; // slt
            7'b10_110_??: alu_ctrl_o = OR ; // or
            7'b10_111_??: alu_ctrl_o = AND; // and
            7'b10_100_10: alu_ctrl_o = XOR; // xor
            7'b10_001_00: alu_ctrl_o = SLL; // sll
            default     : alu_ctrl_o = alu_t'(3'bxxx);
        endcase
    end
    
endmodule
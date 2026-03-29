module branch_decoder
    import funct_pkg::*;
    import types_pkg::*;
(
    input  logic [2:0] funct3_i,
    output branch_op_e branch_op_o
);

    // Generates branch op for pc control unit
    always_comb begin : BranchOp
        unique case (funct3_i)
            F3_BEQ : branch_op_o = BRANCH_EQ;
            F3_BNE : branch_op_o = BRANCH_NE;
            F3_BLT,
            F3_BLTU: branch_op_o = BRANCH_LT;
            F3_BGE,
            F3_BGEU: branch_op_o = BRANCH_GE;
            default: branch_op_o = BRANCH_EQ;
        endcase
    end : BranchOp

    
endmodule
module stage3_cp
    import definitions_pkg::*;
(
    input logic branch_s3_i, jump_s3_i,
    input logic [2:0] funct3_s3_i,
    output logic pc_src_s3_o,
    input logic zero_s3_i, less_than_s3_i
);

    always_comb begin
        case ({funct3_s3_i, less_than_s3_i, zero_s3_i, branch_s3_i, jump_s3_i}) inside
            7'b???_?_?_0_1: pc_src_s3_o = 1'b1; // jal
            7'b000_0_1_1_0: pc_src_s3_o = 1'b1; // beq
            7'b001_?_0_1_0: pc_src_s3_o = 1'b1; // bne
            7'b100_1_0_1_0: pc_src_s3_o = 1'b1; // blt
            7'b101_0_1_1_0: pc_src_s3_o = 1'b1; // bge
            7'b110_1_0_1_0: pc_src_s3_o = 1'b1; // bltu
            7'b111_0_1_1_0: pc_src_s3_o = 1'b1; // bgeu
            default       : pc_src_s3_o = 1'b0;
        endcase
    end
    
endmodule
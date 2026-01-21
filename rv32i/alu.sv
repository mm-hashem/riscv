module alu
    import definitions_pkg::*;
(
    input  alu_t   alu_ctrl_i,
    input  word_st src_a_i, src_b_i,
    output logic   zero_o,
    output word_st alu_result_o
);

    always_comb begin
        unique case (alu_ctrl_i)
            ADD:     alu_result_o = src_a_i  + src_b_i;
            SUB:     alu_result_o = src_a_i  - src_b_i;
            SLT:     alu_result_o = src_a_i  < src_b_i; // signed
            OR :     alu_result_o = src_a_i  | src_b_i;
            AND:     alu_result_o = src_a_i  & src_b_i;
            XOR:     alu_result_o = src_a_i  ^ src_b_i;
            SLL:     alu_result_o = src_a_i << src_b_i;
            default: alu_result_o = 32'sh0;
        endcase
    end
    
    assign zero_o = (alu_result_o == 32'sh0) ? 1'b1 : 1'b0;

endmodule
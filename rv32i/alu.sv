module alu
    import definitions_pkg::*;
(
    input  alu_e   alu_control_i,
    input  word_st src_a_i, src_b_i,
    output logic   zero_o,
    output word_st alu_result_o
);

    always_comb begin
        unique case (alu_control_i)
            ALU_ADD : alu_result_o = src_a_i +   src_b_i;
            ALU_SUB : alu_result_o = src_a_i -   src_b_i;
            ALU_SLT : alu_result_o = src_a_i <   src_b_i;
            ALU_OR  : alu_result_o = src_a_i |   src_b_i;
            ALU_AND : alu_result_o = src_a_i &   src_b_i;
            ALU_XOR : alu_result_o = src_a_i ^   src_b_i;
            ALU_SLL : alu_result_o = src_a_i <<  unsigned'(src_b_i[4:0]);
            ALU_SRL : alu_result_o = src_a_i >>  unsigned'(src_b_i[4:0]);
            ALU_SRA : alu_result_o = src_a_i >>> unsigned'(src_b_i[4:0]);
            ALU_SLTU: alu_result_o = unsigned'(src_a_i) < unsigned'(src_b_i);
            default : alu_result_o = 32'sh0;
        endcase
    end
    
    assign zero_o = alu_result_o == 32'sh0;
    
endmodule
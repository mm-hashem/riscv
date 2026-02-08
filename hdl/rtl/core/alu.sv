module alu
    import definitions_pkg::*;
(
    input  alu_e   alu_control_i,
    input  word_st src_a_i, src_b_i,
    input logic word_32_i,
    output logic   zero_o,
    output word_st alu_result_o
);

    word_st alu_result, src_b, src_a;

`ifdef RV64
    always_comb begin
        if   (word_32_i && alu_control_i inside {ALU_SLL, ALU_SRL, ALU_SRA}) src_b = {1'b0, src_b_i[4:0]};
        else                                                                 src_b = src_b_i;
    end
`else
    assign src_b = src_b_i;
`endif

`ifdef ZBA
    always_comb begin
        if (word_32_i && alu_control_i inside {ALU_SH0ADD, ALU_SH1ADD, ALU_SLL,
                                               ALU_SH2ADD, ALU_SH3ADD}) src_a = unsigned'(src_a_i[31:0]);
        else                                                            src_a = src_a_i;
    end
`else
    assign src_a = src_a_i;
`endif

    always_comb begin
        unique case (alu_control_i)
            ALU_ADD : alu_result = src_a  + src_b;
            ALU_SUB : alu_result = src_a  - src_b;
            ALU_SLT : alu_result = src_a  < src_b;
            ALU_OR  : alu_result = src_a  | src_b;
            ALU_AND : alu_result = src_a  & src_b;
            ALU_XOR : alu_result = src_a  ^ src_b;
            ALU_SLTU: alu_result = unsigned'(src_a) < unsigned'(src_b);
`ifdef RV64
            ALU_SLL : alu_result = src_a <<  unsigned'(src_b[5:0]);
            ALU_SRL : alu_result = src_a >>  unsigned'(src_b[5:0]);
            ALU_SRA : alu_result = src_a >>> unsigned'(src_b[5:0]);
`else
            ALU_SLL : alu_result = src_a <<  unsigned'(src_b[4:0]);
            ALU_SRL : alu_result = src_a >>  unsigned'(src_b[4:0]);
            ALU_SRA : alu_result = src_a >>> unsigned'(src_b[4:0]);
`endif
`ifdef ZBA
            ALU_SH0ADD: alu_result =  src_a       + src_b;
            ALU_SH1ADD: alu_result = (src_a << 1) + src_b;
            ALU_SH2ADD: alu_result = (src_a << 2) + src_b;
            ALU_SH3ADD: alu_result = (src_a << 3) + src_b;
`endif
            default : alu_result = 'x;
        endcase
    end

    always_comb begin
        if (word_32_i && !(alu_control_i inside {ALU_SH0ADD, ALU_SH1ADD, ALU_SLL,
                                                 ALU_SH2ADD, ALU_SH3ADD})) alu_result_o = signed'(alu_result[31:0]);
        else                                                               alu_result_o = alu_result;
    end
    
    assign zero_o = alu_result_o == '0;
    
endmodule
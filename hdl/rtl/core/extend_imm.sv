module extend_imm
    import definitions_pkg::*;
(
    input  imm_src_e imm_src_i,
    input  word_32ut   instr_i,
    output word_st   imm_ext_o
);

    always_comb begin
        unique case (imm_src_i)
            IMM_I:   imm_ext_o = signed'({ {instr_i[31]}, instr_i[31:20] });                                       // I
            IMM_S:   imm_ext_o = signed'({ {instr_i[31]}, instr_i[31:25], instr_i[11:7] });                        // S
            IMM_B:   imm_ext_o = signed'({ {instr_i[31]}, instr_i[7],     instr_i[30:25], instr_i[11: 8], 1'b0 }); // B
            IMM_J:   imm_ext_o = signed'({ {instr_i[31]}, instr_i[19:12], instr_i[20],    instr_i[30:21], 1'b0 }); // J
            IMM_U:   imm_ext_o = { instr_i[31:12], {12{1'b0}} };                                          // U
            default: imm_ext_o = 'x;
        endcase
    end
    
endmodule
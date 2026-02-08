module writeback
    import definitions_pkg::*;
(
    input logic [1:0] result_src_wb_i,
    input word_st alu_result_wb_i,     
            read_data_sized_wb_i,
            pc_next_4_wb_i,      
            pc_next_imm_wb_i,
    output word_st result_wb_o
);
    
     // ResultSrc Mux
    always_comb begin : ResultSrcMux
        unique case (result_src_wb_i)
            2'b00:   result_wb_o = alu_result_wb_i;
            2'b01:   result_wb_o = read_data_sized_wb_i;
            2'b10:   result_wb_o = pc_next_4_wb_i;
            2'b11:   result_wb_o = pc_next_imm_wb_i;
            default: result_wb_o = 32'b0;
        endcase
    end : ResultSrcMux

endmodule
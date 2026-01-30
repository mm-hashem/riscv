module extend_write_data
    import definitions_pkg::*;
(
    input  word_st       write_data_i,
    input  logic   [2:0] funct3_i,
    output word_st       write_data_sized_o
);
    
    always_comb begin
        unique case (funct3_i)
            3'b000 : write_data_sized_o = unsigned'(write_data_i[ 7:0]);
            3'b001 : write_data_sized_o = unsigned'(write_data_i[15:0]);
            3'b010 : write_data_sized_o = write_data_i;
            default: write_data_sized_o = 32'bx;
        endcase        
    end

endmodule
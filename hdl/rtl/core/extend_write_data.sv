module extend_write_data
    import definitions_pkg::*;
(
    input  word_st       write_data_i,
    input  logic   [1:0] data_memory_size_i,
    output word_st       write_data_sized_o,
    output logic [3:0] byte_en_o
);
    
    always_comb begin
        unique case (data_memory_size_i)
            2'b00: begin // sb
                write_data_sized_o = write_data_i[ 7:0];
                byte_en_o = 4'b0001;
            end
            2'b01: begin // sh
                write_data_sized_o = write_data_i[15:0];
                byte_en_o = 4'b0011;
            end
            2'b10: begin // sw
                write_data_sized_o = write_data_i[31:0];
                byte_en_o = 4'b0111;
            end
`ifdef RV64
            2'b11: begin // sd
                write_data_sized_o = write_data_i;
                byte_en_o = 4'b1111;
            end
`endif
            default: begin
                write_data_sized_o = 'x;
                byte_en_o = 'x;
            end
        endcase        
    end

endmodule
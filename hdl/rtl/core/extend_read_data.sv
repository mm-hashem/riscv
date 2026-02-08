module extend_read_data
    import definitions_pkg::*;
(
    input  word_st       read_data_i,
    input  logic         data_memory_sign_i,
    input  logic   [1:0] data_memory_size_i,
    output word_st       read_data_sized_o
);
    
    always_comb begin
        unique case ({data_memory_sign_i, data_memory_size_i})
            3'b000 : read_data_sized_o = read_data_i[ 7:0];            // lb  SignExtended
            3'b001 : read_data_sized_o = read_data_i[15:0];            // lh  SignExtended
            3'b010 : read_data_sized_o = read_data_i[31:0];            // lw  SignExtended
            3'b100 : read_data_sized_o = unsigned'(read_data_i[ 7:0]); // lbu ZeroExtended
            3'b101 : read_data_sized_o = unsigned'(read_data_i[15:0]); // lhu ZeroExtended
`ifdef RV64
            3'b011 : read_data_sized_o = read_data_i;                  // ld
            3'b110 : read_data_sized_o = unsigned'(read_data_i[31:0]); // lwu ZeroExtended
`endif
            default: read_data_sized_o = 32'bx;
        endcase
    end

endmodule
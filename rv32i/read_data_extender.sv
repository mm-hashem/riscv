module read_data_extender
    import definitions_pkg::*;
(
    input  word_st       read_data_i,
    input  logic   [2:0] funct3_i,
    output word_st       read_data_sized_o
);
    
    always_comb begin
        unique case (funct3_i)
            3'b000 : read_data_sized_o = read_data_i[ 7:0];
            3'b001 : read_data_sized_o = read_data_i[15:0];
            3'b100 : read_data_sized_o = { {24{1'b0}}, read_data_i[ 7:0]};
            3'b101 : read_data_sized_o = { {16{1'b0}}, read_data_i[15:0]};
            3'b010 : read_data_sized_o = read_data_i;
            default: read_data_sized_o = 32'bx;
        endcase        
    end

endmodule
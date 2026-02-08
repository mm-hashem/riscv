module data_ram
    import definitions_pkg::*;
(
    input      logic   clk_i, rst_i,
                       we_i,
    input logic [3:0] byte_en_i,
    input  var word_ut a_i,
    input      word_st wd_i,
    output     word_st rd_o
);
/*
 sb 0001
 sh 0011
 sw 0111
 sd 1111
*/

    logic [7:0] ram [DATA_ORG:DATA_END-1];

    initial $readmemh(FNAME_DATA, ram);

    always_ff @(posedge clk_i) begin
        if (we_i && !rst_i) begin 
            if(byte_en_i[0]) ram[a_i + 0] <= wd_i[ 7: 0];
            if(byte_en_i[1]) ram[a_i + 1] <= wd_i[15: 8]; 
            if(byte_en_i[2]) ram[a_i + 2] <= wd_i[23:16]; 
            if(byte_en_i[2]) ram[a_i + 3] <= wd_i[31:24]; 
`ifdef RV64
            if(byte_en_i[3]) ram[a_i + 4] <= wd_i[39:32];
            if(byte_en_i[3]) ram[a_i + 5] <= wd_i[47:40];
            if(byte_en_i[3]) ram[a_i + 6] <= wd_i[55:48];
            if(byte_en_i[3]) ram[a_i + 7] <= wd_i[63:56];
`endif
        end
    end

    always_comb begin
        rd_o[ 7: 0] = ram[a_i + 0];
        rd_o[15: 8] = ram[a_i + 1];
        rd_o[23:16] = ram[a_i + 2];
        rd_o[31:24] = ram[a_i + 3];
`ifdef RV64
        rd_o[39:32] = ram[a_i + 4];
        rd_o[47:40] = ram[a_i + 5];
        rd_o[55:48] = ram[a_i + 6];
        rd_o[63:56] = ram[a_i + 7];
`endif
    end

endmodule: data_ram
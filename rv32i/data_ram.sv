// This is not necessary synthesizable. 
module data_ram
    import definitions_pkg::*;
(
    input      logic   clk_i,
                       we_i,
    input  var word_ut a_i,
    input      word_st wd_i,
    output     word_st rd_o
);

    logic [7:0] ram [DATA_ORG:DATA_END-1];

    initial $readmemh(FNAME_DATA, ram);

    always_ff @(posedge clk_i)
        if (we_i) { << 8{ram[a_i+:4]} } <= wd_i;

    assign rd_o = { << 8{ram[a_i+:4]} };

endmodule: data_ram
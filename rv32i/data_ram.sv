// This is not necessary synthesizable. 
module data_ram
    import definitions_pkg::*;
(
    input  logic   clk_i, rst_i,
                   we_i,
    input  word_ut a_i,
    input  word_st wd_i,
    output word_st rd_o
);

    logic [7:0] ram [DATA_SIZE];

    initial $readmemh(FNAME_DATA, ram);

    always_ff @(posedge clk_i)
        if (we_i && !rst_i) {ram[a_i+3], ram[a_i+2], ram[a_i+1], ram[a_i]} <= wd_i;

    assign rd_o = {ram[a_i+3], ram[a_i+2], ram[a_i+1], ram[a_i]};

endmodule: data_ram
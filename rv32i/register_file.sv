module register_file
    import definitions_pkg::*;
#(
    parameter FILE_NAME = "regfile.mem"
) (
    input  logic        clk_i, rst_i,
                        we_3_i,
    input  logic  [4:0] a_1_i, a_2_i, a_3_i,
    input  word_st      wd_3_i,
    output word_st      rd_1_o, rd_2_o
);

    word_st regfile [32];

    initial $readmemh(FILE_NAME, regfile);

    always_ff @(posedge clk_i)
        if (we_3_i && !rst_i)
            if (a_3_i != '0)
                regfile[a_3_i] <= wd_3_i;

    assign rd_1_o = regfile[a_1_i];
    assign rd_2_o = regfile[a_2_i];

endmodule: register_file
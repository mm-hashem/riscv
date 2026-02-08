module register_file
    import definitions_pkg::*;
(
    input  logic   clk_i, rst_i,
                   rd_we_i,
    input  reg_e   rs1_a_i, rs2_a_i,
                   rd_a_i,
    input  word_st rd_d_i,
    output word_st rs1_d_o, rs2_d_o
);

    word_st regfile [0:31];

    initial $readmemh(FNAME_REGFILE, regfile);

`ifdef PIPELINE3
    always_ff @(negedge clk_i) begin
`else
    always_ff @(posedge clk_i) begin
`endif
        if (rd_we_i && !rst_i) begin
            if (rd_a_i == 5'b0)
                regfile[rd_a_i] <= {XLEN{1'b0}};
            else
                regfile[rd_a_i] <= rd_d_i;
        end
    end

    assign rs1_d_o = regfile[rs1_a_i];
    assign rs2_d_o = regfile[rs2_a_i];

endmodule : register_file
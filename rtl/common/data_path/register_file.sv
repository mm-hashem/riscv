module register_file
    import config_pkg::*;
    import types_pkg::*;
(
    input  logic   clk_i,
                   rd_we_i,
    input  reg_e   rs1_a_i, rs2_a_i,
                   rd_a_i,
    input  xlen_st rd_d_i,
    output xlen_st rs1_d_o, rs2_d_o
);

    xlen_st regfile [0:31];

    always_ff @(posedge clk_i)
        if (rd_we_i)
            regfile[rd_a_i] <= rd_d_i;

    generate
        if (CFG_CORE == SINGLE) begin
            assign rs1_d_o = (rs1_a_i == REG_ZERO) ? '0 : regfile[rs1_a_i];
            assign rs2_d_o = (rs2_a_i == REG_ZERO) ? '0 : regfile[rs2_a_i];
        end else if (CFG_CORE == STAGE5) begin
            assign rs1_d_o = (rs1_a_i == REG_ZERO) ? '0 : ((rd_we_i && (rd_a_i == rs1_a_i)) && (rd_a_i != REG_ZERO)) ? rd_d_i : regfile[rs1_a_i];
            assign rs2_d_o = (rs2_a_i == REG_ZERO) ? '0 : ((rd_we_i && (rd_a_i == rs2_a_i)) && (rd_a_i != REG_ZERO)) ? rd_d_i : regfile[rs2_a_i];
        end
    endgenerate

endmodule : register_file
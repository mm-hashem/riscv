module register_file
    import config_pkg::*;
    import types_pkg::*;
(
    input  logic   clk_i, rst_i,
                   rd_we_i,
    input  reg_e   rs1_a_i, rs2_a_i,
                   rd_a_i,
    input  xlen_st rd_d_i,
    output xlen_st rs1_d_o, rs2_d_o
);

    xlen_st regfile [0:31] = '{default:'0};

    generate
        if (CFG_CORE inside {STAGE3, STAGE5}) begin : PIPELINED_REGWR
            always_ff @(negedge clk_i)
                if (rd_we_i && !rst_i && !(rd_a_i == 5'b0))
                    regfile[rd_a_i] <= rd_d_i;
        end : PIPELINED_REGWR
        
        else if (CFG_CORE == SINGLE) begin : SINGLE_REGWR
            always_ff @(posedge clk_i)
                if (rd_we_i && !rst_i && !(rd_a_i == 5'b0))
                    regfile[rd_a_i] <= rd_d_i;
        end : SINGLE_REGWR
    endgenerate

    assign rs1_d_o = regfile[rs1_a_i];
    assign rs2_d_o = regfile[rs2_a_i];

endmodule : register_file
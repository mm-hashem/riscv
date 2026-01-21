module program_counter
    import definitions_pkg::*;
(
    input  logic   clk_i, rst_i,
                   pc_src_i,
    input  word_st pc_init_i, imm_ext_i,
    output word_st pc_o,      pc_next_o
);

    assign pc_next_o = pc_src_i ? pc_o + imm_ext_i : pc_o + 4;

    always_ff @(posedge clk_i)
        if (rst_i) pc_o <= pc_init_i; // Needs to be modified
        else       pc_o <= pc_next_o;
    
endmodule: program_counter
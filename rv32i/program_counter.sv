module program_counter
    import definitions_pkg::*;
(
    input  logic   clk_i, rst_i,
    input  word_st pc_init_i, pc_next_i,
    output word_st pc_o
);

    always_ff @(posedge clk_i)
        if (rst_i) pc_o <= pc_init_i;
        else       pc_o <= pc_next_i;
    
endmodule: program_counter
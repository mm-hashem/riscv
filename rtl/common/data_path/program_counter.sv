module program_counter
    import types_pkg::*;
(
    input  logic   clk_i, rst_i,
                   en_i,
    input  word_st pc_next_i,
    output word_st pc_o
);

    always_ff @(posedge clk_i)
        if      (rst_i) pc_o <= '0;
        else if (en_i)  pc_o <= pc_next_i;
    
endmodule: program_counter
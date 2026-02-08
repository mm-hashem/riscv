module memory_cp
    import definitions_pkg::*;
(
    input clk_i, rst_i,
    input logic [1:0] result_src_mr_i,
    input logic reg_write_mr_i,
    output logic reg_write_mr_o,
    output logic [1:0] result_src_mr_o
);


    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            result_src_mr_o <= '0;
            reg_write_mr_o <= '0;
        end else begin
            result_src_mr_o <= result_src_mr_i;
            reg_write_mr_o <= reg_write_mr_i;
        end
    end
    
endmodule
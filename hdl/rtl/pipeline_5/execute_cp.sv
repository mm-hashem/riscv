module execute_cp
    import definitions_pkg::*;
(
    input logic clk_i, rst_i,
    input logic zero_ex_i, jump_ex_i,
    branch_ex_i, less_than_ex_i,
    mem_write_ex_i, reg_write_ex_i,
    data_memory_sign_ex_i,
    input logic [2:0] funct3_ex_i,
    input logic [1:0] result_src_ex_i, data_memory_size_ex_i,
    output logic pc_src_ex_o, mem_write_ex_o, reg_write_ex_o, data_memory_sign_ex_o,
    output logic [1:0] result_src_ex_o, data_memory_size_ex_o
);

    always_comb begin
        case ({funct3_ex_i, less_than_ex_i, zero_ex_i, branch_ex_i, jump_ex_i}) inside
            7'b???_?_?_0_1: pc_src_ex_o = 1'b1; // jal
            7'b000_0_1_1_0: pc_src_ex_o = 1'b1; // beq
            7'b001_?_0_1_0: pc_src_ex_o = 1'b1; // bne
            7'b100_1_0_1_0: pc_src_ex_o = 1'b1; // blt
            7'b101_0_1_1_0: pc_src_ex_o = 1'b1; // bge
            7'b110_1_0_1_0: pc_src_ex_o = 1'b1; // bltu
            7'b111_0_1_1_0: pc_src_ex_o = 1'b1; // bgeu
            default       : pc_src_ex_o = 1'b0;
        endcase
    end
    
    always_ff @(posedge clk_i) begin
        if (rst_i) begin
            mem_write_ex_o <= '0;
            result_src_ex_o<='0;
            reg_write_ex_o <='0;
            data_memory_size_ex_o<='0;
            data_memory_sign_ex_o<='0;
        end else begin
            mem_write_ex_o <= mem_write_ex_i;
            result_src_ex_o<=result_src_ex_i;
            reg_write_ex_o<=reg_write_ex_i;
            data_memory_size_ex_o<=data_memory_size_ex_i;
            data_memory_sign_ex_o<=data_memory_sign_ex_i;
        end
    end

endmodule
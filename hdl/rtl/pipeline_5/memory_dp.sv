module memory_dp
    import definitions_pkg::*;
(
    input logic clk_i, rst_i,
    data_memory_sign_mr_i,
    mem_write_mr_i,
    input logic [1:0] data_memory_size_mr_i,

    input word_st rs2_d_mr_i,
    input word_st    pc_next_4_mr_i,
    pc_next_imm_mr_i,
    input word_st alu_result_mr_i,
    
    input reg_e rd_a_mr_i,

    output word_st alu_result_mr_o,
    output word_st read_data_sized_mr_o,pc_next_4_mr_o,pc_next_imm_mr_o,
    
    output reg_e rd_a_mr_o
);
    word_st write_data_sized_mr, read_data_mr, read_data_sized_mr;

    extend_write_data extend_write_data_mr_inst (
        .write_data_i      (rs2_d_mr_i),
        .data_memory_size_i(data_memory_size_mr_i),
        .write_data_sized_o(write_data_sized_mr)
    );

    data_ram data_ram_inst (
        .clk_i, .rst_i,
        .we_i(mem_write_mr_i),
        .a_i (alu_result_mr_i), .wd_i(write_data_sized_mr),
        .rd_o(read_data_mr)
    );

    extend_read_data extend_read_data_inst (
        .read_data_i       (read_data_mr),
        .data_memory_sign_i(data_memory_sign_mr_i),
        .data_memory_size_i(data_memory_size_mr_i),
        .read_data_sized_o (read_data_sized_mr)
    );

    always_ff @(posedge clk_i) begin : MemoryStageReg
        if (rst_i) begin
            pc_next_4_mr_o <= '0;
            pc_next_imm_mr_o <= '0;
            rd_a_mr_o <= REG_ZERO;
            read_data_sized_mr_o <='0;
            alu_result_mr_o <='0;
        end else begin
            pc_next_4_mr_o <= pc_next_4_mr_i;
            pc_next_imm_mr_o <= pc_next_imm_mr_i;
            rd_a_mr_o <= rd_a_mr_i;
            read_data_sized_mr_o<= read_data_sized_mr;
            alu_result_mr_o<= alu_result_mr_i;
        end
    end : MemoryStageReg

endmodule
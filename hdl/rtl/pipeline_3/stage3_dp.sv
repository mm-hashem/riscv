module stage3_dp
    import definitions_pkg::*;
(
    input logic clk_i, rst_i,
    alu_src_s3_i,data_memory_sign_s3_i, mem_write_s3_i, word_32_s3_i,
    input logic [1:0] result_src_s3_i, data_memory_size_s3_i,up_imm_src_s3_i,
    input alu_e alu_control_s3_i,
    input word_st pc_s3_i, pc_next_4_s3_i,
    rs1_d_s3_i, rs2_d_s3_i, imm_ext_s3_i,
    output word_st pc_next_imm_s3_o, result_s3_o,
    output logic zero_s3_o, less_than_s3_o
);

    word_st alu_result_s3, src_b_s3, write_data_sized_s3, read_data_s3, read_data_sized_s3;

    // Jump/Branch adder, used for U-type and dalr instructions instructions
    always_comb begin : JmpBrnAdderMux
        unique case (up_imm_src_s3_i)
            2'b00:   pc_next_imm_s3_o = signed'(imm_ext_s3_i);         // lui
            2'b01:   pc_next_imm_s3_o = pc_s3_i    + imm_ext_s3_i; // auipc
            2'b10:   pc_next_imm_s3_o = rs1_d_s3_i + imm_ext_s3_i; // jalr
            default: pc_next_imm_s3_o = 32'b0;
        endcase
    end : JmpBrnAdderMux

    // ALUSrc Mux
    assign src_b_s3 = alu_src_s3_i ? imm_ext_s3_i : rs2_d_s3_i;

    alu alu_s3_inst (
        .alu_control_i(alu_control_s3_i),
        .src_a_i      (rs1_d_s3_i), .src_b_i(src_b_s3),
        .word_32_i(word_32_s3_i),
        .zero_o       (zero_s3_o),
        .alu_result_o (alu_result_s3)
    );

    assign less_than_s3_o = alu_result_s3[0];

    logic [3:0] byte_en;

    extend_write_data extend_write_data_s3_inst (
        .write_data_i(rs2_d_s3_i),
        .data_memory_size_i(data_memory_size_s3_i),
        .write_data_sized_o(write_data_sized_s3),
        .byte_en_o(byte_en)
    );

    data_ram data_ram_s3_inst (
        .clk_i, .rst_i,
        .we_i(mem_write_s3_i), .byte_en_i(byte_en),
        .a_i (alu_result_s3), .wd_i(write_data_sized_s3),
        .rd_o(read_data_s3)
    );

    extend_read_data extend_read_data_s3_inst (
        .read_data_i       (read_data_s3),
        .data_memory_sign_i(data_memory_sign_s3_i),
        .data_memory_size_i(data_memory_size_s3_i),
        .read_data_sized_o (read_data_sized_s3)
    );

    // ResultSrc Mux
    always_comb begin : ResultSrcMux
        unique case (result_src_s3_i)
            2'b00:   result_s3_o = alu_result_s3;
            2'b01:   result_s3_o = read_data_sized_s3;
            2'b10:   result_s3_o = pc_next_4_s3_i;
            2'b11:   result_s3_o = pc_next_imm_s3_o;
            default: result_s3_o = 32'b0;
        endcase
    end : ResultSrcMux
    
endmodule
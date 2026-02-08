module decode_dp
    import definitions_pkg::*;
(
    input logic clk_i, rst_i,
                reg_write_dc_i, flush_s3_i,
    input word_32ut instr_dc_i,
    input word_st rd_d_dc_i,pc_dc_i,pc_next_4_dc_i,
    input imm_src_e imm_src_dc_i,
    output word_st rs1_d_dc_o, rs2_d_dc_o, imm_ext_dc_o,pc_dc_o,pc_next_4_dc_o
);

    word_st rs1_d_dc, rs2_d_dc, imm_ext_dc;
    reg_e rd_a_dc;

    register_file register_file_dc_inst (
        .clk_i, .rst_i,
        .rd_we_i(reg_write_dc_i),
        .rs1_a_i(reg_e'(instr_dc_i[19:15])), .rs2_a_i(reg_e'(instr_dc_i[24:20])), .rd_a_i(rd_a_dc),
        .rd_d_i (rd_d_dc_i),
        .rs1_d_o(rs1_d_dc), .rs2_d_o(rs2_d_dc)
    );

    extend_imm extend_imm_dc_inst (
        .imm_src_i(imm_src_dc_i),
        .instr_i  (instr_dc_i),
        .imm_ext_o(imm_ext_dc)
    );

    always_ff @(posedge clk_i) begin
        if (rst_i || flush_s3_i) begin
            rd_a_dc<=REG_ZERO;
            rs1_d_dc_o<='0;
            rs2_d_dc_o<='0;
            imm_ext_dc_o<='0;
            pc_next_4_dc_o<='0;
            pc_dc_o<='0;
        end else begin
            rs1_d_dc_o  <=rs1_d_dc;
            rs2_d_dc_o  <=rs2_d_dc;
            imm_ext_dc_o<=imm_ext_dc;
            pc_next_4_dc_o<=pc_next_4_dc_i;
            pc_dc_o<=pc_dc_i;
            rd_a_dc<=reg_e'(instr_dc_i[11:7]);
        end
        
    end

endmodule
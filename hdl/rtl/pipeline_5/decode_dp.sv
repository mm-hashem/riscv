module decode_dp
    import definitions_pkg::*;
(
    input  logic   clk_i, rst_i,
                   reg_write_dc_i,
                   flush_ex_i,
    input var imm_src_e imm_src_dc_i,
    input  wire word_32ut instr_dc_i,
    input  word_st result_dc_i,
                   pc_dc_i, pc_next_4_dc_i,
    input reg_e rd_a_dc_i,
    output word_st rs1_d_dc_o, rs2_d_dc_o,
    output word_st imm_ext_dc_o,
    pc_dc_o, pc_next_4_dc_o,
    output reg_e rd_a_dc_o, rs1_a_dc_o, rs2_a_dc_o
);

    word_st rs1_d_dc, rs2_d_dc;
    word_st imm_ext_dc;
    
    register_file register_file_dc_inst (
        .clk_i, .rst_i,
        .rd_we_i(reg_write_dc_i),
        .rs1_a_i(reg_e'(instr_dc_i[19:15])),
        .rs2_a_i(reg_e'(instr_dc_i[24:20])),
        .rd_a_i (reg_e'(rd_a_dc_i)),
        .rd_d_i (result_dc_i),
        .rs1_d_o(rs1_d_dc), .rs2_d_o(rs2_d_dc)
    );

    extend_imm extend_imm_dc_inst (
        .imm_src_i(imm_src_dc_i),
        .instr_i  (instr_dc_i),
        .imm_ext_o(imm_ext_dc)
    );

    always_ff @(posedge clk_i) begin : DecodeReg
        if (rst_i || flush_ex_i) begin
            rs1_d_dc_o <= '0;
            rs2_d_dc_o <= '0;
            imm_ext_dc_o <= '0;
            rd_a_dc_o <= REG_ZERO;
            pc_dc_o <= '0;
            pc_next_4_dc_o <= '0;
            rs1_a_dc_o <= REG_ZERO;
            rs2_a_dc_o <=REG_ZERO;
        end else begin
            rs1_d_dc_o <= rs1_d_dc;
            rs2_d_dc_o <= rs2_d_dc;
            imm_ext_dc_o <= imm_ext_dc;
            rd_a_dc_o <= reg_e'(instr_dc_i[11:7]);
            pc_dc_o <= pc_dc_i;
            pc_next_4_dc_o <= pc_next_4_dc_i;
            rs1_a_dc_o<=reg_e'(instr_dc_i[19:15]);
            rs2_a_dc_o<=reg_e'(instr_dc_i[24:20]);
        end
    end : DecodeReg

endmodule
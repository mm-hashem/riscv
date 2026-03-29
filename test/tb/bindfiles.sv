module binds
    import config_pkg::*;
(
    input logic clk_i, rst_i
);

    /***** RTL Assertions *****/

    bind main_decoder main_decoder_assert main_decoder_assert_inst (
        .clk_i(clk_i),    .rst_i(rst_i),
        .branch_o, .jump_o,
        .mem_write_o, .reg_write_o,
        .op_i
    );

    bind register_file regfile_assert regfile_assert_inst (
        .clk_i,   .rst_i,
        .rs1_a_i, .rs2_a_i, .rd_a_i,
        .regfile
    );

    bind data_ram data_ram_assert data_ram_assert_inst (
        .clk_i, .rst_i,
        .we_i,
        .a_i,
        .data_size_i
    );

    bind program_counter program_counter_assert program_counter_assert_inst (
        .clk_i,     .rst_i,
        .pc_init_i, .pc_next_i, .pc_o
    );

    generate // TODO: Interface?
        if (CFG_CORE == SINGLE) begin : RV_SINGLE_ASSERT
            bind rv_single rv_core_assert rv_core_assert_inst (
                .clk_i, .rst_i,
                .branch, .jump,
                .pc_src,
                .pc,
                .branch_target_addr,
                .alu_result
            );
        end else if (CFG_CORE == STAGE3) begin : RV_STAGE3_ASSERT
            bind rv_stage3 rv_core_assert rv_core_assert_inst (
                .clk_i, .rst_i,
                .branch(dc_s3_q.ctrl.branch), .jump(dc_s3_q.ctrl.jump),
                .pc_src(pc_src_s3),
                .pc(if_dc_d.pc),
                .branch_target_addr(branch_target_addr_s3),
                .alu_result(alu_result_s3)
            );
        end
    endgenerate

    /***** ABI Assertions *****/

    generate // TODO: Interface?
        if (CFG_CORE == SINGLE) begin : RV_SINGLE_ABI_ASSERT
             bind rv_single rv_core_abi_assert rv_core_abi_assert_inst (
                .clk_i, .rst_i,
                .mem_write,
                .alu_result,
                .pc
            );
        end else if (CFG_CORE == STAGE3) begin : RV_STAGE3_ABI_ASSERT
            bind rv_stage3 rv_core_abi_assert rv_core_abi_assert_inst (
                .clk_i, .rst_i,
                .mem_write(dc_s3_q.ctrl.mem_write),
                .alu_result(alu_result_s3),
                .pc(if_dc_d.pc)
            );
        end
    endgenerate

endmodule : binds
module binds
    import config_pkg::*;
(
    input logic clk_i, rst_i
);

    /***** Memory Loader *****/

    bind data_ram memory_loader #(
        .MEM_TYPE("data"),
        .ORG_ADDR(CFG_DATA_ORG),
        .END_ADDR(CFG_DATA_END)
    ) memory_loader_inst (
        .memory(ram)
    );

    bind instruction_rom memory_loader #(
        .MEM_TYPE("text"),
        .ORG_ADDR(CFG_TEXT_ORG),
        .END_ADDR(CFG_TEXT_END)
    ) memory_loader_inst (
        .memory(rom)
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

    bind RV_CORE.rv_core_inst rv_core_assert rv_core_assert_inst (
        .clk_i, .rst_i,
        .branch(dbg.branch), .jump(dbg.jump),
        .pc_src(dbg.pc_src),
        .pc(dbg.pc), .bta(dbg.bta),
        .alu_result(dbg.alu_result)
    ); // todo use rv_single/rv_stage3

    /***** ABI Assertions *****/

    bind RV_CORE.rv_core_inst rv_core_abi_assert rv_core_abi_assert_inst (
        .clk_i, .rst_i,
        .mem_write (dbg.mem_write),
        .pc        (dbg.pc),
        .alu_result(dbg.alu_result)
    ); // todo use rv_single/rv_stage3

    /***** Monitor *****/

`ifndef RGRS
    bind RV_CORE.rv_core_inst monitor monitor_inst (
        .clk_i, .rst_i,
        .reg_write(dbg.reg_write),
        .mem_write(dbg.mem_write),
        .pc  (dbg.pc),     .instr(dbg.instr),
        .rd_d(dbg.result), .a    (dbg.a),
        .wd_i(dbg.wd)
    );
`endif

    /***** TOHOST *****/

    bind data_ram tohost tohost_inst ( .clk_i, .ram );

endmodule : binds
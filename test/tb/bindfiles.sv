module binds
    import config_pkg::*;
(
    input logic clk_i, rst_i
);

    /***** Memory Loader *****/

    bind data_ram memory_loader #(
        .MEM_TYPE("data"),
        .WIDTH(CFG_XLEN),
        .ORG_ADDR(CFG_DATA_ORG_ARR),
        .END_ADDR(CFG_DATA_END_ARR)
    ) memory_loader_inst (
        .memory(ram)
    );

    bind instruction_rom memory_loader #(
        .MEM_TYPE("text"),
        .WIDTH(32),
        .ORG_ADDR(CFG_TEXT_ORG_ARR),
        .END_ADDR(CFG_TEXT_END_ARR)
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
        .clk_i,   .rst_i(rst_i),
        .rs1_a_i, .rs2_a_i, .rd_a_i,
        .rs1_d_o, .rs2_d_o
    );

    bind program_counter program_counter_assert program_counter_assert_inst (
        .clk_i,     .rst_i,
        .pc_next_i, .pc_o
    );

    bind RV_CORE.rv_core_inst rv_core_assert rv_core_assert_inst (
        .clk_i, .rst_i,
        .branch(dbg.branch), .jump(dbg.jump),
        .we(dbg.mem_write),
        .pc_src(dbg.pc_src),
        .pc(dbg.pc), .bta(dbg.bta),
        .alu_result(dbg.alu_result),
        .result_src(dbg.result_src),
        .data_size(dbg.data_size),
        .a(dbg.a)
    );

    /***** ABI Assertions *****/

    bind RV_CORE.rv_core_inst rv_core_abi_assert rv_core_abi_assert_inst (
        .clk_i, .rst_i,
        .mem_write (dbg.mem_write),
        .pc        (dbg.pc),
        .a(dbg.a)
    );

    /***** Monitor *****/

`ifndef RGRS
    bind RV_CORE.rv_core_inst monitor monitor_inst (
        .clk_i, .rst_i,
        .reg_write(dbg.reg_write),
        .mem_write(dbg.mem_write),
        .pc  (dbg.pc),     .instr(dbg.instr),
        .rd_d(dbg.result), .a    (dbg.a),
        .wd_i(dbg.wd),
        .rd_a(dbg.rd_a)
    );
`endif

    /***** TOHOST *****/

    bind data_ram tohost tohost_inst ( .clk_i, .TOHOST(ram[CFG_TOHOST_ADDR]) );

endmodule : binds
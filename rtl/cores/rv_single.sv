module rv_single
    import config_pkg::*;
    import types_pkg::*;
    import dbg_pkg::*;
(
    input logic clk_i, rst_i
);

    // Data Signals
    xlen_st result,  read_data,
            src_a,   src_b,     alu_result,
            rs1_d,   rs2_d,     imm_ext,
            write_data_sized, read_data_sized;
    word_st pc, pc_next, pc_plus_4, bta; 
    word_ut instr;

    // Control signals
    logic        reg_write,  mem_write,
                 branch,     jump,
                 zero;
    pc_src_e     pc_src;
    branch_op_e  branch_op;
    imm_src_e    imm_src;
    result_src_e result_src;
    alu_src_a_e  alu_a_src;
    alu_src_b_e  alu_b_src;
    alu_e        alu_ctrl;
    data_ctrl_t  data_ctrl;
    logic [CFG_DATA_BYTES-1:0] byte_enable;

    /*************************
     ***** Debug Signals *****
     *************************/

`ifndef SYNTH
     core_dbg_t dbg;

    assign dbg.pc         = pc;
    assign dbg.instr      = instr;
    assign dbg.a          = alu_result; // todo rename
    assign dbg.result     = result;
    assign dbg.wd         = write_data_sized;
    assign dbg.mem_write  = mem_write;
    assign dbg.reg_write  = reg_write;
    assign dbg.branch     = branch;
    assign dbg.jump       = jump;
    assign dbg.pc_src     = pc_src;
    assign dbg.bta        = bta;
    assign dbg.alu_result = alu_result;
    assign dbg.data_size  = data_ctrl.size;
    assign dbg.result_src = result_src;
    assign dbg.rd_a       = reg_e'(instr[11:7]);
`endif

    /***********************
     ***** Fetch Stage *****
     ***********************/

    mux4 #(.type_t (word_st)) mux4_pc_next (
        .sel(pc_src),
        .i0 (pc_plus_4),
        .i1 ({alu_result[31:2], 2'b00}), // J, I: jalr: JTA = rs1 + imm
        .i2 (bta),                       // B,          BTA = pc  + imm
        .i3 ('x),                        // Unreachable
        .y  (pc_next)
    );

    program_counter program_counter_inst (
        .clk_i, .rst_i,
        .en_i     (1'b1),
        .pc_next_i(pc_next),
        .pc_o     (pc)
    );

    assign pc_plus_4 = pc + CFG_XLEN'(4);

    instruction_rom instruction_rom_inst (
        .instr_a_i(pc), .instr_o(instr)
    );

    /************************
     ***** Decode Stage *****
     ************************/

    controller controller_inst (
        .op_i        (opcode_e'(instr[6:0])),
        .funct3_i    (instr[14:12]), .funct7_i   (instr[31:25]),
        .alu_a_src_o (alu_a_src),    .alu_b_src_o(alu_b_src),
        .result_src_o(result_src),   .reg_write_o(reg_write),
        .imm_src_o   (imm_src),      .alu_ctrl_o (alu_ctrl),
        .branch_o    (branch),       .jump_o     (jump),
        .mem_write_o (mem_write),    .branch_op_o(branch_op),
        .data_ctrl_o (data_ctrl)
    );

    register_file register_file_inst (
        .clk_i, .rst_i,
        .rd_we_i(reg_write),
        .rs1_a_i(reg_e'(instr[19:15])), 
        .rs2_a_i(reg_e'(instr[24:20])),
        .rd_a_i (reg_e'(instr[11:7])), .rd_d_i (result),
        .rs1_d_o(rs1_d),               .rs2_d_o(rs2_d)
    );

    extend_imm extend_imm_inst (
        .imm_src_i(imm_src),
        .instr_i  (instr),
        .imm_ext_o(imm_ext)
    );

    /*************************
     ***** Execute Stage *****
     *************************/

    pc_control_unit pc_control_unit_inst (
        .jump_i     (jump), .branch_i   (branch),
        .zero_i     (zero), .branch_op_i(branch_op),
        .less_than_i(alu_result[0]),
        .pc_src_o   (pc_src)
    );

    // Branch target address calculation
    assign bta = pc + imm_ext;

    /***** Source Muxes *****/

    // ALU Src A Mux
    mux4 mux4_alu_a_src (
        .sel(alu_a_src),
        .i0 (rs1_d), // Register/Immediate instructions
        .i1 ('0),    // U: lui
        .i2 (pc),    // U, J: auipc
        .i3 ('x),    // Unreachable
        .y  (src_a)
    );

    // ALU Src B Mux
    mux2 mux2_alu_b_src (
        .sel(alu_b_src),
        .i0 (rs2_d),
        .i1 (imm_ext),
        .y  (src_b)
    );

    alu alu_inst (
        .alu_ctrl_i(alu_ctrl),
        .src_a_i   (src_a), .src_b_i     (src_b),
        .zero_o    (zero),  .alu_result_o(alu_result)
    );

    /************************
     ***** Memory Stage *****
     ************************/

    store_unit store_unit_inst (
        .write_data_i(rs2_d),
        .data_size_i(data_ctrl.size),
        .byte_offset_i(alu_result[CFG_BYTE_OFFSET-1:0]),
        .write_data_sized_o(write_data_sized),
        .byte_enable_o(byte_enable)
    );

    data_ram data_ram_inst (
        .clk_i, .rst_i,
        .we_i(mem_write),
        .byte_enable_i(byte_enable),
        .a_i (alu_result),
        .wd_i(write_data_sized),
        .rd_o(read_data)
    );

    /***************************
     ***** Writeback Stage *****
     ***************************/

    load_unit load_unit_inst (
        .read_data_i      (read_data),
        .data_ctrl_i      (data_ctrl),
        .byte_offset_i    (alu_result[CFG_BYTE_OFFSET-1:0]),
        .read_data_sized_o(read_data_sized)
    );

    mux4 mux4_result (
        .sel(result_src),
        .i0 (alu_result),
        .i1 (read_data_sized),
        .i2 (pc_plus_4),
        .i3 ('x), // Unreachable
        .y  (result)
    );

endmodule : rv_single
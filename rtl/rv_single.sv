module rv_single
    import config_pkg::*;
    import types_pkg::*;
(
    input  logic       clk_i, rst_i,
    input  word_st     pc_init_i,
    output word_st     pc_tb, 
    output word_ut     instr_tb,
    output xlen_ut     a_tb,
    output xlen_st     rd_d_tb, regfile_tb [0:31], wd_tb,
    output logic [7:0] ram_tb[CFG_DATA_ORG:CFG_DATA_END-1],
    output logic       mem_write_tb, reg_write_tb,
    output reg_e       rd_a_tb
);

    // Data Signals
    xlen_st result,  read_data,
            src_a,   src_b,     alu_result,
            rs1_d,   rs2_d,     imm_ext,
            write_data_sized, read_data_sized;
    word_st pc, pc_next, pc_plus_4, branch_target_addr; 
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

    /********************************
     ***** Output/Debug Signals *****
     ********************************/

    assign pc_tb        = pc;
    assign instr_tb     = instr;
    assign regfile_tb   = rv_single.register_file_inst.regfile;
    assign a_tb         = rv_single.data_ram_inst.a_i;
    assign wd_tb        = rv_single.data_ram_inst.wd_i;
    assign ram_tb       = rv_single.data_ram_inst.ram;
    assign mem_write_tb = mem_write;
    assign reg_write_tb = reg_write;
    assign rd_a_tb      = reg_e'(instr[11:7]);
    assign rd_d_tb      = result;

    /************************************************/

    mux4_ws mux4_ws_pc_next (
        .sel(pc_src),
        .i0 (pc_plus_4),
        .i1 (alu_result),         // jalr, JTA = rs1 + imm
        .i2 (branch_target_addr), // B,    BTA = pc  + imm
        .i3 ('x),                 // Unreachable
        .y  (pc_next)
    );

    program_counter program_counter_inst (
        .clk_i, .rst_i,
        .pc_init_i(pc_init_i),
        .pc_next_i(pc_next),
        .pc_o     (pc)
    );

    assign pc_plus_4 = pc + CFG_XLEN'(4);

    instruction_rom instr_rom_inst (
        .instr_a_i(pc), .instr_o(instr)
    );

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

    pc_control_unit pc_control_unit_inst (
        .jump_i(jump), .branch_i   (branch),
        .zero_i(zero), .branch_op_i(branch_op),
        .less_than_i(alu_result[0]),
        .pc_src_o   (pc_src)
    );

    // Branch target address calculation
    assign branch_target_addr = pc + imm_ext;

    /***** ALU and Source Muxes *****/

    // ALU Src A Mux
    mux4_xs mux4_xs_alu_a_src (
        .sel(alu_a_src),
        .i0 (rs1_d), // Register/Immediate instructions
        .i1 ('0),    // U: lui
        .i2 (pc),    // J, U: auipc
        .i3 ('x),    // Unreachable
        .y  (src_a)
    );

    // ALU Src B Mux
    mux2_xs mux2_xs_alu_b_src (
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

    /***** Data Memory *****/

    store_unit store_unit_inst (
        .write_data_i(rs2_d),
        .data_size_i(data_ctrl.size),
        .write_data_sized_o(write_data_sized)
    );

    data_ram data_ram_inst (
        .clk_i, .rst_i,
        .we_i(mem_write),
        .data_size_i(data_ctrl.size),
        .a_i (alu_result),
        .wd_i(write_data_sized),
        .rd_o(read_data)
    );

    load_unit load_unit_inst (
        .read_data_i      (read_data),
        .data_ctrl_i      (data_ctrl),
        .read_data_sized_o(read_data_sized)
    );

    /***** Writeback/ResultSrc Mux *****/

    mux4_xs mux4_xs_result_src (
        .sel(result_src),
        .i0 (alu_result),
        .i1 (read_data_sized),
        .i2 (pc_plus_4),
        .i3 ('x), // Unreachable
        .y  (result)
    );

endmodule : rv_single
module rv_stage3
    import config_pkg::*;
    import types_pkg::*;
    import pipeline_pkg::*;
    import dbg_pkg::*;
(
    input  logic      clk_i, rst_i,
    input  word_st    pc_init_i
);

    // Hazard Signals
    logic flush_dc, flush_s3;

    // Control Signals
    logic zero_s3;
    pc_src_e pc_src_s3;

    // Data Signals    
    xlen_st result_s3,  read_data_s3,  target_addr_s3,
            src_a_s3, src_b_s3,   alu_result_s3,
            write_data_sized_s3, read_data_sized_s3;
    word_st pc_next_ft, bta_s3;

    // Pipelined Structs
    if_dc_t if_dc_d, if_dc_q;
    dc_s3_t dc_s3_d, dc_s3_q;

    /********************************
     ***** Output/Debug Signals *****
     ********************************/

    core_dbg_t dbg;

    assign dbg.pc         = if_dc_d.pc;
    assign dbg.instr      = if_dc_d.instr;
    assign dbg.a          = rv_stage3.data_ram_inst.a_i;
    assign dbg.result     = result_s3;
    assign dbg.wd         = rv_stage3.data_ram_inst.wd_i;
    assign dbg.mem_write  = dc_s3_q.ctrl.mem_write;
    assign dbg.reg_write  = dc_s3_q.ctrl.reg_write;
    assign dbg.branch     = dc_s3_q.ctrl.branch;
    assign dbg.jump       = dc_s3_q.ctrl.jump;
    assign dbg.pc_src     = pc_src_s3;
    assign dbg.bta        = bta_s3;
    assign dbg.alu_result = alu_result_s3;

    /***********************
     ***** Hazard Unit *****
     ***********************/

    hazard_unit hazard_unit_inst (
        .pc_src_s3_i(pc_src_s3),
        .flush_dc_o (flush_dc),
        .flush_s3_o (flush_s3)
    );

    /***********************
     ***** Fetch Stage *****
     ***********************/

    mux4 #(.type_t(word_st)) mux4_pc_next (
        .sel(pc_src_s3),
        .i0 (if_dc_d.pc_plus_4),
        .i1 (alu_result_s3),         // jalr, JTA = rs1 + imm
        .i2 (bta_s3), // B,    BTA = pc  + imm
        .i3 ('x),                    // Unreachable
        .y  (pc_next_ft)
    );

    program_counter program_counter_inst (
        .clk_i, .rst_i,
        .pc_init_i(pc_init_i),
        .pc_next_i(pc_next_ft),
        .pc_o     (if_dc_d.pc)
    );

    assign if_dc_d.pc_plus_4 = if_dc_d.pc + CFG_XLEN'(4);

    instruction_rom instruction_rom_inst (
        .instr_a_i(if_dc_d.pc), .instr_o(if_dc_d.instr)
    );

    always_ff @(posedge clk_i) begin : Fetch2DecodeReg
        if (rst_i || flush_dc) if_dc_q <= 'x;
        else                   if_dc_q <= if_dc_d;
    end : Fetch2DecodeReg

    /************************
     ***** Decode Stage *****
     ************************/

     assign dc_s3_d.data.pc        = if_dc_q.pc;
     assign dc_s3_d.data.pc_plus_4 = if_dc_q.pc_plus_4;
     assign dc_s3_d.data.rd_a      = reg_e'(if_dc_q.instr[11:7]);

    controller controller_inst (
        .op_i        (opcode_e'(if_dc_q.instr[6:0])),
        .funct3_i    (if_dc_q.instr[14:12]),    .funct7_i   (if_dc_q.instr[31:25]),
        .alu_a_src_o (dc_s3_d.ctrl.alu_a_src),  .alu_b_src_o(dc_s3_d.ctrl.alu_b_src),
        .result_src_o(dc_s3_d.ctrl.result_src), .reg_write_o(dc_s3_d.ctrl.reg_write),
        .imm_src_o   (dc_s3_d.ctrl.imm_src),    .alu_ctrl_o (dc_s3_d.ctrl.alu_ctrl),
        .branch_o    (dc_s3_d.ctrl.branch),     .jump_o     (dc_s3_d.ctrl.jump),
        .mem_write_o (dc_s3_d.ctrl.mem_write),  .branch_op_o(dc_s3_d.ctrl.branch_op),
        .data_ctrl_o (dc_s3_d.ctrl.data_ctrl)
    );

    register_file register_file_inst (
        .clk_i, .rst_i,
        .rd_we_i(dc_s3_q.ctrl.reg_write),
        .rs1_a_i(reg_e'(if_dc_q.instr[19:15])),
        .rs2_a_i(reg_e'(if_dc_q.instr[24:20])),
        .rd_a_i (dc_s3_q.data.rd_a),  .rd_d_i (result_s3),
        .rs1_d_o(dc_s3_d.data.rs1_d), .rs2_d_o(dc_s3_d.data.rs2_d)
    );

    extend_imm extend_imm_inst (
        .imm_src_i(dc_s3_d.ctrl.imm_src),
        .instr_i  (if_dc_q.instr),
        .imm_ext_o(dc_s3_d.data.imm_ext)
    );

    always_ff @(posedge clk_i) begin : Decode2Stage3Reg
        if (rst_i || flush_s3) begin
            dc_s3_q.ctrl <= '0;
            dc_s3_q.data <= 'x;
        end else
            dc_s3_q <= dc_s3_d;
    end : Decode2Stage3Reg

    /*******************************
     ***** Stage 3 (Ex/Mem/WB) *****
     *******************************/

    pc_control_unit pc_control_unit_s3_inst (
        .jump_i(dc_s3_q.ctrl.jump), .branch_i   (dc_s3_q.ctrl.branch), 
        .zero_i(zero_s3),      .branch_op_i(dc_s3_q.ctrl.branch_op),
        .less_than_i(alu_result_s3[0]),
        .pc_src_o   (pc_src_s3)
    );

    // Branch target address calculation
    assign bta_s3 = dc_s3_q.data.pc + dc_s3_q.data.imm_ext;

    /***** ALU and Source Muxes *****/

    // ALU Src A Mux
    mux4 mux4_alu_a_src (
        .sel(dc_s3_q.ctrl.alu_a_src),
        .i0 (dc_s3_q.data.rs1_d), // Register/Immediate instructions
        .i1 ('0),            // U: lui
        .i2 (dc_s3_q.data.pc),    // J, U: auipc
        .i3 ('x),            // Unreachable
        .y  (src_a_s3)
    );

    // ALU Src B Mux
    mux2 mux2_alu_b_src (
        .sel(dc_s3_q.ctrl.alu_b_src),
        .i0 (dc_s3_q.data.rs2_d),
        .i1 (dc_s3_q.data.imm_ext),
        .y  (src_b_s3)
    );

    alu alu_inst (
        .alu_ctrl_i(dc_s3_q.ctrl.alu_ctrl),
        .src_a_i   (src_a_s3), .src_b_i     (src_b_s3),
        .zero_o    (zero_s3),  .alu_result_o(alu_result_s3)
    );

    /***** Data Memory *****/

    store_unit store_unit_inst (
        .write_data_i(dc_s3_q.data.rs2_d),
        .data_size_i(dc_s3_q.ctrl.data_ctrl.size),
        .write_data_sized_o(write_data_sized_s3)
    );

    data_ram data_ram_inst (
        .clk_i, .rst_i,
        .we_i(dc_s3_q.ctrl.mem_write),
        .data_size_i(dc_s3_q.ctrl.data_ctrl.size),
        .a_i (alu_result_s3),
        .wd_i(write_data_sized_s3),
        .rd_o(read_data_s3)
    );

    load_unit load_unit_inst (
        .read_data_i      (read_data_s3),
        .data_ctrl_i      (dc_s3_q.ctrl.data_ctrl),
        .read_data_sized_o(read_data_sized_s3)
    );

    /***** Writeback/ResultSrc Mux *****/

    mux4 mux4_result_src (
        .sel(dc_s3_q.ctrl.result_src),
        .i0 (alu_result_s3),
        .i1 (read_data_sized_s3),
        .i2 (dc_s3_q.data.pc_plus_4),
        .i3 ('x), // Unreachable
        .y  (result_s3)
    );

endmodule : rv_stage3
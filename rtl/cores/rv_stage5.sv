module rv_stage5
    import config_pkg::*;
    import types_pkg::*;
    import pipeline_pkg::*;
/* synthesis translate_off */
    import dbg_pkg::*;
/* synthesis translate_on */
(
    input logic clk_i, rst_i
`ifdef SYNTH
    ,output logic [7:0] result_wb_sy
`endif
);

    // Hazard Signals
    logic [1:0] src_a_fwd_ex_ctrl, src_b_fwd_ex_ctrl;
    logic       stall_ft,          stall_dc,
                flush_ex,          flush_dc;

    // Control Signals
    logic zero_ex;
    pc_src_e pc_src_ex;
    logic [CFG_DATA_BYTES-1:0] byte_enable_me;
    imm_src_e imm_src_dc;

    // Data Signals    
    word_ut instr_dc;
    xlen_st src_a_fwd_ex_data,
            src_a_ex,          src_b_ex,
            read_data_wb,      write_data_sized_me,
            read_data_sized_wb,
            result_wb;
    word_st pc_next_ft, bta_ex;

    // Pipelined Registers Structs
    ft_dc_t ft_dc_d, ft_dc_q;
    dc_ex_t dc_ex_d, dc_ex_q;
    ex_me_t ex_me_d, ex_me_q;
    me_wb_t me_wb_d, me_wb_q;

    /*************************
     ***** Debug Signals *****
     *************************/

`ifdef SYNTH
    assign result_wb_sy = result_wb[7:0];
`endif

/* synthesis translate_off */
    core_dbg_t dbg;

    assign dbg.pc         = ft_dc_d.pc;
    assign dbg.instr      = instr_dc;
    assign dbg.a          = ex_me_q.data.alu_result; // todo rename
    assign dbg.result     = result_wb;
    assign dbg.wd         = write_data_sized_me;
    assign dbg.mem_write  = ex_me_q.ctrl.mem_write;
    assign dbg.reg_write  = me_wb_q.ctrl.reg_write;
    assign dbg.branch     = dc_ex_q.ctrl.branch;
    assign dbg.jump       = dc_ex_q.ctrl.jump;
    assign dbg.pc_src     = pc_src_ex;
    assign dbg.bta        = bta_ex;
    assign dbg.alu_result = ex_me_d.data.alu_result;
    assign dbg.data_size  = ex_me_q.ctrl.data_ctrl.size;
    assign dbg.result_src = me_wb_d.ctrl.result_src;
    assign dbg.rd_a       = me_wb_q.ctrl.rd_a;
/* synthesis translate_on */

    /***********************
     ***** Hazard Unit *****
     ***********************/

    stall_control_unit stall_control_unit_inst (
        .pc_src_i(pc_src_ex),
        .rs1_a_dc_i(dc_ex_d.ctrl.rs1_a), .rs2_a_dc_i(dc_ex_d.ctrl.rs2_a),
        .rd_a_ex_i (dc_ex_q.ctrl.rd_a),
        .result_src_ex_i(dc_ex_q.ctrl.result_src),
        .stall_ft_o(stall_ft), .stall_dc_o(stall_dc),
        .flush_dc_o(flush_dc), .flush_ex_o(flush_ex)
    );

    /***********************
     ***** Fetch Stage *****
     ***********************/

    assign ft_dc_d.pc_plus_4 = ft_dc_d.pc + CFG_XLEN'(4);

    mux4 #(.type_t(word_st)) mux4_pc_next ( // todo: uppercase
        .sel(pc_src_ex),
        .i0 (ft_dc_d.pc_plus_4),
        .i1 (unsigned'({ex_me_d.data.alu_result[31:2], 2'b00})), // J, I: jalr: JTA = rs1 + imm, todo move to instr rom address
        .i2 (bta_ex),                                            // B:          BTA = pc  + imm
        .i3 ('x),                                                // Unreachable
        .y  (pc_next_ft)
    );

    dff #(.WIDTH(32)) dff_program_counter_inst (
        .clk_i, .rst_i,
        .en_i(~stall_ft),
        .d_i (pc_next_ft),
        .q_o (ft_dc_d.pc)
    );

    instruction_rom instruction_rom_inst (
        .clk_i, .rst_i(rst_i | flush_dc),
        .en_i(~stall_dc),
        .instr_a_i(ft_dc_d.pc), .instr_o(instr_dc)
    );
    
    /***** Fetch-Decode Stage Register *****/

    dff #(.WIDTH($bits(ft_dc_t))) dff_ft_dc (
        .clk_i, .rst_i(rst_i | flush_dc),
        .en_i(~stall_dc),
        .d_i (ft_dc_d),
        .q_o (ft_dc_q)
    );

    /************************
     ***** Decode Stage *****
     ************************/

    // Pass data and control signals to next stage
    assign dc_ex_d.data.pc        = ft_dc_q.pc;
    assign dc_ex_d.data.pc_plus_4 = ft_dc_q.pc_plus_4;
    assign dc_ex_d.ctrl.rd_a      = reg_e'(instr_dc[11:7]);
    assign dc_ex_d.ctrl.rs1_a     = reg_e'(instr_dc[19:15]);
    assign dc_ex_d.ctrl.rs2_a     = reg_e'(instr_dc[24:20]);

    controller controller_inst (
        .op_i        (opcode_e'(opcode_e'(instr_dc[6:0]))),
        .funct3_i    (instr_dc[14:12]),         .funct7_i   (instr_dc[31:25]),
        .alu_a_src_o (dc_ex_d.ctrl.alu_a_src),  .alu_b_src_o(dc_ex_d.ctrl.alu_b_src),
        .result_src_o(dc_ex_d.ctrl.result_src), .reg_write_o(dc_ex_d.ctrl.reg_write),
        .imm_src_o   (imm_src_dc),              .alu_ctrl_o (dc_ex_d.ctrl.alu_ctrl),
        .branch_o    (dc_ex_d.ctrl.branch),     .jump_o     (dc_ex_d.ctrl.jump),
        .mem_write_o (dc_ex_d.ctrl.mem_write),  .branch_op_o(dc_ex_d.ctrl.branch_op),
        .data_ctrl_o (dc_ex_d.ctrl.data_ctrl)
    );

    register_file register_file_inst (
        .clk_i,
        .rd_we_i(me_wb_q.ctrl.reg_write),
        .rs1_a_i(dc_ex_d.ctrl.rs1_a),
        .rs2_a_i(dc_ex_d.ctrl.rs2_a),
        .rd_a_i (me_wb_q.ctrl.rd_a),  .rd_d_i (result_wb),
        .rs1_d_o(dc_ex_d.data.rs1_d), .rs2_d_o(dc_ex_d.data.rs2_d)
    );

    extend_imm extend_imm_inst (
        .imm_src_i(imm_src_dc),
        .instr_i  (instr_dc),
        .imm_ext_o(dc_ex_d.data.imm_ext)
    );

    /***** Decode-Execute Stage Register *****/

    dff #(.WIDTH($bits(dc_ex_t))) dff_dc_ex (
        .clk_i, .rst_i(rst_i | flush_ex),
        .en_i(1'b1),
        .d_i (dc_ex_d),
        .q_o (dc_ex_q)
    );

    /*************************
     ***** Execute Stage *****
     *************************/

    // Pass data and control signals to next stage
    assign ex_me_d.ctrl.rd_a       = dc_ex_q.ctrl.rd_a;
    assign ex_me_d.ctrl.result_src = dc_ex_q.ctrl.result_src;
    assign ex_me_d.ctrl.mem_write  = dc_ex_q.ctrl.mem_write;
    assign ex_me_d.ctrl.reg_write  = dc_ex_q.ctrl.reg_write;
    assign ex_me_d.ctrl.data_ctrl  = dc_ex_q.ctrl.data_ctrl;
    assign ex_me_d.data.pc_plus_4  = dc_ex_q.data.pc_plus_4;

    pc_control_unit pc_control_unit_inst (
        .jump_i     (dc_ex_q.ctrl.jump), .branch_i   (dc_ex_q.ctrl.branch), 
        .zero_i     (zero_ex),           .branch_op_i(dc_ex_q.ctrl.branch_op),
        .less_than_i(ex_me_d.data.alu_result[0]),
        .pc_src_o   (pc_src_ex)
    );

    // Branch target address calculation
    assign bta_ex = dc_ex_q.data.pc + dc_ex_q.data.imm_ext;

    /***** Forwarding Logic *****/

    forwarding_control_unit forwarding_control_unit_inst (
        .rs1_a_ex_i(dc_ex_q.ctrl.rs1_a),              .rs2_a_ex_i(dc_ex_q.ctrl.rs2_a),
        .rd_a_me_i (ex_me_q.ctrl.rd_a),               .rd_a_wb_i (me_wb_q.ctrl.rd_a),
        .reg_write_me_i     (ex_me_q.ctrl.reg_write), .reg_write_wb_i     (me_wb_q.ctrl.reg_write),
        .src_a_fwd_ex_ctrl_o(src_a_fwd_ex_ctrl),      .src_b_fwd_ex_ctrl_o(src_b_fwd_ex_ctrl)
    );

    // Src A Forwarding Mux
    mux4 mux4_src_a_fwd (
        .sel(src_a_fwd_ex_ctrl),
        .i0 (dc_ex_q.data.rs1_d),      // No hazard
        .i1 (result_wb),               // Forwarding from Writeback
        .i2 (ex_me_q.data.alu_result), // Forwarding from Memory
        .i3 ('x),                      // Unreachable
        .y  (src_a_fwd_ex_data)
    );

    // Src B Forwarding Mux
    mux4 mux4_src_b_fwd (
        .sel(src_b_fwd_ex_ctrl),
        .i0 (dc_ex_q.data.rs2_d),      // No hazard
        .i1 (result_wb),               // Forwarding from Writeback
        .i2 (ex_me_q.data.alu_result), // Forwarding from Memory
        .i3 ('x),                      // Unreachable
        .y  (ex_me_d.data.src_b_fwd_ex_data)
    );

    /***** Source Muxes *****/

    // ALU Src A Mux
    mux4 mux4_alu_a_src_inst (
        .sel(dc_ex_q.ctrl.alu_a_src),
        .i0 (src_a_fwd_ex_data), // Register/Immediate instructions
        .i1 ('0),                // U: lui
        .i2 (dc_ex_q.data.pc),   // U, J: auipc
        .i3 ('x),                // Unreachable
        .y  (src_a_ex)
    );

    // ALU Src B Mux
    mux2 mux2_alu_b_src_inst (
        .sel(dc_ex_q.ctrl.alu_b_src),
        .i0 (ex_me_d.data.src_b_fwd_ex_data),
        .i1 (dc_ex_q.data.imm_ext),
        .y  (src_b_ex)
    );

    alu alu_inst (
        .alu_ctrl_i(dc_ex_q.ctrl.alu_ctrl),
        .src_a_i   (src_a_ex), .src_b_i     (src_b_ex),
        .zero_o    (zero_ex),  .alu_result_o(ex_me_d.data.alu_result)
    );

    /***** Execute-Memory Stage Register *****/

    dff #(.WIDTH($bits(ex_me_t))) dff_ex_me (
        .clk_i, .rst_i,
        .en_i(1'b1),
        .d_i (ex_me_d),
        .q_o (ex_me_q)
    );

    /************************
     ***** Memory Stage *****
     ************************/
    
    // Pass data and control signals to next stage
    assign me_wb_d.ctrl.rd_a       = ex_me_q.ctrl.rd_a;
    assign me_wb_d.ctrl.result_src = ex_me_q.ctrl.result_src;
    assign me_wb_d.ctrl.reg_write  = ex_me_q.ctrl.reg_write;
    assign me_wb_d.ctrl.data_ctrl  = ex_me_q.ctrl.data_ctrl;
    assign me_wb_d.data.pc_plus_4  = ex_me_q.data.pc_plus_4;
    assign me_wb_d.data.alu_result = ex_me_q.data.alu_result;

    store_unit store_unit_inst (
        .write_data_i (ex_me_q.data.src_b_fwd_ex_data),
        .data_size_i  (ex_me_q.ctrl.data_ctrl.size),
        .byte_offset_i(ex_me_q.data.alu_result[CFG_BYTE_OFFSET-1:0]),
        .write_data_sized_o(write_data_sized_me),
        .byte_enable_o(byte_enable_me)
    );

    data_ram data_ram_inst (
        .clk_i,
        .we_i(ex_me_q.ctrl.mem_write),
        .byte_enable_i(byte_enable_me),
        .a_i (ex_me_q.data.alu_result),
        .wd_i(write_data_sized_me),
        .rd_o(read_data_wb)
    );

    /***** Memory-Writeback Stage Register *****/

    dff #(.WIDTH($bits(me_wb_t))) dff_me_wb (
        .clk_i, .rst_i,
        .en_i(1'b1),
        .d_i (me_wb_d),
        .q_o (me_wb_q)
    );

    /***************************
     ***** Writeback Stage *****
     ***************************/

    load_unit load_unit_inst (
        .read_data_i      (read_data_wb),
        .data_ctrl_i      (me_wb_q.ctrl.data_ctrl),
        .byte_offset_i    (me_wb_q.data.alu_result[CFG_BYTE_OFFSET-1:0]),
        .read_data_sized_o(read_data_sized_wb)
    );

    mux4 mux4_result_inst (
        .sel(me_wb_q.ctrl.result_src),
        .i0 (me_wb_q.data.alu_result),
        .i1 (read_data_sized_wb),
        .i2 (me_wb_q.data.pc_plus_4),
        .i3 ('x), // Unreachable
        .y  (result_wb)
    );

endmodule : rv_stage5
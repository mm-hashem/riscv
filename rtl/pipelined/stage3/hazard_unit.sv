module hazard_unit
    import types_pkg::*;
(
    input  pc_src_e     pc_src_i,
    input  reg_e        rs1_a_dc_i, rs2_a_dc_i,
                        rs1_a_ex_i, rs2_a_ex_i, 
                        rd_a_ex_i, rd_a_me_i,
                        rd_a_wb_i,
    input  result_src_e result_src_ex_i,
    input  logic        reg_write_me_i, reg_write_wb_i,
    output logic [1:0]  src_a_fwd_ex_ctrl_o, src_b_fwd_ex_ctrl_o,
    output logic        stall_ft_o, stall_dc_o,
                        flush_dc_o, flush_ex_o
);

    logic memory_load_stall;

    // Forwarding control logic for ALU's Source A in Execute Stage
    always_comb begin : SrcAForwardExCtrl
        if ((rs1_a_ex_i == rd_a_me_i && reg_write_me_i) && (rs1_a_ex_i != REG_ZERO))
            src_a_fwd_ex_ctrl_o = 2'b10; // Forward from Memory
        else if ((rs1_a_ex_i == rd_a_wb_i && reg_write_wb_i) && (rs1_a_ex_i != REG_ZERO))
            src_a_fwd_ex_ctrl_o = 2'b01; // Forward from Writeback
        else
            src_a_fwd_ex_ctrl_o = 2'b00; // No hazard
    end : SrcAForwardExCtrl

    // Forwarding control logic for ALU's Source B in Execute Stage
    always_comb begin : SrcBForwardExCtrl
        if ((rs2_a_ex_i == rd_a_me_i && reg_write_me_i) && (rs2_a_ex_i != REG_ZERO))
            src_b_fwd_ex_ctrl_o = 2'b10; // Forward from Memory
        else if ((rs2_a_ex_i == rd_a_wb_i && reg_write_wb_i) && (rs2_a_ex_i != REG_ZERO))
            src_b_fwd_ex_ctrl_o = 2'b01; // Forward from Writeback
        else
            src_b_fwd_ex_ctrl_o = 2'b00; // No hazard
    end : SrcBForwardExCtrl

    // Memory load stall logic
    assign memory_load_stall = ((result_src_ex_i == RESULT_MEMORY) &
                               ((rs1_a_dc_i == rd_a_ex_i) | (rs2_a_dc_i == rd_a_ex_i)) &
                               (rd_a_ex_i != REG_ZERO));
    assign stall_ft_o = memory_load_stall;
    assign stall_dc_o = memory_load_stall;
    assign flush_ex_o = memory_load_stall | (pc_src_i inside {PCSRC_JMP, PCSRC_BR}); // Flush Execute stage on memory load or control hazards

    // Jump/Branch hazard logic
    assign flush_dc_o = pc_src_i inside {PCSRC_JMP, PCSRC_BR};

endmodule
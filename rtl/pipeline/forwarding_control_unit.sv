module forwarding_control_unit
    import types_pkg::*;
(
    input reg_e rs1_a_ex_i,     rs2_a_ex_i, 
                rd_a_me_i,      rd_a_wb_i,
    input logic reg_write_me_i, reg_write_wb_i,
    output logic [1:0]  src_a_fwd_ex_ctrl_o, src_b_fwd_ex_ctrl_o
);

    // Forwarding control logic for ALU's Source A in Execute Stage
    always_comb begin : SrcAForwardExCtrl
        if      ((rs1_a_ex_i == rd_a_me_i && reg_write_me_i) && (rs1_a_ex_i != REG_ZERO))
            src_a_fwd_ex_ctrl_o = 2'b10; // Forward from Memory
        else if ((rs1_a_ex_i == rd_a_wb_i && reg_write_wb_i) && (rs1_a_ex_i != REG_ZERO))
            src_a_fwd_ex_ctrl_o = 2'b01; // Forward from Writeback
        else
            src_a_fwd_ex_ctrl_o = 2'b00; // No hazard
    end : SrcAForwardExCtrl

    // Forwarding control logic for ALU's Source B in Execute Stage
    always_comb begin : SrcBForwardExCtrl
        if      ((rs2_a_ex_i == rd_a_me_i && reg_write_me_i) && (rs2_a_ex_i != REG_ZERO))
            src_b_fwd_ex_ctrl_o = 2'b10; // Forward from Memory
        else if ((rs2_a_ex_i == rd_a_wb_i && reg_write_wb_i) && (rs2_a_ex_i != REG_ZERO))
            src_b_fwd_ex_ctrl_o = 2'b01; // Forward from Writeback
        else
            src_b_fwd_ex_ctrl_o = 2'b00; // No hazard
    end : SrcBForwardExCtrl
    
endmodule
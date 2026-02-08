module hazard_unit
    import definitions_pkg::*;
(
    input reg_e rs1_a_ex_i, rs2_a_ex_i,
                rs1_a_dc_i, rs2_a_dc_i,
                rd_a_ex_i, rd_a_wb_i,
    input var reg_e rd_a_mr_i,
    input logic reg_write_mr_i, reg_write_wb_i, pc_src_ex_i,
    input logic [1:0] result_src_ex_i,
    output logic [1:0] forward_src_a_ex_o, forward_src_b_ex_o,
    output logic stall_ft_o, stall_dc_o, flush_ex_o, flush_dc_o
);

    logic lw_stall_hz;

    always_comb begin : ForwardSrcA
        if (((rs1_a_ex_i == rd_a_mr_i) && reg_write_mr_i) && rs1_a_ex_i != REG_ZERO) // priority?
            forward_src_a_ex_o = 2'b10;
        else if (((rs1_a_ex_i == rd_a_wb_i) && reg_write_wb_i) && rs1_a_ex_i != REG_ZERO)
            forward_src_a_ex_o = 2'b01;
        else
            forward_src_a_ex_o = 2'b00;
    end : ForwardSrcA

    always_comb begin : ForwardSrcB
        if (((rs2_a_ex_i == rd_a_mr_i) && reg_write_mr_i) && rs2_a_ex_i != REG_ZERO) // priority?
            forward_src_b_ex_o = 2'b10;
        else if (((rs2_a_ex_i == rd_a_wb_i) && reg_write_wb_i) && rs2_a_ex_i != REG_ZERO)
            forward_src_b_ex_o = 2'b01;
        else
            forward_src_b_ex_o = 2'b00;
    end : ForwardSrcB

    assign lw_stall_hz = (result_src_ex_i == 2'b01) && ((rs1_a_dc_i == rd_a_ex_i) || (rs2_a_dc_i == rd_a_ex_i));

    assign stall_ft_o = lw_stall_hz;
    assign stall_dc_o = lw_stall_hz;
    assign flush_dc_o = pc_src_ex_i;
    assign flush_ex_o = lw_stall_hz || pc_src_ex_i;

endmodule
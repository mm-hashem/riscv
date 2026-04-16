module stall_control_unit
    import types_pkg::*;
(
    input  pc_src_e     pc_src_i,
    input  reg_e        rs1_a_dc_i, rs2_a_dc_i,
                        rd_a_ex_i,
    input  result_src_e result_src_ex_i,
    output logic        stall_ft_o, stall_dc_o,
                        flush_dc_o, flush_ex_o
);

    logic memory_load_stall;

    // Memory load stall logic
    assign memory_load_stall = ((result_src_ex_i == RESULT_MEMORY) &
                               ((rs1_a_dc_i == rd_a_ex_i) | (rs2_a_dc_i == rd_a_ex_i)) &
                                (rd_a_ex_i  != REG_ZERO));
    assign stall_ft_o = memory_load_stall;
    assign stall_dc_o = memory_load_stall;
    assign flush_ex_o = memory_load_stall | (pc_src_i inside {PCSRC_JMP, PCSRC_BR}); // Flush Execute stage on memory load or control hazards, todo

    // Jump/Branch hazard logic
    assign flush_dc_o = pc_src_i inside {PCSRC_JMP, PCSRC_BR};

endmodule : stall_control_unit
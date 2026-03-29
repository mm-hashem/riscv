module hazard_unit
    import types_pkg::*;
(
    input  pc_src_e pc_src_s3_i,
    output logic    flush_dc_o, flush_s3_o
);

    always_comb begin : HazardUnitBlk
        if (pc_src_s3_i inside{PCSRC_JMP, PCSRC_BR}) begin
            flush_dc_o = 1'b1;
            flush_s3_o = 1'b1;
        end else begin
            flush_dc_o = 1'b0;
            flush_s3_o = 1'b0;
        end
    end : HazardUnitBlk

endmodule
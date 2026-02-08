module hazard_unit
    import definitions_pkg::*;
(
    input logic pc_src_s3_i,
    output logic flush_dc_o, flush_s3_o
);

    assign flush_dc_o = pc_src_s3_i;
    assign flush_s3_o = pc_src_s3_i;

endmodule
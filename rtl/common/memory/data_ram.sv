module data_ram
    import config_pkg::*;
    import types_pkg::*;
(
    input  logic                      clk_i,
                                      we_i,
    input  logic [CFG_DATA_BYTES-1:0] byte_enable_i,
    input  xlen_ut                    a_i, wd_i,
    output xlen_st                    rd_o
);

    xlen_ut addr;

`ifdef SYNTH
    assign addr = a_i[CFG_XLEN-1:CFG_BYTE_OFFSET] - CFG_DATA_ORG_ARR;
    xlen_ut ram [0:CFG_DATA_LENGTH_ARR-1];
    initial $readmemh("../memory_fpga/data.mem", ram);
`else
    assign addr = a_i[CFG_XLEN-1:CFG_BYTE_OFFSET];
    xlen_ut ram[CFG_DATA_ORG_ARR:CFG_DATA_END_ARR-1];
`endif

    generate
        if (CFG_CORE == STAGE5) begin
            always_ff @(posedge clk_i) begin
                if (we_i) begin
                    for (int i = 0; i < CFG_DATA_BYTES; i++)
                        if (byte_enable_i[i])
                            ram[addr][i*8+:8] <= wd_i[i*8+:8];
                end else
                    rd_o <= ram[addr];
            end
        end else if (CFG_CORE == SINGLE) begin
            always_ff @(posedge clk_i) begin
                if (we_i) begin
                    for (int i = 0; i < CFG_DATA_BYTES; i++)
                        if (byte_enable_i[i])
                            ram[addr][i*8+:8] <= wd_i[i*8+:8];
                end
            end
            assign rd_o = ram[addr];
        end
    endgenerate

endmodule : data_ram
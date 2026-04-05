module data_ram
    import config_pkg::*;
    import types_pkg::*;
(
    input  logic                      clk_i, rst_i,
                                      we_i,
    input  logic [CFG_DATA_BYTES-1:0] byte_enable_i,
    input  xlen_ut                    a_i, wd_i,
    output xlen_st                    rd_o
);

    localparam SHAMT = CFG_XLEN == 64 ? 3 : 2; // Normalize address for double/word indexing

    logic [CFG_XLEN-1:0] ram [CFG_DATA_ORG_ARR:CFG_DATA_END_ARR-1];

`ifdef SYNTH
    initial $readmemh("./build/memory/data.mem", ram); // todo path and name
`endif

    generate
        if (CFG_CORE == STAGE5) begin
            always_ff @(posedge clk_i) begin
                if (we_i) begin
                    for (int i; i < CFG_DATA_BYTES; i++)
                        if (byte_enable_i[i])
                            ram[a_i[CFG_XLEN-1:SHAMT]][i*8+:8] <= wd_i[i*8+:8];
                end else
                    rd_o <= ram[a_i[CFG_XLEN-1:SHAMT]];
            end
        end else if (CFG_CORE == SINGLE) begin
            always_ff @(posedge clk_i)
                if (we_i)
                    for (int i; i < CFG_DATA_BYTES; i++)
                        if (byte_enable_i[i])
                            ram[a_i[CFG_XLEN-1:SHAMT]][i*8+:8] <= wd_i[i*8+:8];
            assign rd_o = ram[a_i[CFG_XLEN-1:SHAMT]];
        end
    endgenerate

endmodule: data_ram
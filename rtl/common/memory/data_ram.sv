module data_ram
    import config_pkg::*;
    import types_pkg::*;
(
    input  logic       clk_i, rst_i,
                       we_i,
    input  data_size_e data_size_i,
    input  xlen_ut     a_i, wd_i,
    output xlen_st     rd_o
);

    logic [7:0] ram [CFG_DATA_ORG:CFG_DATA_END-1];

    always_ff @(posedge clk_i)
        if (we_i && !rst_i)
            for (int i = 0; i < MASK_LEN; i++)
                if (data_size_i[i])
                    ram[a_i + i] <= wd_i[i*8+:8];

    always_comb
        for (int i = 0; i < MASK_LEN; i++)
            rd_o[i*8+:8] = ram[a_i + i];

endmodule: data_ram
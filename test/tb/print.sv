module print
    import types_pkg::*;
    import config_pkg::*;
(
    input logic   clk_i,
                  we_i,
    input xlen_ut a_i, wd_i
);

    always_ff @(posedge clk_i) begin
        if (we_i && a_i == CFG_MMIO_ADDR.PRINT) begin
            if (wd_i[7:0] == 7'h0A)
                $write("\n");
            else
                $write("%s", unsigned'(wd_i[7:0]));
        end
    end

endmodule : print
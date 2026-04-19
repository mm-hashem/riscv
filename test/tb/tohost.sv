module tohost
    import types_pkg::*;
    import config_pkg::*;
    import tb_utils_pkg::*;
(
    input logic   clk_i,
                  we_i,
    input xlen_ut a_i, wd_i
);

    string TESTNAME;

    always_ff @(posedge clk_i) begin
        if (we_i && a_i == CFG_TOHOST_ADDR) begin
`ifndef RGRS
                $display("\n----- TOHOST Status Code 0x%0x @ %0t ns -----\n", wd_i, $time);  
                dispConfig(TESTNAME); // Displaying the configuration and memory layout
`endif
                writeResult(wd_i, TESTNAME); // Write results to result.txt
                $stop;
        end
    end

    /***** Initialization of the processor *****/

    initial begin : ToHostInit

        // Checking the validity of the test name argument
        if (!$value$plusargs("TESTNAME=%s", TESTNAME))
            $fatal(1, "No TESTNAME specified.");

    end : ToHostInit

endmodule : tohost
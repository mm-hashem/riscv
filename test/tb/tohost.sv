module tohost
    import types_pkg::*;
    import config_pkg::*;
    import tb_utils_pkg::*;
(
    input logic       clk_i,
    ref   logic [7:0] ram [CFG_DATA_ORG:CFG_DATA_END-1] // todo: pass tohost memory location only
);

    xlen_st TOHOST;
    string  TESTNAME;

    always @(posedge clk_i) begin : TOHOST_READ
        for (int i = 0; i < MASK_LEN; i++)
            TOHOST[i*8+:8] = ram[TOHOST_ADDR + i];
    end : TOHOST_READ

    /***** Initialization of the processor *****/

    initial begin : ToHostInit

        // Checking the validity of the test name argument
        if (!$value$plusargs("TESTNAME=%s", TESTNAME))
            $fatal(1, "No TESTNAME specified.");

        wait(TOHOST); // Waiting for TOHOST to be non-zero

`ifndef RGRS
        $display("\n----- TOHOST Status Code 0x%0x @ %0t ns -----\n", TOHOST, $time);  
        dispConfig(TESTNAME); // Displaying the configuration and memory layout
`endif
        
        writeResult(TOHOST, TESTNAME); // Write results to result.txt
        $stop;
    end : ToHostInit

endmodule : tohost
module tohost
    import types_pkg::*;
    import config_pkg::*;
    import tb_utils_pkg::*;
(
    input logic   clk_i,
    input xlen_st TOHOST
);

    string  TESTNAME;

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
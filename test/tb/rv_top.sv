module rv_top
    import types_pkg::*;
    import config_pkg::*;
();

    timeunit 1ns/1ns;

    /***** Declarations *****/
    logic clk, rst;

    /***** Clock Generation *****/
    always #5 clk = ~clk;

    /***** DUT Instantiation *****/
    generate
        if (CFG_CORE == SINGLE) begin : RV_CORE
            rv_single rv_core_inst (
                .clk_i(clk),
                .rst_i(rst)
            );
        end : RV_CORE
        else if (CFG_CORE == STAGE5) begin : RV_CORE
            rv_stage5 rv_core_inst (
                .clk_i(clk),
                .rst_i(rst)
            );
        end : RV_CORE
        else
            $fatal(1, "No core selected.");
    endgenerate

    /***** Bind Instantiation ****/
    binds binds_inst (.clk_i(clk), .rst_i(rst));

    initial begin

        /* Checking the validation of the configuration.
           The simulation will exit if the configuration is invalid. */
        checkConfig();

        clk = 0;
        
        // Resetting core
        rst = 1;

        repeat (3) @(posedge clk);

        // Releasing reset and starting the simulation
        rst <= 0;
    end

endmodule : rv_top
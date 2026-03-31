module memory_loader
    import config_pkg::*;
#(
    parameter string MEM_TYPE,
    parameter int    ORG_ADDR,
                     END_ADDR
)
(
    ref logic [7:0] memory [ORG_ADDR:END_ADDR-1]
);

    string TESTNAME;

    initial begin : MemoryLoaderInit

        // Checking the validity of the test name argument
        if (!$value$plusargs("TESTNAME=%s", TESTNAME))
            $fatal(1, "No TESTNAME specified.");
 
        // Loading the memory content from the corresponding file
        $readmemh({"build/memory/", MEM_TYPE, "_", TESTNAME, ".mem"}, memory);


    end : MemoryLoaderInit

endmodule : memory_loader
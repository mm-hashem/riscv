module testbench
    import types_pkg::*;
    import config_pkg::*;
    import utils_pkg::*;
();

    timeunit 1ns/1ns;

    /***** Declarations *****/

    // DUT Signals
    logic   clk_i, rst_i;
    word_st pc_init_i, pc_tb;
    logic   mem_write_tb,
            reg_write_tb;
    xlen_st regfile_tb [0:31],
            rd_d_tb,
            wd_tb;
    logic [7:0] ram_tb [CFG_DATA_ORG:CFG_DATA_END-1];
    xlen_ut a_tb;
    reg_e   rd_a_tb;
    word_ut instr_tb;

    xlen_st TOHOST;

    /***** DUT Instantiation *****/

    generate
        if (CFG_CORE == SINGLE) begin : RV_CORE
            rv_single rv_core_inst (.*);
        end : RV_CORE
        else if (CFG_CORE == STAGE3) begin : RV_CORE
            rv_stage3 rv_core_inst (.*);
        end : RV_CORE
        else
            $fatal(1, "NO Core");
    endgenerate

    /***** Bind Instantiation ****/

    binds binds_inst (.clk_i, .rst_i);

    /***** Clock Generation *****/

    always #5 clk_i = ~clk_i;
    initial clk_i <= 0;

    /***** TOHOST Monitor *****/

    always @(posedge clk_i) begin : TOHOST_READ
        for (int i = 0; i < MASK_LEN; i++)
            TOHOST[i*8+:8] = ram_tb[TOHOST_ADDR + i];
    end : TOHOST_READ

    /***** Instruction & Data Monitor *****/
    
`ifndef RGRS
    always @(posedge clk_i) begin : CPUMonitor
        $display("[%0t ns] [PC 0x%0x]\n%s instruction", $time, pc_tb, getInstrName(instr_tb));
        if (reg_write_tb)
            $display("%s changed to 0x%x", get_reg_name_f(rd_a_tb), regfile_tb[rd_a_tb]);
        if (mem_write_tb)
            $display("Memory location 0x%0x changed to 0x%0x", a_tb, wd_tb);
    end : CPUMonitor
`endif

    /***** Initialization of the processor *****/

    string TESTNAME;

    initial begin : init

        // Getting test name from vsim arguments
        if (!$value$plusargs("TESTNAME=%s", TESTNAME))
            $fatal(1, "No TESTNAME specified.");

        // Initalizing program and data memories
        $readmemh({"build/memory/text_", TESTNAME, ".mem"}, testbench.RV_CORE.rv_core_inst.instr_rom_inst.rom);
        $readmemh({"build/memory/data_", TESTNAME, ".mem"}, testbench.RV_CORE.rv_core_inst.data_ram_inst.ram);
        
        /*
            Checking the validation of the configuration.
            The simulation will exit if the configuration is invalid.
        */
        checkConfig();

        /*
            Starting the simulatino and initalizing
            the clock, reset, and the initial PC
        */
        clk_i <= 0;
        rst_i <= 1;
        pc_init_i <= '0;
        repeat (3) @(posedge clk_i);
        rst_i <= 0;

        // Waiting until TOHOST memory location is written to
        wait(TOHOST);

`ifndef RGRS
        $display("\n----- TOHOST Status Code 0x%0x @ %0t ns -----\n", TOHOST, $time);
        
        // Displaying the configuration and memory segments details
        dispConfig(TESTNAME);
`endif

        // Write results to result.txt
        writeResult(TOHOST, TESTNAME);
        $stop;

    end : init

endmodule : testbench
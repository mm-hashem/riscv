package config_pkg;

    /***** Memory Configuration *****/

    localparam CFG_TEXT_ORG = 'h0,
               CFG_DATA_ORG = 'h00002400;

    localparam CFG_TEXT_LENGTH  = 'h00002400,
               CFG_DATA_LENGTH  = 'h00000808,
               CFG_STACK_LENGTH = 'h00000400;

    localparam CFG_TEXT_END = CFG_TEXT_ORG + CFG_TEXT_LENGTH;
    localparam CFG_DATA_END = CFG_DATA_ORG + CFG_DATA_LENGTH;

    localparam CFG_STACK_ORG = CFG_DATA_END - CFG_STACK_LENGTH - 8;

    /***** Core Configuration *****/

    typedef enum logic [1:0] {
        SINGLE  = 2'b00,
        STAGE3  = 2'b01,
        UNKNOWN = 2'b10
    } core_e;

`ifdef XLEN
    localparam CFG_XLEN = `XLEN;
`else
    localparam CFG_XLEN = -1;
`endif

`ifdef SINGLE
    localparam core_e CFG_CORE = SINGLE;

`elsif STAGE3
    localparam core_e CFG_CORE = STAGE3;
`else
    localparam core_e CFG_CORE = UNKNOWN;
`endif

`ifdef ZBA
    localparam CFG_ZBA = 1;
`else
    localparam CFG_ZBA = 0;
`endif

    logic [CFG_XLEN-1:0] TOHOST_ADDR = CFG_TEXT_LENGTH + CFG_DATA_LENGTH - 8;
    localparam MASK_LEN = (CFG_XLEN == 64) ? 8 : 4;

    function automatic void checkConfig;
        if (CFG_XLEN == -1)      $fatal(1, "XLEN is not defined.");
        if (CFG_CORE == UNKNOWN) $fatal(1, "Microarchitecture is not defined.");
    endfunction

    function automatic string getExts; // todo: to be expanded when more extensions are added
        if (CFG_ZBA) return "ZBA";
        else         return "";
    endfunction

    function automatic void dispConfig(string testname);
        string core_str, zba_str;

        if      (CFG_CORE == STAGE3) core_str = "3-stage pipeline";
        else if (CFG_CORE == SINGLE) core_str = "Single-cycle";
        if      (CFG_ZBA)            zba_str  = "ZBA";

        $display("\n\n##### CONFIGURATION #####\n",
        "- CFG_CORE  : %s\n",  core_str,
        "- XLEN      : %0d\n", CFG_XLEN,
        "- Extensions: %s\n",  zba_str,
        "- Data Mask : %0d\n", MASK_LEN,
        "##### MEMORY FILES #####\n",
        "- Data Mem File: %s\n", {"build/memory/data_", testname, ".mem"},
        "- Text Mem File: %s\n", {"build/memory/text_", testname, ".mem"},
        "##### Memory Layout #####\n",
        "Text\n",
            "\tStarts at: %d\t0x%0x\n", CFG_TEXT_ORG,    CFG_TEXT_ORG,
            "\tEnds   at: %d\t0x%0x\n", CFG_TEXT_END,    CFG_TEXT_END,
            "\tSize     : %d\t0x%0x\n", CFG_TEXT_LENGTH, CFG_TEXT_LENGTH,
        "Data\n",
            "\tStarts at: %d\t0x%0x\n", CFG_DATA_ORG,    CFG_DATA_ORG,
            "\tEnds   at: %d\t0x%0x\n", CFG_DATA_END-8,  CFG_DATA_END-8,
            "\tSize     : %d\t0x%0x\n", CFG_DATA_LENGTH-8, CFG_DATA_LENGTH-8,
        "Stack\n",
            "\tStarts at: %d\t0x%0x\n", CFG_DATA_END-8,   CFG_DATA_END-8,
            "\tEnds   at: %d\t0x%0x\n", CFG_STACK_ORG,    CFG_STACK_ORG,
            "\tSize     : %d\t0x%0x\n", CFG_STACK_LENGTH, CFG_STACK_LENGTH,
        "TOHOST\n",
            "\tAddress: %0d\t0x%0x\n", TOHOST_ADDR, TOHOST_ADDR,
        "##### Test #####\n",
        "Testbench: tb.sv\n",
        "SW Test: %s\n\n", testname);
    endfunction : dispConfig

endpackage
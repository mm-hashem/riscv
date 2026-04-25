package config_pkg;

    /***** Core Configuration *****/

    typedef enum logic [1:0] {
        SINGLE  = 2'b00,
        STAGE5  = 2'b01,
        UNKNOWN = 2'b10
    } core_e;

`ifdef XLEN
    localparam CFG_XLEN = `XLEN;
`else
    localparam CFG_XLEN = -1;
`endif

`ifdef SINGLE
    localparam core_e CFG_CORE = SINGLE;
`elsif STAGE5
    localparam core_e CFG_CORE = STAGE5;
`else
    localparam core_e CFG_CORE = UNKNOWN;
`endif

`ifdef ZBA
    localparam CFG_ZBA = 1;
`else
    localparam CFG_ZBA = 0;
`endif

    /***** Memory Configuration *****/

    localparam CFG_TEXT_ORG = 'h0,
               CFG_DATA_ORG = 'h00002400;

    localparam CFG_TEXT_LENGTH  = 'h00002400,
               CFG_DATA_LENGTH  = 'h00000800,
               CFG_MMIO_LENGTH  = 'h00000010;

    localparam CFG_TEXT_END = CFG_TEXT_ORG + CFG_TEXT_LENGTH;
    localparam CFG_DATA_END = CFG_DATA_ORG + CFG_DATA_LENGTH + CFG_MMIO_LENGTH;

    localparam CFG_DATA_BYTES  = CFG_XLEN == 64 ? 8 : 4;
    localparam CFG_BYTE_OFFSET = CFG_XLEN == 64 ? 3 : 2; // Number of bits for byte offset within a word

    // Memory indexing
    localparam CFG_TEXT_ORG_ARR    = CFG_TEXT_ORG    / 4, // Word addressing for text memory
               CFG_TEXT_END_ARR    = CFG_TEXT_END    / 4,
               CFG_DATA_ORG_ARR    = CFG_DATA_ORG    / CFG_DATA_BYTES,
               CFG_DATA_END_ARR    = CFG_DATA_END    / CFG_DATA_BYTES,
               CFG_DATA_LENGTH_ARR = CFG_DATA_LENGTH / CFG_DATA_BYTES;

    /***** MMIO *****/

    localparam logic [CFG_XLEN-1:0] CFG_MMIO_ORG = CFG_DATA_ORG + CFG_DATA_LENGTH;

    // Addresses of MMIO in the data memory
    typedef struct {
        logic [CFG_XLEN-1:0] TOHOST; // Address of TOHOST
        logic [CFG_XLEN-1:0] PRINT;  // Address of PRINT
    } CFG_MMIO_ADDR_t;

    localparam CFG_MMIO_ADDR_t CFG_MMIO_ADDR = '{
        TOHOST: CFG_MMIO_ORG,
        PRINT : CFG_MMIO_ORG + CFG_DATA_BYTES
    };

    /***** Functions *****/

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

        if      (CFG_CORE == STAGE5) core_str = "5-stage pipeline"; // todo
        else if (CFG_CORE == SINGLE) core_str = "Single-cycle";
        if      (CFG_ZBA)            zba_str  = "ZBA";

        $display("\n\n##### CONFIGURATION #####\n",
        "- Core      : %s\n",  core_str,
        "- XLEN      : %0d\n", CFG_XLEN,
        "- Extensions: %s\n",  zba_str,
        "- Data Bytes: %0d\n", CFG_DATA_BYTES,
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
            "\tEnds   at: %d\t0x%0x\n", CFG_DATA_END,    CFG_DATA_END,
            "\tSize     : %d\t0x%0x\n", CFG_DATA_LENGTH, CFG_DATA_LENGTH,
        "MMIO\n",
            "\tStarts at: %0d\t0x%0x\n", CFG_MMIO_ADDR.TOHOST, CFG_MMIO_ADDR.TOHOST,
            "\tSize     : %d\t0x%0x\n",  CFG_MMIO_LENGTH, CFG_MMIO_LENGTH,
        "##### Test #####\n",
        "SW Test: %s\n\n", testname);
    endfunction : dispConfig

endpackage
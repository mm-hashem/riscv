module rv_core_abi_assert
    import config_pkg::*;
    import types_pkg::*;
(
    input logic   clk_i, rst_i,
                  mem_write,
    input word_st pc,
    input xlen_st alu_result
);

    // Validating data memory addresses on write operations
    property valid_data_addr;
        @(posedge clk_i)
        disable iff (rst_i)
        mem_write |->
            (alu_result >= CFG_DATA_ORG && alu_result < CFG_DATA_END)
    endproperty : valid_data_addr

    // Validating instruction memory addresses
    property valid_instr_addr;
        @(posedge clk_i)
        disable iff (rst_i)
        (pc >= CFG_TEXT_ORG && pc <= CFG_TEXT_END - 4)
    endproperty : valid_instr_addr

    VALID_DATA_ADDR_CHK : assert property (valid_data_addr);
    VALID_INSTR_ADDR_CHK: assert property (valid_instr_addr);
    
endmodule : rv_core_abi_assert
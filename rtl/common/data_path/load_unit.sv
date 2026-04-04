module load_unit
    import config_pkg::*;
    import types_pkg::*;
(
    input     xlen_st                     read_data_i,
    input var data_ctrl_t                 data_ctrl_i,
    input     logic [CFG_BYTE_OFFSET-1:0] byte_offset_i,
    output    xlen_st                     read_data_sized_o
);
    
    always_comb begin
        unique case (data_ctrl_i)
            {BYTE,  SEXT}: read_data_sized_o =   signed'(read_data_i[byte_offset_i*8 +:  8]); // SignExtended
            {HALF,  SEXT}: read_data_sized_o =   signed'(read_data_i[byte_offset_i*8 +: 16]); // SignExtended
            {WORD,  SEXT}: read_data_sized_o =   signed'(read_data_i[byte_offset_i*8 +: 32]); // SignExtended
            {DWORD, SEXT}: read_data_sized_o =           read_data_i                        ; // [63:0]
            {BYTE,  ZEXT}: read_data_sized_o = unsigned'(read_data_i[byte_offset_i*8 +:  8]); // ZeroExtended
            {HALF,  ZEXT}: read_data_sized_o = unsigned'(read_data_i[byte_offset_i*8 +: 16]); // ZeroExtended
            {WORD,  ZEXT}: read_data_sized_o = unsigned'(read_data_i[byte_offset_i*8 +: 32]); // ZeroExtended
            default      : read_data_sized_o = 'x;
        endcase
    end

endmodule : load_unit
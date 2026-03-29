module load_unit
    import types_pkg::*;
(
    input  xlen_st         read_data_i,
    input  var data_ctrl_t data_ctrl_i,
    output xlen_st         read_data_sized_o
);
    
    always_comb begin
        unique case (data_ctrl_i)
            {BYTE,  SIGNED}  : read_data_sized_o = signed  '(read_data_i[ 7:0]); // SignExtended
            {HALF,  SIGNED}  : read_data_sized_o = signed  '(read_data_i[15:0]); // SignExtended
            {WORD,  SIGNED}  : read_data_sized_o = signed  '(read_data_i[31:0]); // SignExtended
            {DWORD, SIGNED}  : read_data_sized_o =           read_data_i;        // [63:0]
            {BYTE,  UNSIGNED}: read_data_sized_o = unsigned'(read_data_i[ 7:0]); // ZeroExtended
            {HALF,  UNSIGNED}: read_data_sized_o = unsigned'(read_data_i[15:0]); // ZeroExtended
            {WORD,  UNSIGNED}: read_data_sized_o = unsigned'(read_data_i[31:0]); // ZeroExtended
            default          : read_data_sized_o = 'x;
        endcase
    end

endmodule : load_unit
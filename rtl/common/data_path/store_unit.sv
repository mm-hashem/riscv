module store_unit
    import config_pkg::*;
    import types_pkg::*;
(
    input  xlen_st     write_data_i,
    input  data_size_e data_size_i,
    output xlen_st     write_data_sized_o
);
    
    always_comb begin
        unique case (data_size_i)
            BYTE   : write_data_sized_o = write_data_i[ 7:0];
            HALF   : write_data_sized_o = write_data_i[15:0];
            WORD   : write_data_sized_o = write_data_i[31:0];
            DWORD  : write_data_sized_o = write_data_i; // [63:0]
            default: write_data_sized_o = 'x;
        endcase        
    end

endmodule : store_unit
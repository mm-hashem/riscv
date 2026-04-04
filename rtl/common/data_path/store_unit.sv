module store_unit
    import config_pkg::*;
    import types_pkg::*;
(
    input  xlen_st                     write_data_i,
    input  data_size_e                 data_size_i,
    input  logic [CFG_BYTE_OFFSET-1:0] byte_offset_i,
    output logic [CFG_DATA_BYTES-1:0]  byte_enable_o,
    output xlen_st                     write_data_sized_o
);

    always_comb begin
        unique case (data_size_i)
            BYTE: begin
                write_data_sized_o = write_data_i[7:0] << (byte_offset_i * 8);
                byte_enable_o      = 1'b1 << byte_offset_i;
            end
            HALF: begin
                write_data_sized_o = write_data_i[15:0] << (byte_offset_i * 8);
                byte_enable_o      = 2'b11 << byte_offset_i;
            end
            WORD: begin
                write_data_sized_o = write_data_i[31:0] << (byte_offset_i * 8);
                byte_enable_o      = 4'b1111 << byte_offset_i;
            end
            DWORD: begin
                write_data_sized_o = write_data_i; // [63:0]
                byte_enable_o      = {CFG_DATA_BYTES{1'b1}};
            end
            default: begin
                write_data_sized_o = 'x;
                byte_enable_o      = '0;
            end
        endcase        
    end

endmodule : store_unit
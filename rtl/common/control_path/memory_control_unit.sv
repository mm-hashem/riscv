module memory_control_unit
    import funct_pkg::*;
    import types_pkg::*;
(
    input  logic       mem_write_i,
    input  logic [2:0] funct3_i,
    output data_ctrl_t data_ctrl_o
);
    
    // Generates the byte enable and signedness for each load/store instruction
    always_comb begin : DataControl
        if (mem_write_i) begin
            unique case (funct3_i)
                F3_SB  : data_ctrl_o = '{size: BYTE,  sign: ZEXT};
                F3_SH  : data_ctrl_o = '{size: HALF,  sign: ZEXT};
                F3_SW  : data_ctrl_o = '{size: WORD,  sign: ZEXT};
                F3_SD  : data_ctrl_o = '{size: DWORD, sign: ZEXT};
                default: data_ctrl_o = '{size: BYTE,  sign: ZEXT};
            endcase
        end else begin
            unique case (funct3_i)
                F3_LB  : data_ctrl_o = '{size: BYTE,  sign: SEXT};
                F3_LH  : data_ctrl_o = '{size: HALF,  sign: SEXT};
                F3_LW  : data_ctrl_o = '{size: WORD,  sign: SEXT};
                F3_LBU : data_ctrl_o = '{size: BYTE,  sign: ZEXT};
                F3_LHU : data_ctrl_o = '{size: HALF,  sign: ZEXT};
                F3_LWU : data_ctrl_o = '{size: WORD,  sign: ZEXT};
                F3_LD  : data_ctrl_o = '{size: DWORD, sign: SEXT};
                default: data_ctrl_o = '{size: BYTE,  sign: ZEXT};
            endcase
        end
    end : DataControl


endmodule
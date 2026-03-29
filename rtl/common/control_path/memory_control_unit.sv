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
                F3_SB  : data_ctrl_o = '{size: BYTE,  sign: UNSIGNED};
                F3_SH  : data_ctrl_o = '{size: HALF,  sign: UNSIGNED};
                F3_SW  : data_ctrl_o = '{size: WORD,  sign: UNSIGNED};
                F3_SD  : data_ctrl_o = '{size: DWORD, sign: UNSIGNED};
                default: data_ctrl_o = '{size: BYTE,  sign: UNSIGNED};
            endcase
        end else begin
            unique case (funct3_i)
                F3_LB  : data_ctrl_o = '{size: BYTE,  sign: SIGNED};
                F3_LH  : data_ctrl_o = '{size: HALF,  sign: SIGNED};
                F3_LW  : data_ctrl_o = '{size: WORD,  sign: SIGNED};
                F3_LBU : data_ctrl_o = '{size: BYTE,  sign: UNSIGNED};
                F3_LHU : data_ctrl_o = '{size: HALF,  sign: UNSIGNED};
                F3_LWU : data_ctrl_o = '{size: WORD,  sign: UNSIGNED};
                F3_LD  : data_ctrl_o = '{size: DWORD, sign: SIGNED};
                default: data_ctrl_o = '{size: BYTE,  sign: UNSIGNED};
            endcase
        end
    end : DataControl


endmodule
module execute_dp
    import definitions_pkg::*;
(
    input clk_i, rst_i,
    input logic alu_src_ex_i,
    input alu_e  alu_control_ex_i,
    input word_st imm_ext_ex_i,
     pc_ex_i,   
                  rs1_d_ex_i, rs2_d_ex_i,
                  pc_next_4_ex_i, result_ex_i,
     alu_result_ex_i,
    input reg_e rd_a_ex_i,
    input logic [1:0] up_imm_src_ex_i, forward_src_a_ex_i, forward_src_b_ex_i,

    output word_st pc_next_4_ex_o,
                   pc_next_imm_ex_o, pc_next_imm_ex_unreg_o,
                   rs2_d_ex_o,
     alu_result_ex_o,
    output reg_e rd_a_ex_o,
    output logic zero_ex_o, less_than_ex_o
);
    
    word_st alu_result_ex;
    word_st src_a_hz_ex, src_b_hz_ex;
    word_st src_b_ex;
    word_st pc_next_imm_ex;

    // Jump/Branch adder, used for U-type and dalr instructions instructions
    always_comb begin : JmpBrnAdderMux_Ex
        unique case (up_imm_src_ex_i)
            2'b00:   pc_next_imm_ex =              imm_ext_ex_i; // lui
            2'b01:   pc_next_imm_ex = pc_ex_i    + imm_ext_ex_i; // auipc
            2'b10:   pc_next_imm_ex = rs1_d_ex_i + imm_ext_ex_i; // jalr
            default: pc_next_imm_ex = 32'b0;
        endcase
    end : JmpBrnAdderMux_Ex

    // ForwardSrcA Mux
    always_comb begin : ForwardSrcAMuxEx
        case (forward_src_a_ex_i)
            2'b00: src_a_hz_ex = rs1_d_ex_i;
            2'b01: src_a_hz_ex = result_ex_i;
            2'b10: src_a_hz_ex = alu_result_ex_i;
            default: src_a_hz_ex = '0; 
        endcase
    end : ForwardSrcAMuxEx

    // ForwardSrcA Mux
    always_comb begin : ForwardSrcBMuxEx
        case (forward_src_b_ex_i)
            2'b00: src_b_hz_ex = rs2_d_ex_i;
            2'b01: src_b_hz_ex = result_ex_i;
            2'b10: src_b_hz_ex = alu_result_ex_i;
            default: src_b_hz_ex = '0; 
        endcase
    end : ForwardSrcBMuxEx

    // ALUSrc Mux
    assign src_b_ex = alu_src_ex_i ? imm_ext_ex_i : src_b_hz_ex;

    alu alu_ex_inst (
        .alu_control_i(alu_control_ex_i),
        .src_a_i      (src_a_hz_ex),     .src_b_i(src_b_ex),
        .zero_o       (zero_ex_o),
        .alu_result_o (alu_result_ex)
    );

    assign pc_next_imm_ex_unreg_o = pc_next_imm_ex;
    assign less_than_ex_o = alu_result_ex[0];

    always_ff @(posedge clk_i) begin : ExecuteReg
        if (rst_i) begin
            rs2_d_ex_o <= '0;
            pc_next_4_ex_o <= '0;
            rd_a_ex_o <= REG_ZERO;
            alu_result_ex_o <= '0;
            pc_next_imm_ex_o <= '0;
        end else begin
            rs2_d_ex_o <= src_b_hz_ex;
            pc_next_4_ex_o <= pc_next_4_ex_i;
            rd_a_ex_o <= rd_a_ex_i;
            alu_result_ex_o <= alu_result_ex;
            pc_next_imm_ex_o<=pc_next_imm_ex;
        end
    end : ExecuteReg

endmodule
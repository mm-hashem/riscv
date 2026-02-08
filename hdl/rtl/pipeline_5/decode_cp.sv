module decode_cp
    import definitions_pkg::*;
(
    input logic clk_i, rst_i,
    input  opcode_e    op_dc_i,
    input  logic [2:0] funct3_dc_i,
    input  logic       funct7_5_dc_i,
    output imm_src_e   imm_src_dc_o,
    output logic alu_src_dc_o, branch_dc_o, jump_dc_o,mem_write_dc_o, reg_write_dc_o, data_memory_sign_dc_o,
    output alu_e       alu_control_dc_o,
    output logic [2:0] funct3_dc_o,
    output logic [1:0] result_src_dc_o, up_imm_src_dc_o, data_memory_size_dc_o
);

    logic alu_src_dc, jump_dc, branch_dc,mem_write_dc, reg_write_dc, data_memory_sign_dc;
    alu_e alu_control_dc;
    logic [1:0] result_src_dc, up_imm_src_dc, data_memory_size_dc;
    
    controller controller_dc_inst (
        .op_i       (op_dc_i),
        .funct3_i   (funct3_dc_i),
        .funct7_5_i (funct7_5_dc_i),
        .zero_i(), .less_than_i(),
        .branch_o(branch_dc), .jump_o(jump_dc),
        .imm_src_o  (imm_src_dc_o), .alu_control_o(alu_control_dc),
        .alu_src_o  (alu_src_dc), .pc_src_o(), 
        .mem_write_o  (mem_write_dc),.result_src_o (result_src_dc),
        .reg_write_o(reg_write_dc), .up_imm_src_o(up_imm_src_dc),
        .data_memory_sign_o(data_memory_sign_dc),
        .data_memory_size_o(data_memory_size_dc)
    );

    always_ff @(posedge clk_i) begin : DecodeStageCPReg
        if (rst_i) begin
            alu_src_dc_o <= '0;
            alu_control_dc_o <= ALU_ADD;
            branch_dc_o <= '0;
            jump_dc_o <='0;
            funct3_dc_o <='0;
            mem_write_dc_o<='0;
            result_src_dc_o<='0;
            reg_write_dc_o <= '0;
            up_imm_src_dc_o<='0;
            data_memory_size_dc_o <='0;
            data_memory_sign_dc_o <='0;
        end else begin
            alu_src_dc_o <= alu_src_dc;
            alu_control_dc_o <= alu_control_dc;
            branch_dc_o <= branch_dc;
            jump_dc_o <=jump_dc;
            funct3_dc_o <=funct3_dc_i;
            mem_write_dc_o<=mem_write_dc;
            result_src_dc_o<=result_src_dc;
            reg_write_dc_o<=reg_write_dc;
            up_imm_src_dc_o<=up_imm_src_dc;
            data_memory_size_dc_o<=data_memory_size_dc;
            data_memory_sign_dc_o<=data_memory_sign_dc;
        end
    end : DecodeStageCPReg

endmodule
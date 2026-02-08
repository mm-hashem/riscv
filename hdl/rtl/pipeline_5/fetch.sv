module fetch
    import definitions_pkg::*;
(
    input  logic   clk_i, rst_i,
                   pc_src_ft_i,
                   stall_ft_i, stall_dc_i, flush_dc_i,
    input  word_st pc_init_ft_i,
                   pc_next_imm_ft_i,
    output word_32ut instr_ft_o,
    output word_st pc_next_4_ft_o,pc_ft_o
);

    word_st pc_next_ft, pc_ft, pc_next_4_ft;
    word_32ut instr_ft;

    assign pc_next_4_ft = pc_ft + 32'sd4;
    assign pc_next_ft   = pc_src_ft_i ? pc_next_imm_ft_i : pc_next_4_ft;

    always_ff @(posedge clk_i) begin : ProgramCounter_Ft
        if (rst_i) pc_ft <= pc_init_ft_i;
        else if (!stall_ft_i) pc_ft <= pc_next_ft;
    end : ProgramCounter_Ft

    instruction_ram instr_ram_ft_inst (
        .instr_a_i(pc_ft), .instr_o(instr_ft)
    );

    always_ff @(posedge clk_i) begin : FetchReg
        if (rst_i || flush_dc_i) begin
            instr_ft_o <= '0;
            pc_ft_o    <= '0;
            pc_next_4_ft_o <= '0;
        end else if (!stall_dc_i) begin
            instr_ft_o <= instr_ft;
            pc_ft_o    <= pc_ft;
            pc_next_4_ft_o <= pc_next_4_ft;
        end
    end : FetchReg
    
endmodule
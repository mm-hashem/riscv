module pc_control_unit
    import types_pkg::*;
(
    input  logic       zero_i, less_than_i,
                       branch_i, jump_i,
    input  branch_op_e branch_op_i,
    output pc_src_e    pc_src_o
);

    // Note that branch and jump are mutually exclusive
    always_comb begin : PCSrcBlk
        if (jump_i)
            pc_src_o = PCSRC_JMP;
        else if (branch_i) begin
            if (branch_op_i == BRANCH_EQ && zero_i)
                pc_src_o = PCSRC_BR;
            else if (branch_op_i == BRANCH_NE && ~zero_i)
                pc_src_o = PCSRC_BR;
            else if (branch_op_i == BRANCH_LT && less_than_i)
                pc_src_o = PCSRC_BR;
            else if (branch_op_i == BRANCH_GE && ~less_than_i)
                pc_src_o = PCSRC_BR;
            else
                pc_src_o = PCSRC_PC4;
        end else
            pc_src_o = PCSRC_PC4;
    end : PCSrcBlk

endmodule : pc_control_unit
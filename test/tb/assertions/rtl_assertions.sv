module main_decoder_assert
    import types_pkg::*;
(
    input logic    clk_i, rst_i,
                   branch_o, jump_o,
                   mem_write_o, reg_write_o,
    input opcode_e op_i
);

    property branch_op_valid;
        @(posedge clk_i)
        disable iff (rst_i)
        (op_i == OP_B) |-> branch_o
    endproperty : branch_op_valid

    property jump_op_valid;
        @(posedge clk_i)
        disable iff (rst_i)
        (op_i inside {OP_J, OP_I_JALR}) |-> jump_o
    endproperty : jump_op_valid

    property branch_jump_mutex;
        @(posedge clk_i)
        disable iff (rst_i)
        !(branch_o && jump_o)
    endproperty : branch_jump_mutex

    property load_store_mutex;
        @(posedge clk_i)
        disable iff (rst_i)
        (op_i == OP_I_LOAD) |-> !mem_write_o
    endproperty : load_store_mutex

    property mem_reg_write_mutex;
        @(posedge clk_i)
        disable iff (rst_i)
        !(reg_write_o && mem_write_o)
    endproperty

    property illegal_opcode;
        @(posedge clk_i)
        disable iff (rst_i)
        !(op_i inside {OP_I_LOAD, OP_I_ALU, OP_U_AUIPC, OP_S, OP_R, OP_U_LUI,
                       OP_B, OP_I_JALR, OP_J, OP_I_ALU_W, OP_R_W}) |->
        (!mem_write_o && !reg_write_o && !branch_o && !jump_o)
    endproperty : illegal_opcode


    BRANCH_OP_VALID_CHK    : assert property (branch_op_valid);
    JUMP_OP_VALID_CHK      : assert property (jump_op_valid);
    BRANCH_JUMP_MUTEX_CHK  : assert property (branch_jump_mutex);
    LOAD_STORE_MUTEX_CHK   : assert property (load_store_mutex);
    MEM_REG_WRITE_MUTEX_CHK: assert property (mem_reg_write_mutex);
    ILLEGAL_OPCODE_CHK     : assert property (illegal_opcode);


endmodule : main_decoder_assert

module regfile_assert
    import types_pkg::*;
(
    input logic   clk_i, rst_i,
    input reg_e   rs1_a_i, rs2_a_i, rd_a_i,
    input xlen_st rs1_d_o, rs2_d_o
);

    property reg_addr_valid;
        @(posedge clk_i)
        disable iff (rst_i)
        ((rs1_a_i inside {[REG_ZERO:REG_T6]})) && (rs2_a_i inside {[REG_ZERO:REG_T6]}) && (rd_a_i inside {[REG_ZERO:REG_T6]})
    endproperty : reg_addr_valid

    property rs1_zero;
        @(posedge clk_i)
        disable iff (rst_i)
        (rs1_a_i == REG_ZERO) |-> (rs1_d_o == '0)
    endproperty : rs1_zero

    property rs2_zero;
        @(posedge clk_i)
        disable iff (rst_i)
        (rs2_a_i == REG_ZERO) |-> (rs2_d_o == '0)
    endproperty : rs2_zero

    REG_ADDR_VALID_CHK: assert property (reg_addr_valid);
    RS1_ZERO_CHK      : assert property (rs1_zero);
    RS2_ZERO_CHK      : assert property (rs2_zero);

endmodule

module program_counter_assert
(
    input logic              clk_i, rst_i,
    input types_pkg::word_st d_i, q_o
);

    property pc_alignment;
        @(posedge clk_i)
        disable iff (rst_i)
        ((d_i[1:0] == 2'b00) &&
         (q_o[1:0] == 2'b00))
    endproperty : pc_alignment

    PC_ALIGNMENT_CHK: assert property (pc_alignment);

endmodule : program_counter_assert

module rv_core_assert
    import types_pkg::*;
(
    input logic        clk_i,  rst_i,
                       branch, jump,
                       we,
    input pc_src_e     pc_src,
    input data_size_e  data_size,
    input result_src_e result_src,
    input word_st      pc, bta,
                       alu_result,
    input xlen_ut      a
);

    property branch_target_taken;
        @(posedge clk_i)
        disable iff (rst_i)
        (branch && pc_src == PCSRC_BR) |=> (pc == $past(bta));
    endproperty : branch_target_taken

    property jump_target_taken;
        @(posedge clk_i)
        disable iff (rst_i)
        (jump && pc_src == PCSRC_JMP) |=> (pc == $past(alu_result));
    endproperty : jump_target_taken

    property data_ram_addr_alignment;
        @(posedge clk_i)
        disable iff (rst_i)
        (we || result_src == RESULT_MEMORY) |->
             ((data_size == BYTE)                        || // Any address
             ((data_size == HALF)  && (a[0]   == 1'b0))  || // Halfword  -aligned
             ((data_size == WORD)  && (a[1:0] == 2'b00)) || // Word      -aligned
             ((data_size == DWORD) && (a[2:0] == 3'b000)))  // Doubleword-aligned;
    endproperty : data_ram_addr_alignment

    BRANCH_TARGET_TAKEN_CHK    : assert property (branch_target_taken);
    JUMP_TARGET_TAKEN_CHK      : assert property (jump_target_taken);
    DATA_RAM_ADDR_ALIGNMENT_CHK: assert property (data_ram_addr_alignment)
                                    else $fatal(1, "Memory misaligned access at address 0x%x", a);

endmodule : rv_core_assert
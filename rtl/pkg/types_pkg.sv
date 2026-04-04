package types_pkg;

    import config_pkg::CFG_XLEN;

    /***** Type Definitions *****/

    typedef logic signed [CFG_XLEN-1:0] xlen_st;
    typedef logic        [CFG_XLEN-1:0] xlen_ut;
    typedef logic signed [31:0]         word_st;
    typedef logic        [31:0]         word_ut;

    /***** ISA Enums *****/

    typedef enum logic [6:0] {
        OP_I_LOAD  = 7'b0000011,
        OP_I_ALU   = 7'b0010011,
        OP_U_AUIPC = 7'b0010111,
        OP_S       = 7'b0100011,
        OP_R       = 7'b0110011,
        OP_U_LUI   = 7'b0110111,
        OP_B       = 7'b1100011,
        OP_I_JALR  = 7'b1100111,
        OP_J       = 7'b1101111,
        OP_I_ALU_W = 7'b0011011,
        OP_R_W     = 7'b0111011
    } opcode_e;

    typedef enum logic [4:0] { 
        REG_ZERO  = 5'h00, REG_RA  = 5'h01,
        REG_SP    = 5'h02, REG_GP  = 5'h03,
        REG_TP    = 5'h04, REG_T0  = 5'h05,
        REG_T1    = 5'h06, REG_T2  = 5'h07,
        REG_S0_FP = 5'h08, REG_S1  = 5'h09,
        REG_A0    = 5'h0A, REG_A1  = 5'h0B,
        REG_A2    = 5'h0C, REG_A3  = 5'h0D,
        REG_A4    = 5'h0E, REG_A5  = 5'h0F,
        REG_A6    = 5'h10, REG_A7  = 5'h11,
        REG_S2    = 5'h12, REG_S3  = 5'h13,
        REG_S4    = 5'h14, REG_S5  = 5'h15,
        REG_S6    = 5'h16, REG_S7  = 5'h17,
        REG_S8    = 5'h18, REG_S9  = 5'h19,
        REG_S10   = 5'h1A, REG_S11 = 5'h1B,
        REG_T3    = 5'h1C, REG_T4  = 5'h1D,
        REG_T5    = 5'h1E, REG_T6  = 5'h1F
    } reg_e;

    typedef enum logic [2:0] { 
        IMM_I = 3'b000,
        IMM_S = 3'b001,
        IMM_B = 3'b010,
        IMM_J = 3'b011,
        IMM_U = 3'b100
    } imm_src_e;

    /***** ALU Enums *****/

    typedef enum logic [1:0] {
        ALUOP_ADD     = 2'b00,
        ALUOP_BRANCH  = 2'b01,
        ALUOP_REGULAR = 2'b10,
        ALUOP_WORD    = 2'b11
    } alu_op_e;

    typedef enum logic [1:0] { 
        SRCA_RS1 = 2'b00,
        SRCA_0   = 2'b01,
        SRCA_PC  = 2'b10
    } alu_src_a_e;

    typedef enum logic { 
        SRCB_RS2 = 1'b0,
        SRCB_IMM = 1'b1
    } alu_src_b_e;

    typedef enum logic [4:0] {
        ALU_ADD, ALU_SUB,
        ALU_AND, ALU_OR,  ALU_XOR,
        ALU_SLT, ALU_SLTU,
        ALU_SLL, ALU_SRL, ALU_SRA,

        // RV64I Word instructions
        ALU_ADDW, ALU_SUBW,
        ALU_SRLW, ALU_SRAW, ALU_SLLW,

        // Zba
        ALU_SLLUW , ALU_ADDUW,
        ALU_SH1ADD, ALU_SH1ADDUW,
        ALU_SH2ADD, ALU_SH2ADDUW,
        ALU_SH3ADD, ALU_SH3ADDUW
    } alu_e;

    /***** PC/Branch Enums *****/

    typedef enum logic [1:0] { 
        PCSRC_PC4 = 2'b00,
        PCSRC_JMP = 2'b01,
        PCSRC_BR  = 2'b10
    } pc_src_e;
    
    typedef enum logic [1:0] { 
        BRANCH_EQ = 2'b00,
        BRANCH_NE = 2'b01,
        BRANCH_LT = 2'b10,
        BRANCH_GE = 2'b11
    } branch_op_e;

    typedef enum logic [1:0] { 
        RESULT_ALU    = 2'b00,
        RESULT_MEMORY = 2'b01,
        RESULT_PC4    = 2'b10
    } result_src_e;

    /***** Memory Enums *****/

    typedef enum logic [1:0] { 
        BYTE  = 2'b00,
        HALF  = 2'b01,
        WORD  = 2'b10,
        DWORD = 2'b11
    } data_size_e;

    typedef enum logic { 
        ZEXT = 1'b0,
        SEXT = 1'b1
    } data_sign_e;

    typedef struct packed {
        data_size_e size;
        data_sign_e sign;
    } data_ctrl_t;

endpackage
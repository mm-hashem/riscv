package definitions_pkg;

    localparam VERSION = 0.1;

    localparam FNAME_DATA    = "data.mem",
               FNAME_TEXT    = "text.mem",
               FNAME_REGFILE = "regfile.mem";

    localparam TEXT_ORG = 'h0,
               DATA_ORG = 'h400;

    localparam TEXT_LENGTH = 'h400,
               DATA_LENGTH = 'h400;

    localparam TEXT_END = TEXT_ORG + TEXT_LENGTH;
    localparam DATA_END = DATA_ORG + DATA_LENGTH;

`ifdef RV64
    localparam XLEN = 64;
`else
    localparam XLEN = 32;
`endif

    typedef logic signed [XLEN-1:0] word_st;
    typedef logic        [XLEN-1:0] word_ut;
    typedef logic signed [31:0]     word_32st;
    typedef logic        [31:0]     word_32ut;

    typedef enum logic [3:0] {
        ALU_ADD    = 4'b0000, ALU_SUB    = 4'b0001,
        ALU_AND    = 4'b0010, ALU_OR     = 4'b0011,
        ALU_XOR    = 4'b0100, ALU_SLT    = 4'b0101,
        ALU_SLL    = 4'b0110,
        ALU_SRL    = 4'b1000, ALU_SRA    = 4'b1001,
        ALU_SLTU   = 4'b1010,
        ALU_SH0ADD = 4'b1011, ALU_SH1ADD = 4'b1100,
        ALU_SH2ADD = 4'b1101, ALU_SH3ADD = 4'b1110
    } alu_e;
    
    typedef enum logic [6:0] {
        OP_I_LOAD  = 7'b0000011,
        OP_I_ALU   = 7'b0010011,
        OP_U_AUIPC = 7'b0010111,
        OP_S       = 7'b0100011,
        OP_R       = 7'b0110011,
        OP_U_LUI   = 7'b0110111,
        OP_B       = 7'b1100011,
        OP_I_JALR  = 7'b1100111,
        OP_J_JAL   = 7'b1101111,
        OP_I_ECALL = 7'b1110011
`ifdef RV64
        ,OP_I_ALU_W = 7'b0011011,
        OP_R_W      = 7'b0111011
`endif
    } opcode_e;

    typedef enum logic [2:0] { 
        IMM_I = 3'b000,
        IMM_S = 3'b001,
        IMM_B = 3'b010,
        IMM_J = 3'b011,
        IMM_U = 3'b100
    } imm_src_e;

    //////////////////
    ///// funct3 /////
    //////////////////
    typedef enum logic [2:0] { 
        F3_LB  = 3'b000,
        F3_LH  = 3'b001,
        F3_LW  = 3'b010,
        F3_LBU = 3'b100,
        F3_LHU = 3'b101
    } funct3_i_load_e;

    typedef enum logic [2:0] { 
        F3_ADDI  = 3'b000,
        F3_SLLI  = 3'b001,
        F3_SLTI  = 3'b010,
        F3_SLTIU = 3'b011,
        F3_XORI  = 3'b100,
        F3_SRI   = 3'b101,
        F3_ORI   = 3'b110,
        F3_ANDI  = 3'b111
    } funct3_i_alu_e;

    typedef enum logic [2:0] { 
        F3_SB  = 3'b000,
        F3_SH  = 3'b001,
        F3_SW  = 3'b010
    } funct3_s_e;

    typedef enum logic [2:0] { 
        F3_ADD_SUB = 3'b000,
        F3_SLL     = 3'b001,
        F3_SLT     = 3'b010,
        F3_SLTU    = 3'b011,
        F3_XOR     = 3'b100,
        F3_SR      = 3'b101,
        F3_OR      = 3'b110,
        F3_AND     = 3'b111
    } funct3_r_e;

    typedef enum logic [2:0] { 
        F3_BEQ  = 3'b000,
        F3_BNE  = 3'b001,
        F3_BLT  = 3'b100,
        F3_BGE  = 3'b101,
        F3_BLTU = 3'b110,
        F3_BGEU = 3'b111
    } funct3_b_e;

    typedef enum logic [2:0] { 
        F3_JALR = 3'b000
    } funct3_i_jalr_e;

    //////////////////
    ///// funct7 /////
    //////////////////

    typedef enum logic [6:0] {
        F7_I_SLI  = 7'b0000000,
        F7_I_SRAI = 7'b0100000
    } funct7_i_alu_e;

    typedef enum logic [6:0] {
        F7_R_SLI  = 7'b0000000,
        F7_R_SRAI = 7'b0100000
    } funct7_r_e;
    /////////////////////
    ///// Registers /////
    /////////////////////

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

    function automatic string get_reg_name_f (int i);
        reg_e reg_name = reg_e'(i);
        return reg_name.name();
    endfunction

    /////////////////////////////
    ///// Instruction Types /////
    /////////////////////////////
    typedef struct packed {
        logic [11:0]    imm_11_0;
        reg_e           rs1;
        funct3_i_load_e funct3;
        reg_e           rd;
        opcode_e        op;
    } instruction_i_load_t;

    typedef struct packed {
        logic [11:0]   imm_11_0;
        reg_e          rs1;
        funct3_i_alu_e funct3;
        reg_e          rd;
        opcode_e       op;
    } instruction_i_alu_t;

    typedef struct packed {
        logic [6:0] funct7;
        reg_e rs2;
        reg_e rs1;
        funct3_r_e funct3;
        reg_e rd;
        opcode_e op;
    } instruction_r_t;

    typedef struct packed {
        logic [11:5] imm_11_5;
        reg_e rs2;
        reg_e rs1;
        funct3_s_e funct3;
        logic [4:0] imm_4_0;
        opcode_e op;
    } instruction_s_t;

    typedef struct packed {
        logic [12:12] imm_12;
        logic [10:5] imm_10_5;
        reg_e rs2;
        reg_e rs1;
        funct3_b_e funct3;
        logic [4:1] imm_4_1;
        logic [11:11] imm_11;
        opcode_e op;
    } instruction_b_t;

    typedef struct packed {
        logic [31:12] imm_31_12;
        reg_e rd;
        opcode_e op;
    } instruction_u_t;
    
    typedef struct packed {
        logic [20:20] imm_20;
        logic [10:1] imm_10_1;
        logic [11:11] imm_11;
        logic [19:12] imm_19_12;
        reg_e rd;
        opcode_e op;
    } instruction_j_t;

    typedef struct packed {
        logic [11:0]   imm_11_0;
        reg_e          rs1;
        funct3_i_alu_e funct3;
        reg_e          rd;
        opcode_e       op;
    } instruction_i_jalr_t;

/*     typedef union packed {
        instruction_r_t      r;
        instruction_i_load_t i_load;
        instruction_i_alu_t  i_alu;
        instruction_i_jalr_t i_jalr;
        instruction_s_t      s;
        instruction_b_t      b;
        instruction_u_t      u;
        instruction_j_t      j;
        word_st              instr;
    } instruction_t; */

    


    //function automatic sign_extender_f;
    //    ;
    //    
    //endfunction
    
endpackage: definitions_pkg
package funct_pkg;

    //////////////////
    ///// funct3 /////
    //////////////////
    typedef enum logic [2:0] { 
        F3_LB  = 3'b000,
        F3_LH  = 3'b001,
        F3_LW  = 3'b010,
        F3_LBU = 3'b100,
        F3_LHU = 3'b101,
        F3_LWU = 3'b110,
        F3_LD  = 3'b011
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
        F3_SB = 3'b000,
        F3_SH = 3'b001,
        F3_SW = 3'b010,
        F3_SD = 3'b011
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
    } funct7_shift;

    typedef enum logic [6:0] {
        F7_ADD = 7'b0000000,
        F7_SUB = 7'b0100000
    } funct7_add_sub;
    
endpackage: funct_pkg
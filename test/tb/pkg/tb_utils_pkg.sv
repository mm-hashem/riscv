package tb_utils_pkg;
    import types_pkg::*;
    import funct_pkg::*;
    import config_pkg::*;

    function automatic string get_reg_name_f (int i);
        reg_e  reg_name = reg_e'(i);
        return reg_name.name();
    endfunction
    
    function automatic void writeResult(xlen_st exit_code, string testname);
        int results_f = $fopen("./build/results.txt", "a");
        if (results_f) $fdisplay(results_f, "Test: %s, Exit code: %0d", testname, exit_code);
        else           $display("RESULTS WERE NOT LOGGED");
    endfunction

    function automatic string getInstrName (word_ut instr);
        case (instr[6:0])
            OP_I_LOAD: begin
                case (instr[14:12])
                    F3_LB  : getInstrName = "lb";
                    F3_LH  : getInstrName = "lh";
                    F3_LW  : getInstrName = "lw";
                    F3_LBU : getInstrName = "lbu";
                    F3_LHU : getInstrName = "lhu";
                    F3_LWU : getInstrName = "lwu";
                    F3_LD  : getInstrName = "ld";
                    default: getInstrName = "Unknown I Load";
                endcase
            end
            OP_I_ALU: begin
                case (instr[14:12])
                    F3_ADDI : getInstrName = "addi";
                    F3_SLLI : getInstrName = "slli";
                    F3_SLTI : getInstrName = "slti";
                    F3_SLTIU: getInstrName = "sltiu";
                    F3_XORI : getInstrName = "xori";
                    F3_SRI  : getInstrName = "sri";
                    F3_ORI  : getInstrName = "ori";
                    F3_ANDI : getInstrName = "andi";
                    default : getInstrName = "Unknown I ALU";
                endcase
            end
            OP_S: begin
                case (instr[14:12])
                    F3_SB  : getInstrName = "sb";
                    F3_SH  : getInstrName = "sh";
                    F3_SW  : getInstrName = "sw";
                    F3_SD  : getInstrName = "sd";
                    default: getInstrName = "Unknown S";
                endcase
            end
            OP_R: begin
                case (instr[14:12])
                    F3_ADD_SUB: begin
                        case(instr[31:25])
                            F7_ADD : getInstrName = "add";
                            F7_SUB : getInstrName = "sub";
                            default: getInstrName = "Unknown R ADD/SUB";
                        endcase
                    end
                    F3_SLL    : getInstrName = "sll";
                    F3_SLT    : getInstrName = "slt";
                    F3_SLTU   : getInstrName = "sltu";
                    F3_XOR    : getInstrName = "xor";
                    F3_SR     : getInstrName = "sr";
                    F3_OR     : getInstrName = "or";
                    F3_AND    : getInstrName = "and";
                    default   : getInstrName = "Unknown R";
                endcase
            end
            OP_B: begin
                case (instr[14:12])
                    F3_BEQ : getInstrName = "beq";
                    F3_BNE : getInstrName = "bne";
                    F3_BLT : getInstrName = "blt";
                    F3_BGE : getInstrName = "bge";
                    F3_BLTU: getInstrName = "bltu";
                    F3_BGEU: getInstrName = "bgeu";
                    default: getInstrName = "Unknown B";
                endcase
            end
            OP_I_ALU_W: begin
                case (instr[14:12])
                    F3_ADDI: getInstrName = "addiw";
                    F3_SLLI: getInstrName = "slliw";
                    F3_SRI : getInstrName = "sriw";
                    default: getInstrName = "Unknown I ALU W";
                endcase
            end
            OP_R_W: begin
                case (instr[14:12])
                    F3_ADD_SUB: begin 
                        case(instr[31:25])
                            F7_ADD : getInstrName = "addw";
                            F7_SUB : getInstrName = "subw";
                            default: getInstrName = "Unknown R W ADD/SUB";
                        endcase
                    end
                    F3_SLL    : getInstrName = "sllw";
                    F3_SR     : getInstrName = "srw";
                    default   : getInstrName = "Unknown R W";
                endcase
            end
            OP_U_AUIPC: getInstrName = "auipc";
            OP_U_LUI  : getInstrName = "lui";
            OP_I_JALR : getInstrName = "jalr";
            OP_J      : getInstrName = "jal";
            default   : getInstrName = "Unknown opcode";
        endcase
    endfunction


endpackage
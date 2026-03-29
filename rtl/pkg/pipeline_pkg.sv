package pipeline_pkg;
    import types_pkg::*;

    typedef struct packed {
        word_ut instr;
        word_st pc,
                pc_plus_4;
    } if_dc_t;

    typedef struct packed {

        struct packed {
            logic        branch,    jump,
                         reg_write, mem_write;
            branch_op_e  branch_op;
            result_src_e result_src;
            alu_e        alu_ctrl;
            alu_src_a_e  alu_a_src;
            alu_src_b_e  alu_b_src;
            imm_src_e    imm_src;
            data_ctrl_t  data_ctrl;
        } ctrl;

        struct packed {
            reg_e   rd_a;
            xlen_st rs1_d,
                    rs2_d,
                    imm_ext;
            word_st pc_plus_4,
                    pc;
        } data;

    } dc_s3_t;

endpackage
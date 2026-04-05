package pipeline_pkg;
    import types_pkg::*;

    // Fetch -> Decode -> Execute -> Memory -> Writeback

    typedef struct packed {
        word_ut instr;
        word_st pc,
                pc_plus_4;
    } ft_dc_t;
    
    // 3-stage pipeline
    typedef struct packed {

        struct packed {
            logic        branch,    jump,
                         reg_write, mem_write;
            branch_op_e  branch_op;
            result_src_e result_src;
            alu_e        alu_ctrl;
            alu_src_a_e  alu_a_src;
            alu_src_b_e  alu_b_src;
            data_ctrl_t  data_ctrl;
            reg_e   rd_a;
        } ctrl;

        struct packed {
            xlen_st rs1_d,
                    rs2_d,
                    imm_ext;
            word_st pc_plus_4,
                    pc;
        } data;

    } dc_s3_t;

    /***** 5-stage pipeline *****/
    
    typedef struct packed {
        struct packed {
            logic        branch,    jump,
                         reg_write, mem_write;
            branch_op_e  branch_op;
            result_src_e result_src;
            alu_e        alu_ctrl;
            alu_src_a_e  alu_a_src;
            alu_src_b_e  alu_b_src;
            data_ctrl_t  data_ctrl;
            reg_e        rd_a, rs1_a, rs2_a;
        } ctrl;

        struct packed {
            xlen_st rs1_d,
                    rs2_d,
                    imm_ext;
            word_st pc_plus_4,
                    pc;
        } data;

    } dc_ex_t;

    typedef struct packed {

        struct packed {
            result_src_e result_src;
            logic        mem_write, reg_write;
            data_ctrl_t  data_ctrl;
            reg_e        rd_a;
        } ctrl;
        

        struct packed {
            xlen_st alu_result, src_b_fwd_ex_data;
            word_st pc_plus_4;
        } data;

    } ex_me_t;

    typedef struct packed {

        struct packed {
            result_src_e result_src;
            logic        reg_write;
            data_ctrl_t  data_ctrl;
            reg_e        rd_a;
        } ctrl;

        struct packed {
            xlen_st alu_result, src_b_fwd_ex_data;
            word_st pc_plus_4;
        } data;

    } me_wb_t;

endpackage
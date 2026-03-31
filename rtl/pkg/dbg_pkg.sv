package dbg_pkg;

    import types_pkg::*;

    typedef struct packed {
        word_st     pc, bta; 
        word_ut     instr;
        xlen_ut     a;
        xlen_st     rd_d, wd, alu_result;
        logic       mem_write,
                    reg_write,
                    branch,
                    jump;
        reg_e       rd_a;
        pc_src_e   pc_src;
    } core_dbg_t;

endpackage
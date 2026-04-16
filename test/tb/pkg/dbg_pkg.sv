package dbg_pkg;

    import types_pkg::*;

    typedef struct packed {
        word_st      pc, bta; 
        word_ut      instr;
        xlen_ut      a;
        xlen_st      result, wd, alu_result;
        logic        mem_write,
                     reg_write,
                     branch,
                     jump;
        pc_src_e     pc_src;
        data_size_e  data_size;
        result_src_e result_src;
        reg_e        rd_a;
    } core_dbg_t;

endpackage
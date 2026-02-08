module rv32i_pipe
    import definitions_pkg::*;
(
    input  logic   clk_i, rst_i,
    input  word_st pc_init_i
);
    timeunit 1ns/1ns;

    ///////////////////////////////////////////////
    //////////////////// Fetch ////////////////////
    ///////////////////////////////////////////////

    // ft2dc are registered

    word_32ut instr_ft2dc;
    word_st pc_ft2dc,
            pc_next_4_ft2dc,
            pc_next_imm_ex2ft,pc_next_imm_ex2mr;
    logic pc_src_ex2ft,stall_ft, stall_dc, flush_dc;

    fetch fetch_inst(
        .clk_i, .rst_i,
        .pc_src_ft_i(pc_src_ex2ft),
        .pc_init_ft_i(pc_init_i),
        .pc_next_imm_ft_i(pc_next_imm_ex2ft),
        .stall_ft_i(stall_ft), .stall_dc_i(stall_dc), .flush_dc_i(flush_dc),
        .instr_ft_o(instr_ft2dc), .pc_ft_o(pc_ft2dc),
        .pc_next_4_ft_o(pc_next_4_ft2dc)
    );

    ////////////////////////////////////////////////
    //////////////////// Decode ////////////////////
    ////////////////////////////////////////////////

    ////////// Controlpath of Decode stage
    imm_src_e imm_src_dc;
    logic alu_src_dc2ex, branch_dc2ex, jump_dc2ex, mem_write_dc2ex, reg_write_dc2ex,data_memory_sign_dc2ex;
    alu_e alu_control_dc2ex;
    logic [1:0] result_src_dc2ex, up_imm_src_dc2ex, data_memory_size_dc2ex;
    logic [2:0] funct3_dc2ex;


    decode_cp decode_cp_inst (
        .clk_i, .rst_i,
        .op_dc_i(opcode_e'(instr_ft2dc[6:0])),
        .funct3_dc_i(instr_ft2dc[14:12]),
        .funct7_5_dc_i(instr_ft2dc[30]),
        
        .imm_src_dc_o(imm_src_dc),
        .alu_src_dc_o(alu_src_dc2ex),
        .alu_control_dc_o(alu_control_dc2ex),
        .branch_dc_o(branch_dc2ex), .jump_dc_o(jump_dc2ex),
        .mem_write_dc_o(mem_write_dc2ex),
        .result_src_dc_o(result_src_dc2ex),
        .reg_write_dc_o(reg_write_dc2ex),
        .up_imm_src_dc_o(up_imm_src_dc2ex),
        .data_memory_size_dc_o(data_memory_size_dc2ex),
        .data_memory_sign_dc_o(data_memory_sign_dc2ex),
        .funct3_dc_o(funct3_dc2ex)
    );

    //////// Datapath of Decode stage

    word_st imm_ext_dc2ex;
    word_st rs1_d_dc2ex, rs2_d_dc2ex, pc_dc2ex, pc_next_4_dc2ex;
    reg_e rd_a_dc2ex, rs1_a_dc2ex, rs2_a_dc2ex;
    reg_e rd_a_mr2wb;
    word_st result_wb2dc;
    logic reg_write_mr2wb, flush_ex;

    decode_dp decode_dp_inst (
        .clk_i, .rst_i,
        .reg_write_dc_i(reg_write_mr2wb), .imm_src_dc_i(imm_src_dc),
        .instr_dc_i(instr_ft2dc),
        .result_dc_i(result_wb2dc),
        .rd_a_dc_i(rd_a_mr2wb), .flush_ex_i(flush_ex),
        .pc_dc_i(pc_ft2dc), .pc_next_4_dc_i(pc_next_4_ft2dc),

        .rs1_d_dc_o(rs1_d_dc2ex), .rs2_d_dc_o(rs2_d_dc2ex),
        .imm_ext_dc_o(imm_ext_dc2ex), .rd_a_dc_o(rd_a_dc2ex),
        .pc_dc_o(pc_dc2ex), .pc_next_4_dc_o(pc_next_4_dc2ex),
        .rs1_a_dc_o(rs1_a_dc2ex), .rs2_a_dc_o(rs2_a_dc2ex)
    );

    /////////////////////////////////////////////////
    //////////////////// Execute ////////////////////
    /////////////////////////////////////////////////

    // Controlpath of Execute stage
    logic zero_ex, less_than_ex, mem_write_ex2mr, reg_write_ex2mr;
    logic [1:0] result_src_ex2mr, data_memory_size_ex2mr;

    execute_cp execute_cp_inst (
        .clk_i, .rst_i,
        .zero_ex_i(zero_ex), .jump_ex_i(jump_dc2ex),
        .branch_ex_i(branch_dc2ex), .less_than_ex_i(less_than_ex),
        .funct3_ex_i(funct3_dc2ex), .mem_write_ex_i(mem_write_dc2ex),
        .pc_src_ex_o(pc_src_ex2ft), .mem_write_ex_o(mem_write_ex2mr),
        .result_src_ex_i(result_src_dc2ex), .result_src_ex_o(result_src_ex2mr),
        .reg_write_ex_i(reg_write_dc2ex), .reg_write_ex_o(reg_write_ex2mr),
        .data_memory_size_ex_i(data_memory_size_dc2ex), .data_memory_size_ex_o(data_memory_size_ex2mr),
        .data_memory_sign_ex_i(data_memory_sign_dc2ex), .data_memory_sign_ex_o(data_memory_sign_ex2mr)
    );

    // Datapath
    logic [1:0] forward_src_a_ex, forward_src_b_ex; // Hazard Control signals

    word_st alu_result_ex2mr;
    word_st rs2_d_ex2mr, pc_next_4_ex2mr;
    reg_e rd_a_ex2mr;

    execute_dp execute_dp_inst (
        .clk_i, .rst_i,
        .up_imm_src_ex_i(up_imm_src_dc2ex), .alu_src_ex_i(alu_src_dc2ex),
        .alu_control_ex_i(alu_control_dc2ex),
        .imm_ext_ex_i(imm_ext_dc2ex), .pc_ex_i(pc_dc2ex),
        .rs1_d_ex_i(rs1_d_dc2ex), .rs2_d_ex_i(rs2_d_dc2ex),
        .pc_next_4_ex_i(pc_next_4_dc2ex),
        .rd_a_ex_i(rd_a_dc2ex), .result_ex_i(result_wb2dc),
        .forward_src_a_ex_i(forward_src_a_ex), .forward_src_b_ex_i(forward_src_b_ex),
        .alu_result_ex_i(alu_result_ex2mr),

        .pc_next_4_ex_o(pc_next_4_ex2mr), .rs2_d_ex_o(rs2_d_ex2mr),
        .pc_next_imm_ex_o(pc_next_imm_ex2mr), .pc_next_imm_ex_unreg_o(pc_next_imm_ex2ft), .alu_result_ex_o(alu_result_ex2mr),
        .rd_a_ex_o(rd_a_ex2mr), .zero_ex_o(zero_ex), .less_than_ex_o(less_than_ex)
    );

    ////////////////////////////////////////////////
    //////////////////// Memory ////////////////////
    ////////////////////////////////////////////////

    // controlpath of memory stage
    logic [1:0] result_src_mr2wb;
    

    memory_cp memory_cp_inst (
        .clk_i, .rst_i,
        .result_src_mr_i(result_src_ex2mr),
        .result_src_mr_o(result_src_mr2wb),
        .reg_write_mr_i(reg_write_ex2mr),
        .reg_write_mr_o(reg_write_mr2wb)
    );

    // datapath of memory stage
    word_st alu_result_mr2wb;
    word_st read_data_sized_mr2wb, pc_next_4_mr2wb, pc_next_imm_mr2wb;

    memory_dp memory_dp_inst (
        .clk_i, .rst_i,
        .data_memory_sign_mr_i(data_memory_sign_ex2mr),
        .data_memory_size_mr_i(data_memory_size_ex2mr),
        .mem_write_mr_i(mem_write_ex2mr),

        .rs2_d_mr_i(rs2_d_ex2mr),
        .alu_result_mr_i(alu_result_ex2mr),
        .pc_next_4_mr_i(pc_next_4_ex2mr),
        .pc_next_imm_mr_i(pc_next_imm_ex2mr),
        .rd_a_mr_i(rd_a_ex2mr),

        .pc_next_4_mr_o(pc_next_4_mr2wb),
        .pc_next_imm_mr_o(pc_next_imm_mr2wb),.read_data_sized_mr_o(read_data_sized_mr2wb),
        .rd_a_mr_o(rd_a_mr2wb), .alu_result_mr_o(alu_result_mr2wb)
    );

    ///////////////////////////////////////////////////
    //////////////////// Writeback ////////////////////
    ///////////////////////////////////////////////////

    writeback writeback_inst (
        .result_src_wb_i(result_src_mr2wb),
        .alu_result_wb_i(alu_result_mr2wb),     
        .read_data_sized_wb_i(read_data_sized_mr2wb),
        .pc_next_4_wb_i(pc_next_4_mr2wb),      
        .pc_next_imm_wb_i(pc_next_imm_mr2wb),

        .result_wb_o(result_wb2dc)
    );

    /////////////////////////////////////////////////////
    //////////////////// Hazard Unit ////////////////////
    /////////////////////////////////////////////////////

    hazard_unit hazard_unit_inst (
        .rs1_a_ex_i(rs1_a_dc2ex), .rs2_a_ex_i(rs2_a_dc2ex),
        .rs1_a_dc_i(reg_e'(instr_ft2dc[19:15])), .rs2_a_dc_i(reg_e'(instr_ft2dc[24:20])),
        .rd_a_ex_i(rd_a_dc2ex), .rd_a_mr_i(rd_a_ex2mr), .rd_a_wb_i(rd_a_mr2wb),
        .reg_write_mr_i(reg_write_ex2mr), .reg_write_wb_i(reg_write_mr2wb), .pc_src_ex_i(pc_src_ex2ft),
        .result_src_ex_i(result_src_dc2ex),
        .stall_ft_o(stall_ft), .stall_dc_o(stall_dc), .flush_ex_o(flush_ex), .flush_dc_o(flush_dc),
        .forward_src_a_ex_o(forward_src_a_ex), .forward_src_b_ex_o(forward_src_b_ex)
    );

endmodule : rv32i_pipe
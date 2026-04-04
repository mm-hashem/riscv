module monitor
    import types_pkg::*;
    import tb_utils_pkg::*;
(
    input logic   clk_i,     rst_i,
                  reg_write, mem_write,
    input word_st pc,
    input word_ut instr,
    input xlen_st rd_d,
    input xlen_ut a, wd_i,
    input reg_e   rd_a
);

    //string instr_name;

    always @(posedge clk_i) begin : CPUMonitor
        if (!rst_i) begin
            //instr_name = getInstrName(instr, rd_a);
            $display("[%0t ns] [PC 0x%0x]", $time, pc/* , instr_name */);
            if (reg_write)
                $display("%s changed to 0x%x", get_reg_name_f(rd_a), rd_d);
            if (mem_write)
                $display("Memory location 0x%0x changed to 0x%0x", a, wd_i);
        end
    end : CPUMonitor
    
endmodule : monitor
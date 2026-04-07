module instruction_rom
    import config_pkg::*;
    import types_pkg::*;
(
    input  logic   clk_i, rst_i,
                   en_i,
    input  word_ut instr_a_i,
    output word_ut instr_o
);

    (*rom_style = "block" *) logic [31:0] rom [CFG_TEXT_ORG_ARR:CFG_TEXT_END_ARR-1];

`ifdef SYNTH
    initial $readmemh("../memory_fpga/text.mem", rom);
`endif

    always_ff @(posedge clk_i) begin
        if (en_i) begin
            if (rst_i) instr_o <= '0;
            else       instr_o <= rom[instr_a_i[31:2]];
        end
    end

endmodule: instruction_rom
module instruction_rom
    import config_pkg::*;
    import types_pkg::*;
(
    input  word_ut instr_a_i,
    output word_ut instr_o
);

    logic [7:0] rom [CFG_TEXT_ORG:CFG_TEXT_END-1];

    always_comb
        for (int i = 0; i < 4; i++)
            instr_o[i*8+:8] = rom[instr_a_i + i];

endmodule: instruction_rom
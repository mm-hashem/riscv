module instruction_rom
    import config_pkg::*;
    import types_pkg::*;
(
    input  word_ut instr_a_i,
    output word_ut instr_o
);

    (*rom_style = "block" *) logic [31:0] rom [CFG_TEXT_ORG_ARR:CFG_TEXT_END_ARR-1];

`ifdef SYNTH
    initial $readmemh("./build/memory/text.mem", rom); // todo path and name
`endif

    assign instr_o = rom[instr_a_i[31:2]];

endmodule: instruction_rom
// This is not necessary synthesizable.
module instruction_ram
    import definitions_pkg::*;
(
    input  word_ut instr_a_i, // Instruction Address
    output word_ut instr_o    // Instruction
);
    timeunit 1ns/1ns;

    localparam VERSION = 0.1;

    logic [7:0] ram [TEXT_ORG:TEXT_END-1];

    initial $readmemh(FNAME_TEXT, ram);

    assign instr_o = { << 8{ram[instr_a_i+:4]} };
    
endmodule: instruction_ram
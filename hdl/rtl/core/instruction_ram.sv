module instruction_ram
    import definitions_pkg::*;
(
    input  word_ut   instr_a_i, // Instruction Address
    output word_32ut instr_o    // Instruction
);
    timeunit 1ns/1ns;

    localparam VERSION = 0.1;

    logic [7:0] ram [TEXT_ORG:TEXT_END-1];

    initial $readmemh(FNAME_TEXT, ram);

    always_comb begin
        instr_o[ 7: 0] = ram[instr_a_i + 0];
        instr_o[15: 8] = ram[instr_a_i + 1];
        instr_o[23:16] = ram[instr_a_i + 2];
        instr_o[31:24] = ram[instr_a_i + 3];
    end
    
endmodule: instruction_ram
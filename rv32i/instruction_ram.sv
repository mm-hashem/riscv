// This is not necessary synthesizable.
module instruction_ram
    import definitions_pkg::*;
(
    input  word_ut a_i, // Instruction Address
    output word_st rd_o  // Instruction
);
    timeunit 1ns/1ns;

    localparam VERSION = 0.1;

    logic [7:0] ram [INSTR_SIZE];

    initial $readmemh(FNAME_INSTR, ram);

    assign rd_o = {ram[a_i+3], ram[a_i+2], ram[a_i+1], ram[a_i]};
    
endmodule: instruction_ram
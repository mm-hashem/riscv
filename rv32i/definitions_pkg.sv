package definitions_pkg;

    localparam FNAME_DATA  = "data.mem",
               FNAME_INSTR = "instr.mem";
               
    localparam INSTR_SIZE = 8209,
               DATA_SIZE  = 2321;

    typedef logic signed [31:0] word_st;
    typedef logic        [31:0] word_ut;

    typedef enum logic [2:0] { ADD = 3'b000, SUB = 3'b001,
                               AND = 3'b010, OR  = 3'b011,
                               XOR = 3'b100, SLT = 3'b101,
                               SLL = 3'b110 } alu_t;
    
endpackage: definitions_pkg
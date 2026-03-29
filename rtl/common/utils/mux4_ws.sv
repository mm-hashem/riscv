module mux4_ws // word_st
    import types_pkg::*;
(
    input  word_st     i0, i1, i2, i3,
    input  logic [1:0] sel,
    output word_st     y
);

    always_comb begin
        case (sel)
            2'b00   : y = i0;
            2'b01   : y = i1;
            2'b10   : y = i2;
            2'b11   : y = i3;
            default : y = 'x;
        endcase
    end
    
endmodule